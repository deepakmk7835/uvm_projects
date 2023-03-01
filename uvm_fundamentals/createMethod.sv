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
 first f1,f2;
 
 initial begin
	 f1 = first::type_id::create("f1");//Advantages of using create method is the changes made to the class will appear across different modules where this class is instantiated
	 f2 = first::type_id::create("f2");

	 f1.randomize();
	 f2.randomize();

	 f1.print();
	 f2.print();
 end
 endmodule
