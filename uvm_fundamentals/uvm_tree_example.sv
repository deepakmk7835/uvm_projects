`include "uvm_macros.svh"
import uvm_pkg::*;

class a extends uvm_component; //Child class of c
	`uvm_component_utils(a);

	function new(string path = "a", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("a","BUILD_PHASE of A is executed",UVM_NONE);
	endfunction
endclass

class b extends uvm_component; //Child class of c
	`uvm_component_utils(b);

	function new(string path = "b", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("b","BUILD_PHASE of B is executed",UVM_NONE);
	endfunction
endclass

class c extends uvm_component; 
	`uvm_component_utils(c);

	a class_a;
	b class_b;

	function new(string path = "c", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("c","BUILD_PHASE of B is executed",UVM_NONE);
		class_a = a::type_id::create("class_a",this);
		class_b = b::type_id::create("class_b",this);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
endclass


module tb;

initial begin
	run_test("c");
end
endmodule
