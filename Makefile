# SPDX-License-Identifier: (GPL-2.0+ OR MIT)
#
# Copyright (C) 2017 Chen-Yu Tsai <wens@csie.org>

DT_OVERLAYS :=

KERNEL_SRC ?= $(HOME)/linux
DTC ?= $(KERNEL_SRC)/scripts/dtc/dtc
DTC_INCLUDE = $(KERNEL_SRC)/include $(KERNEL_SRC)/scripts/dtc/include-prefixes 
DTC_CPP_FLAGS = -nostdinc -undef -D__DTS__ $(addprefix -I,$(DTC_INCLUDE))

.PHONY: clean FORCE

all: $(DT_OVERLAYS)

%.dtbo: %.dts FORCE
	@echo "  DTC $@"
	@# Test first
	@$(CPP) $(DTC_CPP_FLAGS) -D __DTO_TEST__ -x assembler-with-cpp $< | \
	    $(DTC) $(addprefix -i ,$(DTC_INCLUDE)) -b 0 -O dtb -o $@
	@$(CPP) $(DTC_CPP_FLAGS) -x assembler-with-cpp $< | \
	    $(DTC) $(addprefix -i ,$(DTC_INCLUDE)) -b 0 -O dtb -q -o $@

clean:
	rm -f *.dtbo

FORCE:
