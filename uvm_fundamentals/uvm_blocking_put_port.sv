`include "uvm_macros.svh"
import uvm_pkg::*;

class monitor extends uvm_monitor;
	`uvm_component_utils(monitor);
  int data = 32;

	uvm_blocking_put_port #(int) monPort;

	function new(string path = "monitor", uvm_component parent = null);
		super.new(path,parent);
      monPort = new("monPort",this);
	endfunction
  
	virtual task main_phase(uvm_phase phase);
		phase.raise_objection(this);
      monPort.put(data);
      `uvm_info("monitor",$sformatf("Data Sent: %0d",data),UVM_NONE);
		phase.drop_objection(this);
	endtask

endclass

class scb extends uvm_scoreboard;
       `uvm_component_utils(scb);

	uvm_blocking_put_export #(int) scbExport;
	uvm_blocking_put_imp	#(int, scb) scbImp;
  
	function new(string path = "scb", uvm_component parent = null);
	 	super.new(path,parent);
      scbExport = new("scbExport",this);
      scbImp = new("scbImp",this);
	endfunction
	

	virtual task main_phase(uvm_phase phase);
		phase.raise_objection(this);
// 		`uvm_info("SCB",$sformatf("Data Received: %0d",scbImp),UVM_NONE);
      phase.drop_objection(this);
	endtask	
  
  task put(int datar);
    `uvm_info("SCB",$sformatf("Data Received: %0d",datar),UVM_NONE);
  endtask

endclass

class env extends uvm_env;
	`uvm_component_utils(env);

	function new(string path = "env", uvm_component parent = null);
	 	super.new(path,parent);
	endfunction

	monitor d;
	scb s;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		d = monitor::type_id::create("d",this);
		s = scb::type_id::create("s",this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		d.monPort.connect(s.scbExport);
		s.scbExport.connect(s.scbImp);
	endfunction

endclass

class test extends uvm_test;
	`uvm_component_utils(test);

	function new(string path = "test", uvm_component parent = null);
	 	super.new(path,parent);
	endfunction

	env e;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		e = env::type_id::create("e",this);
	endfunction
endclass
	

module tb;

initial begin
	run_test("env");
end
endmodule
