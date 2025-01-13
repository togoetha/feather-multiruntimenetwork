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

struct {
    __uint(type, BPF_MAP_TYPE_PROG_ARRAY);
    __type(key, __u32); 
    __type(value, __u32); 
	__uint(max_entries, 2);
} jump_table SEC(".maps");

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(max_entries, 1);
	__type(key, __u32);   // index
	__type(value, __u32);  //IPv4 address
} ip_map SEC(".maps");

SEC("tc")
int lh_tails_ipv4(struct __sk_buff *skb) {
	void *data_end = (void *)(long)skb->data_end;
    void *data     = (void *)(long)skb->data;

    //bpf_printk("tail check start\n");
    struct ethhdr* ethh = data;
    if ((void *)(ethh + 1) <= data_end) {
        //bpf_printk("pass eth check\n");
        struct iphdr *iph;
        iph = (void *)(ethh + 1); 
        if ((void *)(iph + 1) <= data_end) {
            //bpf_printk("pass iph check\n");
            //bpf_printk("ip version %d\n", iph->version);
            if (iph->version == 4) {
                __u32 idx = 0;
                __u32 *ipnet = bpf_map_lookup_elem(&ip_map, &idx);
                //bpf_printk("ipv4 found, continuing subnet check\n");
                //This program is attached to redirect to either split_redirect_generic_ipv4
                //or translate_redirect_subpod_ipv4 depending on packet addresses
                //Checks before this point were to determine we're even dealing with ipv4
                if (ipnet != 0) {
                    __u32 snet = iph->saddr & 0xF8FFFFFF;
                    __u32 dnet = iph->daddr & 0xF8FFFFFF;
                    __u32 nsnet = bpf_htonl(*ipnet);
                    __u32 iploc = nsnet & 0x01FFFFFF;
                    /*bpf_printk("snet %d", snet);
                    bpf_printk("dnet %d", snet);
                    bpf_printk("iploc %d", snet);
                    bpf_printk("saddr %d", iph->saddr);
                    bpf_printk("daddr %d", iph->daddr);*/
                    //If the source ip net == dst ip net, then we don't want to handle it at this stage
                    //non-workload IP nets are N/A, because either dnet or snet *should* be one, so we don't even need to check those cases
                    //long result = 0;
                    if (snet != dnet && iph->saddr != iploc && iph->daddr != iploc) {
                        //bpf_printk("snet != dnet");
                        //If we're *sending* to the workload IP, then it needs to be split_redirect_generic_ipv4
                        if (dnet == nsnet) {
                            //bpf_printk("packet going to subnet");
                            bpf_tail_call(skb, &jump_table, 0);
                            //bpf_printk("tail call failed");
                        }
                        //If it's coming *from* the workload IP, we need translate_redirect_subpod_ipv4
                        if (snet == nsnet) {
                            //bpf_printk("packet coming from subnet");
                            bpf_tail_call(skb, &jump_table, 1);
                            //bpf_printk("tail call failed");
                        }
                    }
                    //bpf_printk("tail call result%d\n", result);
                }
            }
        }
    }
    
    return TC_ACT_OK;
}

char _license[] SEC("license") = "GPL";