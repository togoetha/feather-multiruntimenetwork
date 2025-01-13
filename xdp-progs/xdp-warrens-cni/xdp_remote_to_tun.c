/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/in6.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <linux/in.h>
#include <bpf/bpf_endian.h>
#include <stddef.h>
#include <linux/udp.h>

#define MAX_MAP_ENTRIES 256

struct eth_lnk {
	unsigned char smac[6];
	unsigned char dmac[6];
	unsigned int ifindex;
};

struct {
	__uint(type, BPF_MAP_TYPE_LRU_HASH);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, struct in6_addr);   // dest IPv6 cidr
	__type(value, struct eth_lnk); // dest IPvx info (6 for now)
} xdp_if_map SEC(".maps");

SEC("xdp")
int  xdp_prog_rtt(struct xdp_md *ctx)
{
	void *data_end = (void *)(long)ctx->data_end;
	void *data     = (void *)(long)ctx->data;

    struct ethhdr *eth = data;
	if ((void *)(eth + 1) > data_end) {
        //could be a malformed packet, but could also be raw ip traffic. let's not assume and just let it pass.
		return XDP_PASS;
	}

    //TODO DO IPV4/IPV6 check later
	if (eth->h_proto != bpf_htons(ETH_P_IPV6)) {
		return XDP_PASS;
	}

    struct ipv6hdr *ip6h;
	ip6h = (void *)(eth + 1);
	if ((void *)(ip6h + 1) > data_end) {
        //we want eth -> ip -> udp -> encapsulated packet, although later we should check if it's ipv4/6 instead of just 6
		return XDP_PASS;
	}

    if (ip6h->nexthdr != IPPROTO_UDP) {
        return XDP_PASS;
    }

    struct udphdr* udph = (void*)(ip6h + 1);
    if ((void *)(udph + 1) > data_end) {
        //actually in this case it IS malformed, since we just checked if it was udp. still..
        return XDP_PASS;
    }

    //there's no code like hardcode
    //the cni uses udp port 31337, so anything on that port is ours for the taking. screw other programs.
    if (udph->dest != bpf_htons(31337)) {
        return XDP_PASS;
    }

    //now we're sure to have udp ipv6 packet on port 31337, so unpack
    int ethlen = sizeof(struct ethhdr);
    int iplen = sizeof(struct ipv6hdr);
    int udplen = sizeof(struct udphdr);
    int newhlen = ethlen + iplen + udplen;

	__u8* pos = (void *)(data); //(eth + 1);
	if ((void *)(pos + newhlen) > data_end) {
        //in this case it is definitely malformed and we should toss it, but we already checked it beforehand
		return 0;
	}

    int ret = bpf_xdp_adjust_head(ctx, newhlen);
    if (ret != 0) {
        bpf_printk("failed to adjust incoming pkt for new header length\n"); 
    }

    //unpacked, but we still need to find the ipv6 address to adjust dst/src mac addresses to the right values on THIS machine
    //emitting from vethxxxx bridged to cni0, dest is eth1 in container
    data_end = (void *)(long)ctx->data_end;
	data     = (void *)(long)ctx->data;

	struct ethhdr* newethh = data;
	if ((void *)(newethh + 1) > data_end) {
		return XDP_ABORTED;
	}

	struct ipv6hdr* newipv6h = (void*)(newethh + 1);
	if ((void *)(newipv6h + 1) > data_end) {
		return XDP_ABORTED;
	}

    struct in6_addr ip_dst_addr = newipv6h->daddr;
	struct eth_lnk* ethinfo;

	//bpf_printk("looking up interface in map\n"); 
	ethinfo = bpf_map_lookup_elem(&xdp_if_map, &ip_dst_addr);
	if (ethinfo == 0) {
		bpf_printk("no interface found\n"); 
		return XDP_PASS;
	} else {
    	__builtin_memcpy(newethh->h_source, ethinfo->smac, ETH_ALEN);
		__builtin_memcpy(newethh->h_dest, ethinfo->dmac, ETH_ALEN);

		/*bpf_printk("smac %d\n", ethinfo->smac[0]);
		bpf_printk("smac %d\n", ethinfo->smac[1]);
		bpf_printk("smac %d\n", ethinfo->smac[2]);
		bpf_printk("smac %d\n", ethinfo->smac[3]);
		bpf_printk("smac %d\n", ethinfo->smac[4]);
		bpf_printk("smac %d\n", ethinfo->smac[5]);
		bpf_printk("dmac %d\n", ethinfo->dmac[0]);
		bpf_printk("dmac %d\n", ethinfo->dmac[1]);
		bpf_printk("dmac %d\n", ethinfo->dmac[2]);
		bpf_printk("dmac %d\n", ethinfo->dmac[3]);
		bpf_printk("dmac %d\n", ethinfo->dmac[4]);
		bpf_printk("dmac %d\n", ethinfo->dmac[5]);
		bpf_printk("ifindex %d\n", ethinfo->ifindex);*/

		int redir = bpf_redirect(ethinfo->ifindex, 0);//XDP_PASS;
		//bpf_printk("redir %d", redir);
		return redir;
	}
}

char _license[] SEC("license") = "GPL";