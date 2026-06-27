@echo off

set TEST=axil_ram_smoke_test
set SEED=0
set XSIM_SNAP=axil_ram_snap
set TIMESCALE=1ns/1ps
set UVM_HOME=C:\Xilinx\Vivado\2022.2\data\system_verilog\uvm_1.2

echo Running %TEST%

echo.
echo Step 1: Compiling UVM + TB...
xvlog -sv --include "%UVM_HOME%" --include "..\tb\vcore" "%UVM_HOME%\xlnx_uvm_package.sv" ..\tb\vcore\vcore_pkg.sv --log xvlog_all.log
echo xvlog errorlevel: %ERRORLEVEL%

echo.
echo Step 2: Elaborating...
xelab -L uvm --timescale %TIMESCALE% --snapshot %XSIM_SNAP% --log xelab.log axil_ram_tb
echo xelab errorlevel: %ERRORLEVEL%

echo.
echo Step 3: Simulating...
xsim %XSIM_SNAP% --runall ^
    --testplusarg UVM_TESTNAME=%TEST% ^
    --testplusarg UVM_VERBOSITY=UVM_MEDIUM ^
    --log xsim_%TEST%.log
echo xsim errorlevel: %ERRORLEVEL%

echo.
echo DONE