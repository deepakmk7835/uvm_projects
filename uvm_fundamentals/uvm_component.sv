`include "uvm_macros.svh"
import uvm_pkg::*;

class comp extends uvm_component;
	`uvm_component_utils(comp);

	function new(string path = "comp", uvm_component parent = null);
		super.new(path,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.new(phase);
		`uvm_info("COMP","UVM_BUILD_PHASE executed",UVM_NONE);
	endfunction
endclass

module tb;

initial begin
	run_test("comp");
end

endmodule
