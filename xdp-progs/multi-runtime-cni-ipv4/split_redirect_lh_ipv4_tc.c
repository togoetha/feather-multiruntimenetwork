/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/in6.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <linux/pkt_cls.h>
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
struct lh_route {
	__u32 active;
	__u32 targetifindex;
	__u32 ipv4_saddr;
	__u32 ipv4_daddr;
	unsigned char smac[6];
	unsigned char dmac[6];
};

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, __u32);   // index
	__type(value, struct lh_route); 
} tc_lh_map SEC(".maps");

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, __u32);   // index
	__type(value, __u32);
} tc_lhaddr_map SEC(".maps");


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

static __always_inline int clone_redir_forward(__u32 i, struct __sk_buff *skb) {
	//bpf_printk("clone_redir %d\n", i); 
	struct lh_route* lhinfo;
	lhinfo = bpf_map_lookup_elem(&tc_lh_map, &i);
	
	if (lhinfo == 0) {
		//bpf_printk("no lh info for %d\n", i); 
		return 0;
	}

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
				iph->saddr = bpf_htonl(lhinfo->ipv4_saddr);
				iph->check = bpf_htons(ipv4_check((void*)iph, iph->ihl * 4, data_end));

				bpf_clone_redirect(skb, lhinfo->targetifindex, 0);
			}
		}
	}
	return 0;
}

static __always_inline int clone_redir_backward(__u32 i, struct __sk_buff *skb) {
	//bpf_printk("clone_redir %d\n", i); 
	struct lh_route* lhinfo;
	lhinfo = bpf_map_lookup_elem(&tc_lh_map, &i);
	
	__u32 idx = 0;
	__u32 *lhaddr = bpf_map_lookup_elem(&tc_lhaddr_map, &idx);

	if (lhinfo != 0 && lhaddr != 0 && lhinfo->active) {
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
				iph->saddr = bpf_htonl(*lhaddr);
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

	struct iphdr *ip4h;
	ip4h = (void *)(ethh + 1); //(eth + 1);
	if ((void *)(ip4h + 1) > data_end) {
		//intruding packet/no ipv4, so don't process further here
		return 0;
	}

	//bpf_printk("ipv6 check\n");
	if (ip4h->version != 4) {
		//bpf_printk("no ipv4\n");
		return 0;
	}

	//bpf_printk("localhost check\n");
	__u32 ip_dst_addr = ip4h->daddr;
	//__u32 idx = 0;
	__u32 lhaddr = ip4h->saddr & 0x01FFFFFF; //bpf_map_lookup_elem(&tc_lhaddr_map, &idx);
	__u32 snet = ip4h->saddr & 0xF8FFFFFF;
	//__u32 dnet = ip4h->daddr & 0xF8FFFFFF;

	/*if (snet != dnet) {
		return 0;
	}*/

	//bpf_printk("ipdst %d", ip_dst_addr);
	//bpf_printk("lhaddr %d", lhaddr);
	//bpf_printk("podaddr %d", podaddr);
	/*struct lh_route *defroute = bpf_map_lookup_elem(&tc_lh_map, &idx);
	if (defroute != 0) {
		lhaddr = defroute->ipv4_saddr & 0xFFFFFF01;
	}*/
	//Both the fetched address and the pod address are valid localhost addresses
	if (ip_dst_addr == lhaddr) { //lhaddr != 0 && bpf_ntohl(ip_dst_addr) == lhaddr) {
		clone_redir_forward(0, skb);
		clone_redir_forward(1, skb);
		clone_redir_forward(2, skb);
		clone_redir_forward(3, skb);
		//clone_redir_forward(4, skb);
		//clone_redir_forward(5, skb);
		//clone_redir_forward(6, skb);
		//clone_redir_forward(7, skb);
		return 1;
	} else { //if (defroute != 0) {
		//__u32 podaddr = bpf_htonl(defroute->ipv4_saddr);
		if (snet == ip_dst_addr) {
			clone_redir_backward(0, skb);
			clone_redir_backward(1, skb);
			clone_redir_backward(2, skb);
			clone_redir_backward(3, skb);
			//clone_redir_backward(4, skb);
			//clone_redir_backward(5, skb);
			//clone_redir_backward(6, skb);
			//clone_redir_backward(7, skb);
			return 1;
		}
	}

	return 0;
}

SEC("tc")
int tc_lh2split(struct __sk_buff *skb) {
	//bpf_printk("split start\n");

	int handled = ipv4_lh_handle(skb);
	if (handled) {
		return TC_ACT_SHOT;
	} else {
		return TC_ACT_OK;
	}
}

char _license[] SEC("license") = "GPL";
