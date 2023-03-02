`include "uvm_macros.svh"
import uvm_pkg::*;

class drv extends uvm_driver;
	`uvm_component_utils(drv);

	function new(string path = "drv", uvm_component parent = null);
		super.new(path,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("DRV","Build Phase Executed",UVM_NONE);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("DRV","Connet Phase Executed",UVM_NONE);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("DRV","End Of Elaboration Phase Executed",UVM_NONE);
	endfunction

	virtual function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		`uvm_info("DRV","Start Of Simulation Phase Executed",UVM_NONE);
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info("DRV","Run Phase Executed",UVM_NONE);
	endtask

	virtual function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		`uvm_info("DRV","Extract Phase Executed",UVM_NONE);
	endfunction
	
	virtual function void check_phase(uvm_phase phase);
		super.check_phase(phase);
		`uvm_info("DRV","Check Phase Executed",UVM_NONE);
	endfunction
	
	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("DRV","Report Phase Executed",UVM_NONE);
	endfunction

	virtual function void final_phase(uvm_phase phase);
		super.final_phase(phase);
		`uvm_info("DRV","Final Phase Executed",UVM_NONE);
	endfunction
endclass

module tb;

initial begin
	run_test("drv");
end
endmodule
