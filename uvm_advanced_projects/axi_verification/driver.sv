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
		`uvm_info("DRV","Reset Detected...",UVM_NONE);
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
		`uvm_info("DRV","Fix Burst Write Transaction Started...",UVM_NONE);
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

	task fixBurstRd();
		`uvm_info("DRV","Fix Burst Read Transaction Started...",UVM_NONE);
		//WAC
		vif.awaddr <= 0; //32-vif.address
		vif.awvalid<= 0; //Indicates valid address on WAC
		vif.awlen<=   0; //awlen+1 = transactions
		vif.awburst<= 0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.awsize<=  0; // Max number of bytes allowed per transaction for 4 bytes awsize = 2 i.e bytes = 2 ^ awsize
		vif.awid <= 0;

		//Write Data Channel (WDC)
		
		vif.wdata<= 0; //32-vif.data 
		vif.wstrb<= 0; //Indicates which data lane has valid data
		vif.wvalid<= 0; //Indicates valid data on WDC
		vif.wid <= 0;
		vif.wlast <= 0;
		
		//RAC

		vif.araddr <= 5; //32-vif.address
		vif.arvalid<= 1; //Indicates valid address on WAC
		vif.arlen<=   7; //arlen+1 = transactions
		vif.arburst<= 0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.arsize<=  2; // Max number of bytes allowed per transaction for 4 bytes arsize = 2 i.e bytes = 2 ^ arsize
		vif.arid <= t.arid;
		
		vif.rready <= 1; //Ready to receive data from slave
	
		for(int i=0;i<(vif.arlen+1);i++)begin //Receive 8 TXN each 4 bytes wide
			@(posedge vif.arready); //Indicates completion of single read TXN
			@(posedge vif.clk);
		end

		@(negedge vif.rlast); //Indicates last read transaction
		vif.rready <= 0;	
		vif.arvalid <= 0;	
		
	endtask

	//Increment Write TXN
	
	task incrBurstWr();
		`uvm_info("DRV","Increment Burst Write Transaction Started...",UVM_NONE);
		//WAC
		vif.awaddr <= 5; //32-vif.address
		vif.awvalid<= 1; //Indicates valid address on WAC
		vif.awlen<=   7; //awlen+1 = transactions
		vif.awburst<= 1; //Type of burst = 0 fixed, 1 incr, 2 wrap
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

	task incrBurstRd();
		`uvm_info("DRV","Increment Burst Read Transaction Started...",UVM_NONE);
		//WAC
		vif.awaddr <= 0; //32-vif.address
		vif.awvalid<= 0; //Indicates valid address on WAC
		vif.awlen<=   0; //awlen+1 = transactions
		vif.awburst<= 0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.awsize<=  0; // Max number of bytes allowed per transaction for 4 bytes awsize = 2 i.e bytes = 2 ^ awsize
		vif.awid <= 0;

		//Write Data Channel (WDC)
		
		vif.wdata<= 0; //32-vif.data 
		vif.wstrb<= 0; //Indicates which data lane has valid data
		vif.wvalid<= 0; //Indicates valid data on WDC
		vif.wid <= 0;
		vif.wlast <= 0;
		
		//RAC

		vif.araddr <= 5; //32-vif.address
		vif.arvalid<= 1; //Indicates valid address on WAC
		vif.arlen<=   7; //arlen+1 = transactions
		vif.arburst<= 1; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.arsize<=  2; // Max number of bytes allowed per transaction for 4 bytes arsize = 2 i.e bytes = 2 ^ arsize
		vif.arid <= t.arid;
		
		vif.rready <= 1; //Ready to receive data from slave
	
		for(int i=0;i<(vif.arlen+1);i++)begin //Receive 8 TXN each 4 bytes wide
			@(posedge vif.arready); //Indicates completion of single read TXN
			@(posedge vif.clk);
		end

		@(negedge vif.rlast); //Indicates last read transaction
		vif.rready <= 0;	
		vif.arvalid <= 0;	
		
	endtask

	//Wrap Write Read TXN
	
	task wrapBurstWr();
		`uvm_info("DRV","Wrap Burst Write Transaction Started...",UVM_NONE);
		//WAC
		vif.awaddr <= 5; //32-vif.address
		vif.awvalid<= 1; //Indicates valid address on WAC
		vif.awlen<=   7; //awlen+1 = transactions
		vif.awburst<= 2; //Type of burst = 0 fixed, 1 incr, 2 wrap
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

	task wrapBurstRd();
		`uvm_info("DRV","Wrap Burst Read Transaction Started...",UVM_NONE);
		//WAC
		vif.awaddr <= 0; //32-vif.address
		vif.awvalid<= 0; //Indicates valid address on WAC
		vif.awlen<=   0; //awlen+1 = transactions
		vif.awburst<= 0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.awsize<=  0; // Max number of bytes allowed per transaction for 4 bytes awsize = 2 i.e bytes = 2 ^ awsize
		vif.awid <= 0;

		//Write Data Channel (WDC)
		
		vif.wdata<= 0; //32-vif.data 
		vif.wstrb<= 0; //Indicates which data lane has valid data
		vif.wvalid<= 0; //Indicates valid data on WDC
		vif.wid <= 0;
		vif.wlast <= 0;
		
		//RAC

		vif.araddr <= 5; //32-vif.address
		vif.arvalid<= 1; //Indicates valid address on WAC
		vif.arlen<=   7; //arlen+1 = transactions
		vif.arburst<= 2; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.arsize<=  2; // Max number of bytes allowed per transaction for 4 bytes arsize = 2 i.e bytes = 2 ^ arsize
		vif.arid <= t.arid;
		
		vif.rready <= 1; //Ready to receive data from slave
	
		for(int i=0;i<(vif.arlen+1);i++)begin //Receive 8 TXN each 4 bytes wide
			@(posedge vif.arready); //Indicates completion of single read TXN
			@(posedge vif.clk);
		end

		@(negedge vif.rlast); //Indicates last read transaction
		vif.rready <= 0;	
		vif.arvalid <= 0;	
		
	endtask

	//Error Write
	
	task ErrWr(); 
		`uvm_info("DRV","Error Write Transaction Started...",UVM_NONE);
		//WAC
		vif.awaddr <= 128; //32-vif.address Since address is 128, this is out of range according to the design
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

	task ErrRd();
		`uvm_info("DRV","Error Read Transaction Started...",UVM_NONE);
		//WAC
		vif.awaddr <= 0; //32-vif.address
		vif.awvalid<= 0; //Indicates valid address on WAC
		vif.awlen<=   0; //awlen+1 = transactions
		vif.awburst<= 0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.awsize<=  0; // Max number of bytes allowed per transaction for 4 bytes awsize = 2 i.e bytes = 2 ^ awsize
		vif.awid <= 0;

		//Write Data Channel (WDC)
		
		vif.wdata<= 0; //32-vif.data 
		vif.wstrb<= 0; //Indicates which data lane has valid data
		vif.wvalid<= 0; //Indicates valid data on WDC
		vif.wid <= 0;
		vif.wlast <= 0;
		
		//RAC

		vif.araddr <= 128; //32-vif.address
		vif.arvalid<= 1; //Indicates valid address on WAC
		vif.arlen<=   7; //arlen+1 = transactions
		vif.arburst<= 0; //Type of burst = 0 fixed, 1 incr, 2 wrap
		vif.arsize<=  2; // Max number of bytes allowed per transaction for 4 bytes arsize = 2 i.e bytes = 2 ^ arsize
		vif.arid <= t.arid;
		
		vif.rready <= 1; //Ready to receive data from slave
	
		for(int i=0;i<(vif.arlen+1);i++)begin //Receive 8 TXN each 4 bytes wide
			@(posedge vif.arready); //Indicates completion of single read TXN
			@(posedge vif.clk);
		end

		@(negedge vif.rlast); //Indicates last read transaction
		vif.rready <= 0;	
		vif.arvalid <= 0;	
		
	endtask
	
	//Task for Fixed Write Read Burst
	
        task wrRdFixBurst();
		vif.rstn <= 1'b1;
		fixBurstWr();	
		`uvm_info("DRV","Fix Burst Write Transaction Completed...",UVM_NONE);
		fixBurstRd();
		`uvm_info("DRV","Fix Burst Read Transaction Completed...",UVM_NONE);
	endtask	
	
	//Task for Incremental Write Read Burst
	
	task wrRdIncrBurst();
		vif.rstn <= 1'b1;
		incrBurstWr();	
		`uvm_info("DRV","Increment Burst Write Transaction Completed...",UVM_NONE);
		incrBurstRd();
		`uvm_info("DRV","Increment Burst Read Transaction Completed...",UVM_NONE);
	endtask

	//Task for Wrap Write Read Burst
	
	task wrRdWrapBurst();
		vif.rstn <= 1'b1;
		wrapBurstWr();	
		`uvm_info("DRV","Wrap Burst Write Transaction Completed...",UVM_NONE);
		wrapBurstRd();
		`uvm_info("DRV","Wrap Burst Read Transaction Completed...",UVM_NONE);
	endtask


	//Task for Error Test Case
	
	task wrRdErr();
		vif.rstn <= 1'b1;
		ErrWr();	
		`uvm_info("DRV","Error Write Transaction Completed...",UVM_NONE);
		ErrRd();
		`uvm_info("DRV","Error Read Transaction Completed...",UVM_NONE);
	endtask

	virtual task run_phase();
		seq_item_port.get_next_item(t);
		if(t.test_case == rstdut)begin
			rst_dut();
			`uvm_info("DRV","Reset Detected...",UVM_NONE);
		end else if(t.test_case == wrRdFixBurst)begin
			wrRdFixBurst();
		end else if(t.test_case == wrRdIncrBurst)begin
			wrRdIncrBurst();
		end else if(t.test_case == wrRdWrapBurst)begin
			wrRdWrapBurst();
		end else if(t.test_case == wrRdErr)begin
			wrRdErr();
		end	
		seq_item_port.item_done();
	endtask

endclass

		
