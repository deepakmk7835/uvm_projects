`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit [2:0] {rstdut = 0, wrRdFixBurst = 1, wrRdIncrBurst = 2, wrRdWrapBurst = 3, wrRdErr = 4} testCase;

class transaction extends uvm_sequence_item;
	`uvm_object_uitls(transaction);

	function new(string path = "transaction");
		super.new(path);
	endfunction

	bit rstn;

	//Type of testcase
	testCase test_case;

	//Write Address Channel (WAC)

	rand bit [31:0]awaddr; //32-bit address
	rand bit awvalid; //Indicates valid address on WAC
	bit awready;	//Indicates destination is ready to accept data
	rand bit [3:0]awlen; //awlen+1 = transactions
	rand bit [1:0]awburst; //Type of burst = 0 fixed, 1 incr, 2 wrap
	rand bit [2:0]awsize; // Max number of bytes allowed per transaction for 4 bytes awsize = 2 i.e bytes = 2 ^ awsize
	bit [3:0]awid; //Unique IDs for each transaction

	//Write Data Channel (WDC)
	
	rand bit [31:0]wdata; //32-bit data 
	rand bit [3:0]wstrb; //Indicates which data lane has valid data
	bit wvalid; //Indicates valid data on WDC
	bit wready;	//Indicates destination is ready to accept data
	bit [3:0]wid; //Unique IDs for each transaction
	bit wlast; //Indicates last transaction 

	//Write Response Channel (WRC)
	
	bit [1:0]bresp;
	bit [3:0]bid;
	bit bready;
	bit bvalid;

	//Read Address Channel (RAC)
	
	rand bit arvalid;
	bit arready;
	rand bit [31:0]araddr;
	rand bit [3:0]arlen;
	rand bit [1:0]arburst;
	rand bit [2:0]arsize;
	bit [3:0]arid;

	//Read Data Channel (RDC)
	
	bit rvalid;
	bit rready;
	bit [3:0]rid;
	bit rlast;
	bit [31:0]rdata;
	bit [3:0]rstrbe;
	bit [1:0]rresp;

	constraint validC {arvalid != awvalid}
	constraint idC {wid=id; rid=id; bid=id; awid = id; arid=id;}
	constraint burstC {awburst inside {0,1,2}; arburst inside {0,1,2};}
        constraint lenC {awlen == arlen;}	
endclass
