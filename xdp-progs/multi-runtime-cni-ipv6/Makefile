# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)

XDP_TARGETS := split_redirect_generic_ipv6_tc split_redirect_lh_ipv6_tc split_redirect_lh_ipv4_tc

LLC ?= llc
CLANG ?= clang
CC := gcc

LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/

include $(COMMON_DIR)/common.mk
COMMON_OBJS := $(COMMON_DIR)/common_params.o
