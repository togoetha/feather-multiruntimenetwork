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

#define MAX_MAP_ENTRIES 16


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
	struct in6_addr ipv6_daddr;
	unsigned char smac[6];
	unsigned char dmac[6];
};

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, __u32);   // index
	__type(value, struct split_route); // dest IPvx info (6 for now)
} tc_split_map SEC(".maps");


static __always_inline int ipv6_lh_handle(struct __sk_buff *skb, struct ethhdr *ethh) {
	void *data_end = (void *)(long)skb->data_end;

	struct ipv6hdr *ip6h;
	ip6h = (void *)(ethh + 1); //(eth + 1);
	if ((void *)(ip6h + 1) > data_end) {
		//intruding packet/no ipv6, so don't process further here
		return 0;
	}

	//bpf_printk("ipv6 check\n");
	if (ip6h->version != 6) {
		bpf_printk("no ipv6\n");
		return 0;
	}


	struct split_route* lhinfo;
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
    //for (int i = 0; i < MAX_MAP_ENTRIES; i++) {
	int i;
	bpf_for(i, 0, MAX_MAP_ENTRIES) {
		lhinfo = bpf_map_lookup_elem(&tc_split_map, &i);
	
		//Could probably integrate this into the loop condition but i'm lazy and don't feel like tussling with the ebpf verifier to make that work
		if (lhinfo != 0 && lhinfo->active) {
			bpf_printk("lh info"); //, &(tninfo->ip), &(tninfo->port));

			//since bpf_clone_redirect messes things up hard (potentially), we have to do all these checks again or the verifier will nag at us
			void *data_end = (void *)(long)skb->data_end;
			void *data     = (void *)(long)skb->data;

			//bpf_printk("start\n");
			struct ethhdr* ethh = data;
			if ((void *)(ethh + 1) <= data_end) {

				struct ipv6hdr *ip6h;
				ip6h = (void *)(ethh + 1); 
				if ((void *)(ip6h + 1) <= data_end) {
	
					//modify the required fields and redirect to if egress
					__builtin_memcpy(ethh->h_source, lhinfo->smac, ETH_ALEN);
					__builtin_memcpy(ethh->h_dest, lhinfo->dmac, ETH_ALEN);
					ip6h->daddr = lhinfo->ipv6_daddr;
					//ip6h->saddr = lhinfo->ipv6_saddr;

					bpf_clone_redirect(skb, lhinfo->targetifindex, 0);
				}
			}
		}
	}
	return 1;
	
	//reassign original values and pass
	/*__builtin_memcpy(ethh->h_source, h_src_orig, ETH_ALEN);
	__builtin_memcpy(ethh->h_dest, h_dest_orig, ETH_ALEN);
	ip6h->daddr = dst_orig;
	ip6h->saddr = src_orig;*/
}

SEC("tc")
int tc_generic2split(struct __sk_buff *skb) {
	void *data_end = (void *)(long)skb->data_end;
	void *data     = (void *)(long)skb->data;

	//bpf_printk("start\n");
	struct ethhdr* ethh = data;
	if ((void *)(ethh + 1) > data_end) {
		//shouldn't happen, but it's not our deal so let it pass
		return TC_ACT_OK;
	}

	int success = ipv6_lh_handle(skb, ethh);
	if (success) {
		return TC_ACT_SHOT;
	} else {
		return TC_ACT_OK;
	}
}



/*SEC("xdp_pass") 
int xdp_pass_func(struct xdp_md *ctx) {
	//bpf_printk("redirected");
	return XDP_PASS;
}*/

char _license[] SEC("license") = "GPL";
