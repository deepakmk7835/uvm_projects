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

module tb;

 first f1;
 first f2;

 /* COPY

 initial begin
	 f1 = new("f1");
	 //Copy Method
	 //To copy an object of a class to another class handle, you need to
	 //initialize the handle
	 f2 = new("f2");
	 f1.randomize();
	 f2.copy(f1);
	 f1.print(uvm_default_table_printer);
	 f2.print(uvm_default_table_printer);
 end

 */

initial begin
	//In clone method, no need to initialize the second class handle, just
	//need to cast the clone of first class handle, as this handle clone
	//is output from parent class(uvm_object)
	f1 = new("f1");
	f1.randomize();
	$cast(f2,f1.clone());
	f1.print();
	f2.print();
 endmodule
