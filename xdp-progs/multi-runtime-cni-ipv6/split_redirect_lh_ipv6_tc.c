/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
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
struct lh_route {
	unsigned int active;
	struct in6_addr ipv6_saddr;
	struct in6_addr ipv6_daddr;
	unsigned char smac[6];
	unsigned char dmac[6];
	unsigned int targetifindex;
};

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, __u32);   // index
	__type(value, struct lh_route); // dest IPvx info (6 for now)
} xdp_lh_map SEC(".maps");


void ipv6_lh_handle(struct __sk_buff *skb, struct ethhdr *ethh) {
	void *data_end = (void *)(long)skb->data_end;

	struct ipv6hdr *ip6h;
	ip6h = (void *)(ethh + 1); //(eth + 1);
	if ((void *)(ip6h + 1) > data_end) {
		//intruding packet/no ipv6, so don't process further here
		return;
	}

	//bpf_printk("ipv6 check\n");
	if (ip6h->version != 6) {
		bpf_printk("no ipv6\n");
		return;
	}

	//bpf_printk("localhost check\n");
	struct in6_addr ip_dst_addr = ip6h->daddr;
	if (ip_dst_addr.in6_u.u6_addr32[0] != 0x00000000 
	|| ip_dst_addr.in6_u.u6_addr32[1] != 0x00000000 
	|| ip_dst_addr.in6_u.u6_addr32[2] != 0x00000000 
	|| ip_dst_addr.in6_u.u6_addr32[3] != 0x01000000) {
		//not meant for localhost to other containers/vms, so no routing
		return;
	}

	struct lh_route* lhinfo;
	struct in6_addr dst_orig = ip_dst_addr;
	struct in6_addr src_orig = ip6h->saddr;
	unsigned char* h_dest_orig = ethh->h_dest;
	unsigned char* h_src_orig = ethh->h_source;

	//Loop over each alternate if to send the "localhost" packet to
    for (int i = 0; i < MAX_MAP_ENTRIES; i++) {
		lhinfo = bpf_map_lookup_elem(&xdp_lh_map, &i);
	
		//Could probably integrate this into the loop condition but i'm lazy and don't feel like tussling with the ebpf verifier to make that work
		if (lhinfo->active != 0) {
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
					ip6h->saddr = lhinfo->ipv6_saddr;

					bpf_clone_redirect(skb, lhinfo->targetifindex, 0);
				}
			}
		}
	}
	
	data_end = (void *)(long)skb->data_end;
	void *data     = (void *)(long)skb->data;

	ethh = data;
	if ((void *)(ethh + 1) <= data_end) {

		struct ipv6hdr *ip6h;
		ip6h = (void *)(ethh + 1); 
		if ((void *)(ip6h + 1) <= data_end) {
			//reassign original values and pass
			__builtin_memcpy(ethh->h_source, h_src_orig, ETH_ALEN);
			__builtin_memcpy(ethh->h_dest, h_dest_orig, ETH_ALEN);
			ip6h->daddr = dst_orig;
			ip6h->saddr = src_orig;
		}
	}
}

//SEC("xdp_localhost")
//int xdp_prog_lh(struct xdp_md *ctx)
SEC("lh2split_tc")
int tc_lh2split(struct __sk_buff *skb) {
	void *data_end = (void *)(long)skb->data_end;
	void *data     = (void *)(long)skb->data;

	//bpf_printk("start\n");
	struct ethhdr* ethh = data;
	if ((void *)(ethh + 1) > data_end) {
		//shouldn't happen, but it's not our deal so let it pass
		return XDP_PASS;
	}

	ipv6_lh_handle(skb, ethh);
	
	//the original packet must simply be passed
	return XDP_PASS;
}



/*SEC("xdp_pass") 
int xdp_pass_func(struct xdp_md *ctx) {
	//bpf_printk("redirected");
	return XDP_PASS;
}*/

//char _license[] SEC("license") = "GPL";
