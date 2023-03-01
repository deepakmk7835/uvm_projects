`include "uvm_macros.svh"
import uvm_pkg::*;

class comp extends uvm_component;
	`uvm_component_utils(comp);

	int temp;

	function new(string path = "comp", uvm_component parent = null);
		super.new(path,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(int)::get(null,"comp2","temp",temp);
		`uvm_info("comp",$sformatf("Temp = %0d",temp),UVM_NONE);
	endfunction

endclass

class comp2 extends uvm_component;
	`uvm_component_utils(comp2);
	
	comp c;

	function new(string path = "comp2", uvm_component parent = null);
		super.new(path, parent);
		c = comp::type_id::create("c",this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(int)::set(null,"comp2","temp",10);
	endfunction

endclass

module tb;

initial begin
	run_test("comp2");
end
endmodule
