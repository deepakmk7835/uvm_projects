`include "transaction.sv"

class wrRdWrapTestCase extends uvm_sequence#(transaction);
	`uvm_object_utils(wrRdWrapTestCase);

	transaction t;

	function new(string path = "wrRdWrapTestCase");
		super.new(path);
	endfunction

	virtual task body();
		t = transaction::type_id::create("t");
		start_item(t);
		assert(t.randomize());
		t.test_case = wrRdWrapBurst;
		finish.item(t);	
	endtask

endclass
