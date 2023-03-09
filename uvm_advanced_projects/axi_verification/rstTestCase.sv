`include "transaction.sv"

class rstTestCase extends uvm_sequence#(transaction);
	`uvm_object_utils(rstTestCase);

	transaction t;

	function new(string path = "rstTestCase");
		super.new(path);
	endfunction

	virtual task body();
		t = transaction::type_id::create("t");
		start_item(t);
		assert(t.randomize());
		t.test_case = rstdut;
		finish.item(t);	
	endtask

endclass
