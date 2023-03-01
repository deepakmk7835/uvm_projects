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
 int comparisonStatus = 0;

 //Comparison status is 1 if (data items of 2 class instances is same)
 //Comparison status is 0 if (data items of 2 class instances is different)

 initial begin
	 /*
	 f1 = new("f1");
	 f2 = new("f2");
	 f1.randomize();
	 f2.randomize();
	 comparisonStatus = f1.compare(f2); //This results in False(0), as randomize method returns different values for data
	 */
	f1 = new("f1");
	f2 = new("f2");
	f1.randomize();
	f2.copy(f1);
	comparisonStatus = f1.compare(f2);
	`uvm_info("TOP_TB",$sformatf("Status = %0d",comparisonStatus),UVM_NONE);
 end
 endmodule

