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
Attach to workload namespace eth0 ingress, redirect to workload namespace lo ingress.
Target use: Takes "localhost" packets returned from outside the workload and translates them back to localhost addresses. 

*/
struct lh_route {
	unsigned int ifindex;
};

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, struct in6_addr);   // indexed by original source address
	__type(value, struct lh_route); // dest IPvx info (6 for now)
} xdp_lh_map SEC(".maps");


int ipv6_lh_handle(struct __sk_buff *skb, struct ethhdr *ethh) {
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

	//bpf_printk("localhost check\n");
	struct in6_addr ip_src_addr = ip6h->saddr;
	struct lh_route* lhinfo;

	//Check if the original source is one that should translate to localhost
	lhinfo = bpf_map_lookup_elem(&xdp_lh_map, &ip_src_addr);

	if (lhinfo == 0) {
		return 0;
	}

	bpf_printk("lh info"); 
	struct in6_addr lh_addr;
	lh_addr.in6_u.u6_addr32[0] = 0x00000000;
	lh_addr.in6_u.u6_addr32[1] = 0x00000000;
	lh_addr.in6_u.u6_addr32[2] = 0x00000000;
	lh_addr.in6_u.u6_addr32[3] = 0x01000000;

	unsigned char lh_mac[6] = {0, 0, 0, 0, 0, 0};

	//modify the required fields 
	__builtin_memcpy(ethh->h_source, lh_mac, ETH_ALEN);
	__builtin_memcpy(ethh->h_dest, lh_mac, ETH_ALEN);
	ip6h->daddr = lh_addr;
	ip6h->saddr = lh_addr;
	
	return 1;
}

//SEC("xdp_localhost")
//int xdp_prog_lh(struct xdp_md *ctx)
SEC("split2lh_xdp")
int xdp_split2lh(struct __sk_buff *skb) {
	void *data_end = (void *)(long)skb->data_end;
	void *data     = (void *)(long)skb->data;

	//bpf_printk("start\n");
	struct ethhdr* ethh = data;
	if ((void *)(ethh + 1) > data_end) {
		//shouldn't happen, but it's not our deal so let it pass
		return XDP_PASS;
	}

	int handled = ipv6_lh_handle(skb, ethh);
	//if we redirected it, the original packet MUST be dropped. If not, it's not our type of traffic and should pass.
	if (handled) {
		return XDP_DROP;
	} else {
	return XDP_PASS;
	}
}



/*SEC("xdp_pass") 
int xdp_pass_func(struct xdp_md *ctx) {
	//bpf_printk("redirected");
	return XDP_PASS;
}*/

//char _license[] SEC("license") = "GPL";
