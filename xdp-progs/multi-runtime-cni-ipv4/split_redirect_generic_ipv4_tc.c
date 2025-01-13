/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/pkt_cls.h>
#include <linux/in6.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <bpf/bpf_endian.h>
#include <stddef.h>
#include <linux/udp.h>

#define MAX_MAP_ENTRIES 8


/*
Attach to workload network namespace lo egress, redirect to network namespace eth0 egress. But it's pretty flexible, allows an if index per redirect target.
Target use: takes packets sent by a runtime workload (container, VM etc) to "localhost" and duplicates to redirect outside the workload
Depending on routing options outside the workload, may be used to redirect to those directly
=> max 1 for containers since all containers share an IP
=> one per (micro)VM
=> TBD WASI

*/


struct split_route {
	__u32 active;
	__u32 targetifindex;
	//struct in6_addr ipv6_saddr;
	__u32 ipv4_daddr;
	unsigned char smac[6];
	unsigned char dmac[6];

	/*unsigned int split_on_source_ip;
	struct in6_addr ipv6_saddr;
	unsigned int split_on_dest_ip;
	struct in6_addr ipv6_daddr;*/
};

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, __u32);   // index
	__type(value, struct split_route); // dest IPvx info (6 for now)
} tc_split_map SEC(".maps");


static __always_inline __u16 ipv4_check(__u8 *packet, __u16 len, void* data_end) {
    __u32 csum = 0;

	//reset checksum value
	*(packet + 10) = 0;
	*(packet + 11) = 0;

	//really messy code due to EBPF verifier crap. We shouldn't have to go beyond 60 bytes (max ipv4 header size w/ options)
    for (int i = 0; i < 60 && len > 1; i+=2) {
		if ((void*)(packet + 2) <= data_end) {
			csum += (*packet) * 256 + (*(packet+1));
		}

		packet += 2;
		len -= 2;
    }
	if (len > 0) {
		if ((void*)(packet + 1) > data_end) {
			return 0;
		}
		csum += (*packet);
	}

	int i = 0;
    while (csum >> 16 && i < 16) {
        csum = (csum & 0xFFFF) + (csum >> 16);
		i++;
	}

	//bpf_printk("csum %08x", csum);

    __u16 checksum = (__u16)~csum;
	return checksum;
}

static __always_inline int clone_redir(__u32 i, struct __sk_buff *skb) {
	//bpf_printk("clone_redir %d\n", i); 
	struct split_route* lhinfo;
	lhinfo = bpf_map_lookup_elem(&tc_split_map, &i);
	/*if (lhinfo == 0) {
		bpf_printk("no lh info for %d\n", i); 
	}*/
	if (lhinfo != 0 && lhinfo->active) {
		//bpf_printk("lh info"); //, &(tninfo->ip), &(tninfo->port));

		//since bpf_clone_redirect messes things up hard (potentially), we have to do all these checks again or the verifier will nag at us
		void *data_end = (void *)(long)skb->data_end;
		void *data     = (void *)(long)skb->data;

		//bpf_printk("start\n");
		struct ethhdr* ethh = data;
		if ((void *)(ethh + 1) <= data_end) {

			struct iphdr *iph;
			iph = (void *)(ethh + 1); 
			if ((void *)(iph + 1) <= data_end) {

				//modify the required fields and redirect to if egress
				__builtin_memcpy(ethh->h_source, lhinfo->smac, ETH_ALEN);
				__builtin_memcpy(ethh->h_dest, lhinfo->dmac, ETH_ALEN);
				iph->daddr = bpf_htonl(lhinfo->ipv4_daddr);
				//ip6h->saddr = lhinfo->ipv6_saddr;
				iph->check = bpf_htons(ipv4_check((void*)iph, iph->ihl * 4, data_end));
				bpf_clone_redirect(skb, lhinfo->targetifindex, 0);
			}
		}
	}
	return 0;
}

static __always_inline int ipv4_lh_handle(struct __sk_buff *skb) {
	void *data_end = (void *)(long)skb->data_end;
	void *data = (void *)(long)skb->data;

	//bpf_printk("eth check"); 
	struct ethhdr* ethh = data;
	if ((void *)(ethh + 1) > data_end) {
		//shouldn't happen, but it's not our deal so let it pass
		return 0;
	}

	//bpf_printk("ip check"); 
	struct iphdr *iph;
	iph = (void *)(ethh + 1); //(eth + 1);
	if ((void *)(iph + 1) > data_end) {
		//intruding packet/no ipv6, so don't process further here
		return 0;
	}

	//bpf_printk("ipv6 check\n");
	if (iph->version != 4) {
		bpf_printk("no ipv4\n");
		return 0;
	}

	//Might come in handy at some point, some split conditions instead of splitting every packet
	//removed for now for performance 
	//bpf_printk("split conditions check\n");
	/*
	int first = 0;
	lhinfo = bpf_map_lookup_elem(&xdp_lh_map, &first);

	int split = 1; 
	if (lhinfo->split_on_source_ip) {
		struct in6_addr ip_addr = ip6h->saddr;
		if (ip_addr.in6_u.u6_addr32[0] != lhinfo->ipv6_saddr.in6_u.u6_addr32[0]
		|| ip_addr.in6_u.u6_addr32[1] != lhinfo->ipv6_saddr.in6_u.u6_addr32[0]
		|| ip_addr.in6_u.u6_addr32[2] != lhinfo->ipv6_saddr.in6_u.u6_addr32[0] 
		|| ip_addr.in6_u.u6_addr32[3] != lhinfo->ipv6_saddr.in6_u.u6_addr32[0]) {
			split = 0;
		}
	}

		if (lhinfo->split_on_dest_ip) {
		struct in6_addr ip_addr = ip6h->daddr;
		if (ip_addr.in6_u.u6_addr32[0] != lhinfo->ipv6_daddr.in6_u.u6_addr32[0]
		|| ip_addr.in6_u.u6_addr32[1] != lhinfo->ipv6_daddr.in6_u.u6_addr32[0]
		|| ip_addr.in6_u.u6_addr32[2] != lhinfo->ipv6_daddr.in6_u.u6_addr32[0] 
		|| ip_addr.in6_u.u6_addr32[3] != lhinfo->ipv6_daddr.in6_u.u6_addr32[0]) {
			split = 0;
		}
	}

	if (split == 0) {
		return;
	}*/

	//This one doesn't support passing the original packet
	/*struct in6_addr dst_orig = ip6h->daddr;
	struct in6_addr src_orig = ip6h->saddr;
	unsigned char* h_dest_orig = ethh->h_dest;
	unsigned char* h_src_orig = ethh->h_source;*/

	//Loop over each alternate if to send the "localhost" packet to
	//bpf_loop(MAX_MAP_ENTRIES, clone_redir, skb, 0);
	//bpf_printk("cloning start"); 
	clone_redir(0, skb);
	clone_redir(1, skb);
	clone_redir(2, skb);
	clone_redir(3, skb);
	clone_redir(4, skb);
	clone_redir(5, skb);
	clone_redir(6, skb);
	clone_redir(7, skb);

	return 1;
}

SEC("tc")
int tc_generic2split(struct __sk_buff *skb) {
	//bpf_printk("split start\n");

	int success = ipv4_lh_handle(skb);
	if (success) {
		return TC_ACT_SHOT;
	} else {
		return TC_ACT_OK;
	}
}

char _license[] SEC("license") = "GPL";
