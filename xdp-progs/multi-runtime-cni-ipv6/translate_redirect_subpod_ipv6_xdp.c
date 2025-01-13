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

#define MAX_MAP_ENTRIES 64


/*
REVISE DESCRIPTION
Attach to workload namespace eth0 ingress, redirect to workload namespace lo ingress.
Target use: Takes "localhost" packets returned from outside the workload and translates them back to localhost addresses. 

To make things a little more flexible, we don't actually hardcode the localhost address, it's passed in the map.
Same for MAC addresses; loopback is all 0's, but we keep it a little flexible for potential reuse.

*/
	//saddr and daddr aren't required for subpod redirect because a) all traffic from subpods is in a specific subpod range, 
	//and should be redirected by default if target isn't the same subpod range. which can be checked with a bitmask.
	//smac is always the same but we still need that info (the main interface for that subpod range), but dmac can differ depending on if it's a remote address (another pod or not), or another local pod
	//same for target interface
	//struct in6_addr ipv6_saddr;
	//struct in6_addr ipv6_daddr;
struct redirect_route {
	__u32 ifindex;
	unsigned char smac[6];
	unsigned char dmac[6];
};

struct {
	__uint(type, BPF_MAP_TYPE_LRU_HASH);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, struct in6_addr);   // indexed by target address
	__type(value, struct redirect_route); // dest IPvx info (6 for now)
} xdp_redirect_map SEC(".maps");


static __always_inline int ipv6_redirect_handle(struct xdp_md *ctx, struct ethhdr *ethh) {
	void *data_end = (void *)(long)ctx->data_end;

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
	struct in6_addr ip_dst_addr = ip6h->daddr;
	struct in6_addr ip_src_addr = ip6h->saddr;

	//check if src an dst belong to the same subpod range, if they do we need to ignore this packet because it should be processed by pod local traffic programs
	//subpod range is /4 so mask FFF0, F0FF in big endian
	ip_dst_addr.in6_u.u6_addr16[7] &= 0xF0FF;
	ip_src_addr.in6_u.u6_addr16[7] &= 0xF0FF;
	if (ip_dst_addr.in6_u.u6_addr32[0] == ip_src_addr.in6_u.u6_addr32[0] &&
		ip_dst_addr.in6_u.u6_addr32[1] == ip_src_addr.in6_u.u6_addr32[1] &&
		ip_dst_addr.in6_u.u6_addr32[2] == ip_src_addr.in6_u.u6_addr32[2] &&
		ip_dst_addr.in6_u.u6_addr32[3] == ip_src_addr.in6_u.u6_addr32[3] ) {
		return 0;
	}

	struct redirect_route* lhinfo;

	//Check if the original source is one that should be redirected
	lhinfo = bpf_map_lookup_elem(&xdp_redirect_map, &ip_dst_addr);

	//don't return 0 here, this just means it's not a pod on the same device. Get default reroute.
	if (lhinfo == 0) {
		struct in6_addr deft = { { .u6_addr32 = { 0x0, 0x0, 0x0, 0x0 } } };
		lhinfo = bpf_map_lookup_elem(&xdp_redirect_map, &deft);
	}

	if (lhinfo == 0) {
		//ok now something IS wrong, so let it go
		return 0;
	}

	bpf_printk("lh info"); 

	//modify the required fields 
	__builtin_memcpy(ethh->h_source, lhinfo->smac, ETH_ALEN);
	__builtin_memcpy(ethh->h_dest, lhinfo->dmac, ETH_ALEN);
	//this program implicitly translates subpod range addresses into the pod IP address, which is just another mask:
	ip6h->saddr.in6_u.u6_addr16[7] &= 0xF1FF;
	//ip6h->daddr = lhinfo->ipv6_daddr;
	//ip6h->saddr = lhinfo->ipv6_saddr;
	
	return lhinfo->ifindex;
}

//SEC("xdp_localhost")
//int xdp_prog_lh(struct xdp_md *ctx)
SEC("xdp")
int xdp_subpodredirect(struct xdp_md *ctx) {
	void *data_end = (void *)(long)ctx->data_end;
	void *data     = (void *)(long)ctx->data;

	//bpf_printk("start\n");
	struct ethhdr* ethh = data;
	if ((void *)(ethh + 1) > data_end) {
		//shouldn't happen, but it's not our deal so let it pass
		return XDP_PASS;
	}

	int interface = ipv6_redirect_handle(ctx, ethh);
	//if we got a return value, redirect it to that IF ingress. If not, it's not our type of traffic and should pass.
	if (interface) {
		bpf_redirect(interface, BPF_F_INGRESS);
		return XDP_REDIRECT;
	} else {
		return XDP_PASS;
	}
}



/*SEC("xdp_pass") 
int xdp_pass_func(struct xdp_md *ctx) {
	//bpf_printk("redirected");
	return XDP_PASS;
}*/

char _license[] SEC("license") = "GPL";
