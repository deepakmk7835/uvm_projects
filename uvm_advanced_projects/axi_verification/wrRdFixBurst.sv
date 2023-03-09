`include "transaction.sv"

class wrRdFixTestCase extends uvm_sequence#(transaction);
	`uvm_object_utils(wrRdFixTestCase);

	transaction t;

	function new(string path = "wrRdFixTestCase");
		super.new(path);
	endfunction

	virtual task body();
		t = transaction::type_id::create("t");
		start_item(t);
		assert(t.randomize());
		t.test_case = wrRdFixBurst;
		finish.item(t);	
	endtask

endclass
