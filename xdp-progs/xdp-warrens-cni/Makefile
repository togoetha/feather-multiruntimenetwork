# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)

XDP_TARGETS := xdp_tun_to_remote xdp_remote_to_tun

LLC ?= llc
CLANG ?= clang
CC := gcc

LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/

include $(COMMON_DIR)/common.mk
COMMON_OBJS := $(COMMON_DIR)/common_params.o
