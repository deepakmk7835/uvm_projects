`include "transaction.sv"
`include "rstTestCase.sv"
`include "wrRdFixBurst.sv"
`include "wrRdIncrTestCase.sv"
`include "wrRdWrapTestCase.sv"
`include "wrRdErrTestCase.sv"

class driver extends uvm_driver#(transaction);
	`uvm_component_utils(driver);
	
	transaction t;
	virtual axi_if vif();

	//Local Variables
	
	bit fixWrSlvErr;

	function new(string path = "driver", uvm_component parent = null);
		super.new(path,parent);
	endfunction

	virtual void function build_phase(uvm_phase phase);
		super.build_phase(phase);
		t = transaction::type_id::create("t");
		uvm_config_db #(virtual axi_if)::get(this,"","axi_if",vif);
	endfunction

	//Task for RST DUT
	
	task rst_dut();
		vif.rstn <= 0;
		
		//WAC
		vif.awaddr <= 'h0; //32-vif.address
		vif.awvalid<= 'h0; //Indicates valid address on WAC
		vif.awready<= 'h0;	//Indicates destination is ready to accept data
		vif.awlen<= 'h0; //awlen+1 = transactions
		vif.awburst<= 'h0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.awsize<= 'h0; // Max number of bytes allowed per transaction for 4 bytes awsize = 2 i.e bytes = 2 ^ awsize
		vif.awid<= 'h0; //Unique IDs for each transaction
	
		//Write Data Channel (WDC)
		
		vif.wdata<= 'h0; //32-vif.data 
		vif.wstrb<= 'h0; //Indicates which data lane has valid data
		vif.wvalid<= 'h0; //Indicates valid data on WDC
		vif.wready<= 'h0;	//Indicates destination is ready to accept data
		vif.wid<= 'h0; //Unique IDs for each transaction
		vif.wlast<= 'h0; //Indicates last transaction 
	
		//Write Response Channel (WRC)
		
		vif.bresp<= 'h0;
		vif.bid<= 'h0;
		vif.bready<= 'h0;
		vif.bvalid<= 'h0;

		//Read Address Channel (RAC)
	
		vif.arvalid <= 'h0;
		vif.arready <= 'h0;
		vif.araddr <= 'h0;
		vif.arlen <= 'h0;
		vif.arburst <= 'h0;
		vif.arsize <= 'h0;
		vif.arid <= 'h0;
	
		//Read Data Channel (RDC)
		
		vif.rvalid <= 'h0;
		vif.rready <= 'h0;
		vif.rid    <= 'h0;
		vif.rlast  <= 'h0;
		vif.rdata  <= 'h0;
		vif.rstrbe <= 'h0;
		vif.rresp  <= 'h0;

		@(posedge vif.clk);
	endtask

	//Task for Fixed Write Burst
	
	task fixBurstWr();
		//WAC
		vif.awaddr <= 5; //32-vif.address
		vif.awvalid<= 1; //Indicates valid address on WAC
		vif.awlen<=   7; //awlen+1 = transactions
		vif.awburst<= 0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.awsize<=  2; // Max number of bytes allowed per transaction for 4 bytes awsize = 2 i.e bytes = 2 ^ awsize
		vif.awid <= t.awid;

		//Write Data Channel (WDC)
		
		vif.wdata<= t.wdata; //32-vif.data 
		vif.wstrb<= t.wstrb; //Indicates which data lane has valid data
		vif.wvalid<= 1; //Indicates valid data on WDC
		vif.wid <= t.wid;
		vif.wlast <= 0;

		vif.arvalid <= 0;
		vif.rready <= 0;
		
		@(posedge vif.wready); //Indicates completion of write transaction
	
		for(int i = 0 ;i<vif.awlen; i++)begin
			@(posedge vif.clk); //Drive new data active edge of the clock
			vif.wdata <= $urandom_range(0,10);
			@(posedge vif.wready); //Indicates completion of write transaction
		end

		vif.awvalid <= 0;
		vif.wvalid <= 0;
		vif.wlast <= 1;

		//Write Response Channel (WRC)
		
		vif.bready<= 1;
		
		@(negedge bvalid);
		vif.bready <= 0;
	endtask
	
	//Task for Fixed Write Read Burst
	
        task wrRdFixBurst();
		vif.rstn <= 1'b1;
		fixBurstWr();	
		fixBurstRd();
	endtask	
	
	//Task for Incremental Write Read Burst
	
	//Task for Wrap Write Read Burst
	
	//Task for Error Test Case

	virtual task run_phase();

	endtask

endclass

		
