`include "transaction.sv"

class wrRdIncrTestCase extends uvm_sequence#(transaction);
	`uvm_object_utils(wrRdIncrTestCase);

	transaction t;

	function new(string path = "wrRdIncrTestCase");
		super.new(path);
	endfunction

	virtual task body();
		t = transaction::type_id::create("t");
		start_item(t);
		assert(t.randomize());
		t.test_case = wrRdIncrBurst;
		finish.item(t);	
	endtask

endclass
