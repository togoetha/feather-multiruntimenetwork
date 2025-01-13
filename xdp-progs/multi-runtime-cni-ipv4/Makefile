# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)

XDP_TARGETS := bpf_tail_call_ipv4 split_redirect_generic_ipv4_tc translate_redirect_subpod_ipv4_tc split_redirect_lh_ipv4_tc translate_redirect_lh_ipv4_tc translate_redirect_lh_ipv4_xdp

LLC ?= llc
CLANG ?= clang
CC := gcc

#LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/

include $(COMMON_DIR)/common.mk
COMMON_OBJS := $(COMMON_DIR)/common_params.o
