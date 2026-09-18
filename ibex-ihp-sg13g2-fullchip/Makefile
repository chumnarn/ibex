ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
export PATH := $(HOME)/.local/bin:$(PATH)
PDK_ROOT ?= $(HOME)/.ciel
PDK ?= ihp-sg13g2
RUN_TAG ?= ibex_$(shell date +%Y%m%d_%H%M%S)
FUSESOC_VERSION := 2.4.7
FUSESOC_VENV := $(ROOT)/.tools/fusesoc-$(FUSESOC_VERSION)
FUSESOC := $(FUSESOC_VENV)/bin/fusesoc
FUSESOC_FLAGS := --config $(ROOT)/fusesoc.conf --cores-root $(ROOT)/third_party/ibex --cores-root $(ROOT)
.DEFAULT_GOAL := help
help:
	@echo "make setup | doctor | lint | harden | harden-nodrc | openroad | klayout | archive"
$(FUSESOC):
	python3 -m venv $(FUSESOC_VENV)
	$(FUSESOC_VENV)/bin/python -m pip install --upgrade pip
	$(FUSESOC_VENV)/bin/python -m pip install "fusesoc==$(FUSESOC_VERSION)" pyyaml packaging

setup: $(FUSESOC)
	@$(FUSESOC_VENV)/bin/python -c 'import packaging' 2>/dev/null || \
		$(FUSESOC_VENV)/bin/python -m pip install packaging
	FUSESOC=$(FUSESOC) $(FUSESOC_VENV)/bin/python scripts/prepare_rtl.py

fusesoc-refresh: $(FUSESOC)
	$(FUSESOC_VENV)/bin/python -m pip install --upgrade "fusesoc==$(FUSESOC_VERSION)" pyyaml packaging
doctor:
	python3 scripts/doctor.py
lint: setup
	PATH="$(FUSESOC_VENV)/bin:$${PATH}" $(FUSESOC) $(FUSESOC_FLAGS) run --target=lint local:ibex:ihp_fullchip:1.0
harden: setup doctor
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --run-tag $(RUN_TAG) --flow Chip librelane/config.yaml
harden-nodrc: setup doctor
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --run-tag $(RUN_TAG) --flow Chip librelane/config.yaml --skip KLayout.DRC --skip Magic.DRC
openroad:
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --last-run --flow OpenInOpenROAD librelane/config.yaml
klayout:
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --last-run --flow OpenInKLayout librelane/config.yaml
archive:
	tar --exclude='./third_party' --exclude='./build' --exclude='./.tools' --exclude='./librelane/runs' -czf ../ibex-ihp-sg13g2-fullchip.tar.gz .
.PHONY: help setup fusesoc-refresh doctor lint harden harden-nodrc openroad klayout archive
