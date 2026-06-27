.PHONY: sim waves clean

TOOL      ?= xsim
TEST      ?= axil_ram_smoke_test
SEED      ?= 0
WAVES     ?= 0
TIMESCALE  = 1ns/1ps

XSIM_SNAP = axil_ram_snap

sim:
	@echo Running $(TEST) tool=$(TOOL)
	xvlog -sv -f axil_ram.f -L uvm --log xvlog_$(TEST).log
	xelab -L uvm --timescale $(TIMESCALE) --snapshot $(XSIM_SNAP) --log xelab_$(TEST).log axil_ram_tb
	xsim $(XSIM_SNAP) --runall --testplusarg UVM_TESTNAME=$(TEST) --testplusarg UVM_VERBOSITY=UVM_MEDIUM --log xsim_$(TEST)_$(SEED).log

waves: WAVES=1
waves: sim

clean:
	-del /f /q *.log *.vcd *.fsdb *.vvp *.wdb *.pb *.jou *.str 2>nul
	-rmdir /s /q xsim.dir xcelium.d csrc 2>nul
	-del /f /q simv ucli.key 2>nul