#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/in6.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <bpf/bpf_endian.h>
#include <stddef.h>
#include <linux/pkt_cls.h>
#include <linux/udp.h>

#define MAX_MAP_ENTRIES 2


struct lh_info {
	//__u32 ifindex;
    __u32 ipv4_saddr;
    //__u32 ipv4_daddr;
	//unsigned char smac[6];
	//unsigned char dmac[6];
};

struct {
	__uint(type, BPF_MAP_TYPE_LRU_HASH);
	__uint(max_entries, MAX_MAP_ENTRIES);
	__type(key, __u32);   // indexed by target address
	__type(value, struct lh_info); // dest IPvx info (6 for now)
} tc_redirect_map SEC(".maps");


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
			//bpf_printk("add %04x csum %08x", (*packet) * 256 + (*(packet+1)), csum);
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

	bpf_printk("csum %08x", csum);

    __u16 checksum = (__u16)~csum;
	return checksum;
}

static __always_inline int ipv4_redirect_handle(struct __sk_buff *skb, struct ethhdr *ethh) {
	void *data_end = (void *)(long)skb->data_end;

	struct iphdr *iph;
	iph = (void *)(ethh + 1); //(eth + 1);
	if ((void *)(iph + 1) > data_end) {
		//intruding packet/no ipv6, so don't process further here
		return 0;
	}

	bpf_printk("ipv4 check\n");
	if (iph->version != 4) {
		bpf_printk("no ipv4\n");
		return 0;
	}

	bpf_printk("localhost check\n");
	__u32 ip_dst_addr = iph->daddr;
	__u32 ip_src_addr = iph->saddr;

	//check if src an dst belong to the same subpod range
	ip_dst_addr &= 0xF8FFFFFF;
	ip_src_addr &= 0xF8FFFFFF;
	if (ip_dst_addr != ip_src_addr) {
		return 0;
	}

	//check if src isn't actually the pod if, which is the case if the bitmask didn't have any effect
	if (iph->saddr == ip_src_addr) {
		return 0;
	}

	struct lh_info* lhinfo;

	__u32 idx = 0;
	//Check if the original source is one that should be redirected
	lhinfo = bpf_map_lookup_elem(&tc_redirect_map, &idx);

	if (lhinfo == 0) {
		bpf_printk("no localhost route found"); 
		return 0;
	}

	bpf_printk("lh info"); 

	//modify the required fields 
	//__builtin_memcpy(ethh->h_source, lhinfo->smac, ETH_ALEN);
	//__builtin_memcpy(ethh->h_dest, lhinfo->dmac, ETH_ALEN);
	
	//iph->daddr = bpf_htonl(lhinfo->ipv4_daddr);
	iph->saddr = bpf_htonl(lhinfo->ipv4_saddr);
    iph->check = bpf_htons(ipv4_check((void*)iph, iph->ihl * 4, data_end));
    bpf_printk("ip check %x\n", iph->check);
	
	return 0; //lhinfo->ifindex;
}

SEC("tc")
int tc_lhredirect(struct __sk_buff *skb) {
	void *data_end = (void *)(long)skb->data_end;
	void *data     = (void *)(long)skb->data;

	bpf_printk("start\n");
	struct ethhdr* ethh = data;
	if ((void *)(ethh + 1) > data_end) {
		//shouldn't happen, but it's not our deal so let it pass
		return TC_ACT_OK;
	}

	ipv4_redirect_handle(skb, ethh);
	//if we got a return value, redirect it to that IF ingress. If not, it's not our type of traffic and should pass.
	/*if (interface) {
		bpf_redirect(interface, BPF_F_INGRESS);
		return TC_ACT_REDIRECT;
	} else {*/
		return TC_ACT_OK;
	//}
}



/*SEC("xdp_pass") 
int xdp_pass_func(struct xdp_md *ctx) {
	//bpf_printk("redirected");
	return XDP_PASS;
}*/

char _license[] SEC("license") = "GPL";