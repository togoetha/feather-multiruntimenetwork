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
Attach to lo egress.
Takes packets sent by a runtime workload (container, VM etc) to "localhost" and duplicates to redirect outside the workload
Depending on routing options outside the workload, may be used to redirect to those directly
=> max 1 for containers since all containers share an IP
=> one per (micro)VM
=> TBD WASI

*/
struct lh_route {
	unsigned int active;
	__be32 ipv4_daddr;
	__be32 ipv4_saddr;
	unsigned char smac[6];
	unsigned char dmac[6];
	unsigned int ifindex;
};

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, __u32);   // index
	__type(value, struct lh_route); // dest IPvx info (6 for now)
} xdp_lh_map SEC(".maps");

static __always_inline __u16 ipv4_check(__u8 *packet, __u8 len, void* data_end) {
    __u32 csum = 0;

	//reset checksum value
	*(packet + 10) = 0;
	*(packet + 11) = 0;

    for (int i = 0; i < 1536 && len > 1; i++) {
		if ((void*)(packet + 2) > data_end) {
			return 0;
		}
        csum += (*packet) * 256 + (*(packet+1));
		//bpf_printk("add %04x csum %08x", (*packet) * 256 + (*(packet+1)), csum);

        packet += 2;
        len -= 2;
    }
	if (len > 0) {
		csum += (*packet);
	}

    while (csum >> 16)
        csum = (csum & 0xFFFF) + (csum >> 16);

	//bpf_printk("csum %08x", csum);

    __u16 checksum = (__u16)~csum;
	return checksum;
}

void ipv4_lh_handle(struct __sk_buff *skb, struct ethhdr *ethh) {
	void *data_end = (void *)(long)skb->data_end;

	struct iphdr *ip4h;
	ip4h = (void *)(ethh + 1); //(eth + 1);
	if ((void *)(ip4h + 1) > data_end) {
		//intruding packet/no ipv4, so don't process further here
		return;
	}

	//bpf_printk("ipv6 check\n");
	if (ip4h->version != 4) {
		bpf_printk("no ipv4\n");
		return;
	}

	//bpf_printk("localhost check\n");
	__be32 ip_dst_addr = ip4h->daddr;
	if (ip_dst_addr != 0x7f000001) {
		//not meant for localhost to other containers/vms, so no routing
		return;
	}

	struct lh_route* lhinfo;
	__be32 dst_orig = ip_dst_addr;
	__be32 src_orig = ip4h->saddr;
	unsigned char* h_dest_orig = ethh->h_dest;
	unsigned char* h_src_orig = ethh->h_source;
	unsigned short check_orig = ip4h->check;

	//Loop over each alternate if to send the "localhost" packet to
    for (int i = 0; i < MAX_MAP_ENTRIES; i++) {
		lhinfo = bpf_map_lookup_elem(&xdp_lh_map, &ip_dst_addr);
	
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
					ip4h->daddr = lhinfo->ipv4_daddr;
					ip4h->saddr = lhinfo->ipv4_saddr;
					ip4h->check = ipv4_check((void*)ip4h, ip4h->ihl * 4, data_end);

					bpf_clone_redirect(skb, lhinfo->ifindex, 0);
				}
			}
		}
	}
	
	//reassign original values and pass
	__builtin_memcpy(ethh->h_source, h_src_orig, ETH_ALEN);
	__builtin_memcpy(ethh->h_dest, h_dest_orig, ETH_ALEN);
	ip4h->daddr = dst_orig;
	ip4h->saddr = src_orig;
	ip4h->check = check_orig;
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

	//check if it's ipv4 and localhost packet
	ipv4_lh_handle(skb, ethh);
	//the original packet must simply be passed
	return XDP_PASS;
}



/*SEC("xdp_pass") 
int xdp_pass_func(struct xdp_md *ctx) {
	//bpf_printk("redirected");
	return XDP_PASS;
}*/

//char _license[] SEC("license") = "GPL";
