# Makefile for Cocotb simulation (TinyTapeout CFAR)

SIM           ?= icarus
TOPLEVEL_LANG ?= verilog

# Source directory
SRC_DIR = $(PWD)/../src

# RTL sources
PROJECT_SOURCES = project.v cfar.v

ifneq ($(GATES),yes)

# ── RTL Simulation ────────────────────────────────────────────────
SIM_BUILD = sim_build/rtl

VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

# MUST match your project.v module name
TOPLEVEL = tt_um_ilamparuthi_cfar

else

# ── Gate-Level Simulation ─────────────────────────────────────────
SIM_BUILD = sim_build/gl

COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1

VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Gate-level netlist
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

TOPLEVEL = tt_um_ilamparuthi_cfar

endif

# Include path
COMPILE_ARGS += -I$(SRC_DIR)

# Optional (helps avoid weird timing issues)
COMPILE_ARGS += -g2012

# Cocotb test file (test.py)
MODULE = test

# Dump waves automatically
WAVES = 1

include $(shell cocotb-config --makefiles)/Makefile.sim
