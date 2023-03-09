`include "transaction.sv"

class wrRdErrTestCase extends uvm_sequence#(transaction);
	`uvm_object_utils(wrRdErrTestCase);

	transaction t;

	function new(string path = "wrRdErrTestCase");
		super.new(path);
	endfunction

	virtual task body();
		t = transaction::type_id::create("t");
		start_item(t);
		assert(t.randomize());
		t.test_case = wrRdErr;
		finish.item(t);	
	endtask

endclass
