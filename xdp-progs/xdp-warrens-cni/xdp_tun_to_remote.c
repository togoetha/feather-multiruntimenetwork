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

struct in6_ipport {
	struct in6_addr n_daddr;
	struct in6_addr n_saddr;
	__u32 port;
	unsigned char smac[6];
	unsigned char dmac[6];
	unsigned int ifindex;
};

struct {
	__uint(type, BPF_MAP_TYPE_LRU_HASH);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, struct in6_addr);   // dest IPv6 cidr
	__type(value, struct in6_ipport); // dest IPvx info (6 for now)
} xdp_tunnel_map SEC(".maps");


static __always_inline __u16 udp_csum(__u8 *packet, __u32 len, struct in6_addr* src, struct in6_addr* dest, void* data_end) {
    __u32 csum = 0;

    int i = 0;
    for (i = 0; i < 8; i++) {
        csum += bpf_htons(src->in6_u.u6_addr16[i]); 
		//bpf_printk("add %04x csum %08x", bpf_htons(src->in6_u.u6_addr16[i]), csum);
        csum += bpf_htons(dest->in6_u.u6_addr16[i]);
		//bpf_printk("add %04x csum %08x", bpf_htons(dest->in6_u.u6_addr16[i]), csum);
    }
	//bpf_printk("len %d", len);
    csum += len;
	//bpf_printk("add %04x csum %08x", len, csum);
    csum += 0x11;
	//bpf_printk("add %04x csum %08x", 0x11, csum);

    for (int i = 0; i < 1536 && len > 1; i++) {
		if ((void*)(packet + 2) > data_end) {
			return 0;
		}
        csum += (*packet) * 256 + (*(packet+1));
		//bpf_printk("add %04x csum %08x", (*packet) * 256 + (*(packet+1)), csum);

        packet += 2;
        len -= 2;
    }

    while (csum >> 16)
        csum = (csum & 0xFFFF) + (csum >> 16);

	//bpf_printk("csum %08x", csum);

    return (__u16)(0xFFFF - csum);
}

SEC("xdp_redirect")
int xdp_prog_ttr(struct xdp_md *ctx)
{
	void *data_end = (void *)(long)ctx->data_end;
	void *data     = (void *)(long)ctx->data;

	//bpf_printk("start\n");
	struct ethhdr* ethh = data;
	if ((void *)(ethh + 1) > data_end) {
		return XDP_ABORTED;
	}

	struct ipv6hdr *ip6h;
	ip6h = (void *)(ethh + 1); //(eth + 1);
	if ((void *)(ip6h + 1) > data_end) {
		//this entire thing is our interface, so screw this intruding packet
		return XDP_ABORTED;
	}

	//bpf_printk("ipv6 check\n");
	if (ip6h->version != 6) {
		bpf_printk("no ipv6\n");
		return XDP_ABORTED;
	}

	//bpf_printk("tunnel check\n");
	struct in6_addr ip_dst_addr = ip6h->daddr;
	ip_dst_addr.in6_u.u6_addr16[7] = 0x100;

	bpf_printk("IP addr 0 %d\n", ip_dst_addr.in6_u.u6_addr8[0]);
	bpf_printk("IP addr 1 %d\n", ip_dst_addr.in6_u.u6_addr8[1]);
	bpf_printk("IP addr 2 %d\n", ip_dst_addr.in6_u.u6_addr8[2]);
	bpf_printk("IP addr 3 %d\n", ip_dst_addr.in6_u.u6_addr8[3]);
	bpf_printk("IP addr 4 %d\n", ip_dst_addr.in6_u.u6_addr8[4]);
	bpf_printk("IP addr 5 %d\n", ip_dst_addr.in6_u.u6_addr8[5]);
	bpf_printk("IP addr 6 %d\n", ip_dst_addr.in6_u.u6_addr8[6]);
	bpf_printk("IP addr 7 %d\n", ip_dst_addr.in6_u.u6_addr8[7]);
	bpf_printk("IP addr 8 %d\n", ip_dst_addr.in6_u.u6_addr8[8]);
	bpf_printk("IP addr 9 %d\n", ip_dst_addr.in6_u.u6_addr8[9]);
	bpf_printk("IP addr 10 %d\n", ip_dst_addr.in6_u.u6_addr8[10]);
	bpf_printk("IP addr 11 %d\n", ip_dst_addr.in6_u.u6_addr8[11]);
	bpf_printk("IP addr 12 %d\n", ip_dst_addr.in6_u.u6_addr8[12]);
	bpf_printk("IP addr 13 %d\n", ip_dst_addr.in6_u.u6_addr8[13]);
	bpf_printk("IP addr 14 %d\n", ip_dst_addr.in6_u.u6_addr8[14]);
	bpf_printk("IP addr 15 %d\n", ip_dst_addr.in6_u.u6_addr8[15]);

	struct in6_ipport* tninfo;

	tninfo = bpf_map_lookup_elem(&xdp_tunnel_map, &ip_dst_addr);
	
	if (tninfo == 0) {
		//TODO, might be able to use XDP_PASS here and plug this straight into the CNI interface rather than TUN and avoid some routing
		
		bpf_printk("no tunnel info found for addr"); 
		return XDP_ABORTED;
	} else {
		bpf_printk("tunnel info"); //, &(tninfo->ip), &(tninfo->port));

		int ethlen = sizeof(struct ethhdr);
		int iplen = sizeof(struct ipv6hdr);
		int udplen = sizeof(struct udphdr);
		int newhlen = ethlen + iplen + udplen;
		
		int oldlen = bpf_ntohs(ip6h->payload_len) + iplen + ethlen;

		//bpf_printk("packet start %p end %p\n", data, data_end); //, &ip_src_addr);

		int ret = bpf_xdp_adjust_head(ctx, -newhlen);
		if (ret != 0) {
			bpf_printk("failed to adjust for new header length\n"); 
		}

		data_end = (void *)(long)ctx->data_end;
		data     = (void *)(long)ctx->data;
		//bpf_printk("packet start %p end %p\n", data, data_end);

		//bpf_printk("new eth hdr\n");
		struct ethhdr* newethh = data;
		if ((void *)(newethh + 1) > data_end) {
			return XDP_ABORTED;
		}

		newethh->h_proto = bpf_htons(ETH_P_IPV6);
		__builtin_memcpy(newethh->h_source, tninfo->smac, ETH_ALEN);
		__builtin_memcpy(newethh->h_dest, tninfo->dmac, ETH_ALEN);
		//newethh->h_source = tninfo->smac;

		//bpf_printk("new ip hdr\n");
		struct ipv6hdr* newipv6h = (void*)(newethh + 1);
		if ((void *)(newipv6h + 1) > data_end) {
			return XDP_ABORTED;
		}

		newipv6h->daddr = tninfo->n_daddr; 
		newipv6h->saddr = tninfo->n_saddr; 
		newipv6h->version = 0x6;
		newipv6h->hop_limit = 64;
		newipv6h->nexthdr = IPPROTO_UDP;
		newipv6h->payload_len = bpf_htons(oldlen + udplen);

		//bpf_printk("udp hdr\n");
		struct udphdr* udph = (void*)(newipv6h + 1);
		if ((void *)(udph + 1) > data_end) {
			return XDP_ABORTED;
		}

		short paylen = oldlen + udplen;
		//__u32 paylen = ((__u8*)data_end) - ((__u8*)((void*)udph)) + udplen;
		__u8* pstart = (void*)(udph);
		if ((void *)(pstart + paylen) > data_end) {
			return XDP_ABORTED;
		}

		//bpf_printk("populating udp hdr\n");
		//int* start = data;
		udph->source = bpf_htons(31337);
		udph->dest = bpf_htons(tninfo->port);
		udph->len = bpf_htons((short)paylen);
		//bpf_printk("csum\n");
		udph->check = bpf_htons(udp_csum((void*)udph, paylen, &tninfo->n_saddr, &tninfo->n_daddr, data_end));
		//bpf_printk("csum done\n");
	}

	int redir = bpf_redirect(tninfo->ifindex, 0);//XDP_PASS;
	bpf_printk("redir %d", redir);
	return redir;
}

SEC("xdp_pass") 
int xdp_pass_func(struct xdp_md *ctx) {
	//bpf_printk("redirected");
	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
