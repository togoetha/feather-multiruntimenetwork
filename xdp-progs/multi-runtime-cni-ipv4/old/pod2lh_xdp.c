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

/*
Takes packets originating from workloads in the same pod and resubstitutes the IP for "localhost"

*/
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

  
}

char _license[] SEC("license") = "GPL";