`include "uvm_macros.svh"
import uvm_pkg::*;

class first extends uvm_object;
	function new(string path = "first");
		super.new(path);
	endfunction

	rand bit[3:0]data;
	
	`uvm_object_utils_begin(first);
	`uvm_field_int(data, UVM_DEFAULT);
	`uvm_object_utils_end;
endclass

class second extends uvm_object;
	first f;

	function new(string path = "second");
		super.new(path);
		f = new("f");
	endfunction

	`uvm_object_utils_begin(second);
	`uvm_field_object(f, UVM_DEFAULT);
	`uvm_object_utils_end;
endclass

module tb;
 second ch1, ch2;

 initial begin
	 ch1 = new("ch1");
	 ch2 = new("ch2");
	 ch1.randomize();
	 ch2 = ch1;
	 ch1.print();
	 ch2.print();

	 ch2.f.data = 8;
	 ch1.print();
	 ch2.print();
 end
 endmodule
