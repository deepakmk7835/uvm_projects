`include "uvm_macros.svh"
import uvm_pkg::*;

class monitor extends uvm_monitor #(transaction);
	`uvm_component_utils(monitor);

	transaction t;
	virtual axi_if vif();

	logic [31:0] arr[128];
	    
	  logic [1:0] rdresp;
	  logic [1:0] wrresp;
	  
	  logic       resp;
	  
	  int err = 0;
	  
	  logic [31:0]nextAddr;
		
	function new(string path = "monitor", uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	virtual void function build_phase(uvm_phase phase);
		super.build_phase(phase);
		t = transaction::type_id::create("t");
		uvm_config_db #(virtual axi_if)::get(this,"","axi_if",vif);
	endfunction

	task compare();
	    if(err == 0 && rdresp == 0 && wrresp == 0 )
	         begin
	           `uvm_info("MON", $sformatf("Test Passed err :%0d wrresp :%0d rdresp :%0d ", err, rdresp, wrresp), UVM_MEDIUM); 
	           err = 0;
	         end
	    else
	        begin
	          `uvm_info("MON", $sformatf("Test Failed err :%0d wrresp :%0d rdresp :%0d ", err, rdresp, wrresp), UVM_MEDIUM);
	          err = 0; 
	        end
	  endtask	

	function bit[31:0] nextAddressIncr(input bit[3:0]wstrb, input bit[31:0]awaddr);
		bit [31:0]addr;

		case(wstrb)
			4'b0001:begin
				arr[awaddr] = vif.wdata[7:0];
				addr = awaddr + 1;
			end

			4'b0010:begin
				arr[awaddr] = vif.wdata[15:8];
				addr = awaddr + 1;
			end

			4'b0100:begin
				arr[awaddr] = vif.wdata[23:16];
				addr = awaddr + 1;
			end

			4'b1000:begin
				arr[awaddr] = vif.wdata[31:24];
				addr = awaddr + 1;
			end

			4'b0011:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
				addr = awaddr + 2;
			end

			4'b0110:begin
				arr[awaddr] = vif.wdata[15:8];
				arr[awaddr+1] = vif.wdata[23:16];
				addr = awaddr + 2;
			end

			4'b1100:begin
				arr[awaddr] = vif.wdata[23:16];
				arr[awaddr+1] = vif.wdata[31:24];
				addr = awaddr + 2;
			end

			4'b1001:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[31:24];
				addr = awaddr + 2;
			end

			4'b1010:begin
				arr[awaddr] = vif.wdata[15:8];
				arr[awaddr+1] = vif.wdata[31:24];
				addr = awaddr + 2;
			end

			4'b0101:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[23:16];
				addr = awaddr + 2;
			end

			4'b0111:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
				arr[awaddr+2] = vif.wdata[23:16];
				addr = awaddr + 3;
			end

			4'b1110:begin
				arr[awaddr] = vif.wdata[15:8];
				arr[awaddr+1] = vif.wdata[23:16];
				arr[awaddr+2] = vif.wdata[31:24];
				addr = awaddr + 3;
			end

			4'b1101:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[23:16];
				arr[awaddr+2] = vif.wdata[31:24];
				addr = awaddr + 3;
			end

			4'b1011:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
				arr[awaddr+2] = vif.wdata[31:24];
				addr = awaddr + 3;
			end

			4'b1111:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
				arr[awaddr+2] = vif.wdata[23:16];
				arr[awaddr+3] = vif.wdata[31:24];
				addr = awaddr + 4;
			end
		endcase
		return addr;
	endtask	

	function bit[31:0] nextAddressWrap(input bit[3:0]wstrb, input bit [31:0]awaddr, input bit[31:0]wrapboundary);
		bit [31:0]addr1, addr2, addr3, addr4;
		case(wstrb)
			4'b0001:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					return (awaddr + 1 - wrapboundary);
				end else begin
					return awaddr + 1;
				end
			end

			4'b0010:begin
				arr[awaddr] = vif.wdata[15:8];
				if((awaddr + 1) % wrapboundary == 0)begin
					return (awaddr + 1 - wrapboundary);
				end else begin
					return awaddr + 1;
				end
			end

			4'b0100:begin
				arr[awaddr] = vif.wdata[23:16];
				if((awaddr + 1) % wrapboundary == 0)begin
					return (awaddr + 1 - wrapboundary);
				end else begin
					return awaddr + 1;
				end
				
			end

			4'b1000:begin
				arr[awaddr] = vif.wdata[31:24];
				
				if((awaddr + 1) % wrapboundary == 0)begin
					return (awaddr + 1 - wrapboundary);
				end else begin
					return awaddr + 1;
				end

			end

			4'b0011:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[15:8];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end
				return addr2;
			end

			4'b0110:begin
				arr[awaddr] = vif.wdata[15:8];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[23:16];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end
				return addr2;
			end

			4'b1100:begin
				arr[awaddr] = vif.wdata[23:16];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[31:24];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end
				return addr2;
			end

			4'b1001:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[31:24];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end
				return addr2;
			end

			4'b1010:begin
				arr[awaddr] = vif.wdata[15:8];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[31:24];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end
				return addr2;
			end

			4'b0101:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[23:16];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end
				return addr2;
			end

			4'b0111:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[15:8];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end

				arr[addr2] = vif.wdata[23:16];

				if((addr2 + 1) % wrapboundary == 0)begin
					addr3 = (addr2 + 1 - wrapboundary);
				end else begin
					addr3 = addr2 + 1;
				end
				return addr3;
			end

			4'b1110:begin
				arr[awaddr] = vif.wdata[15:8];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[23:16];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end

				arr[addr2] = vif.wdata[31:24];

				if((addr2 + 1) % wrapboundary == 0)begin
					addr3 = (addr2 + 1 - wrapboundary);
				end else begin
					addr3 = addr2 + 1;
				end
				return addr3;
			end

			4'b1101:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[23:16];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end

				arr[addr2] = vif.wdata[31:24];

				if((addr2 + 1) % wrapboundary == 0)begin
					addr3 = (addr2 + 1 - wrapboundary);
				end else begin
					addr3 = addr2 + 1;
				end
				return addr3;		
			end

			4'b1011:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[15:8];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end

				arr[addr2] = vif.wdata[31:24];

				if((addr2 + 1) % wrapboundary == 0)begin
					addr3 = (addr2 + 1 - wrapboundary);
				end else begin
					addr3 = addr2 + 1;
				end
				return addr3;
			end

			4'b1111:begin
				arr[awaddr] = vif.wdata[7:0];
				if((awaddr + 1) % wrapboundary == 0)begin
					addr1 = (awaddr + 1 - wrapboundary);
				end else begin
					addr1 = awaddr + 1;
				end

				arr[addr1] = vif.wdata[15:8];
				
				if((addr1 + 1) % wrapboundary == 0)begin
					addr2 = (addr1 + 1 - wrapboundary);
				end else begin
					addr2 = addr1 + 1;
				end

				arr[addr2] = vif.wdata[23:16];

				if((addr2 + 1) % wrapboundary == 0)begin
					addr3 = (addr2 + 1 - wrapboundary);
				end else begin
					addr3 = addr2 + 1;
				end
				
				arr[addr3] = vif.wdata[31:24];

				if((addr3 + 1) % wrapboundary == 0)begin
					addr4 = (addr3 + 1 - wrapboundary);
				end else begin
					addr4 = addr3 + 1;
				end
				return addr4;
			end
		endcase
	endfunction

	function bit [31:0] nextAddressFix(input bit[3:0] wstrb, input bit[31:0]waddr);
		case(wstrb)
			4'b0001:begin
				arr[awaddr] = vif.wdata[7:0];
			end

			4'b0010:begin
				arr[awaddr] = vif.wdata[15:8];
			end

			4'b0100:begin
				arr[awaddr] = vif.wdata[23:16];
			end

			4'b1000:begin
				arr[awaddr] = vif.wdata[31:24];
			end

			4'b0011:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
			end

			4'b0110:begin
				arr[awaddr] = vif.wdata[15:8];
				arr[awaddr+1] = vif.wdata[23:16];
			end

			4'b1100:begin
				arr[awaddr] = vif.wdata[23:16];
				arr[awaddr+1] = vif.wdata[31:24];
			end

			4'b1001:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[31:24];
			end

			4'b1010:begin
				arr[awaddr] = vif.wdata[15:8];
				arr[awaddr+1] = vif.wdata[31:24];
			end

			4'b0101:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[23:16];
			end

			4'b0111:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
				arr[awaddr+2] = vif.wdata[23:16];
			end

			4'b1110:begin
				arr[awaddr] = vif.wdata[15:8];
				arr[awaddr+1] = vif.wdata[23:16];
				arr[awaddr+2] = vif.wdata[31:24];
			end

			4'b1101:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[23:16];
				arr[awaddr+2] = vif.wdata[31:24];
			end

			4'b1011:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
				arr[awaddr+2] = vif.wdata[31:24];
			end

			4'b1111:begin
				arr[awaddr] = vif.wdata[7:0];
				arr[awaddr+1] = vif.wdata[15:8];
				arr[awaddr+2] = vif.wdata[23:16];
				arr[awaddr+3] = vif.wdata[31:24];
			end
		endcase
		return awaddr;
	endfunction

	virtual task run_phase(uvm_phase phase);
	    forever begin
	    
	      @(posedge vif.clk);
	      if(!vif.resetn)
	        begin 
	          `uvm_info("MON", "System Reset Detected", UVM_MEDIUM); 
	        end
	      
	      else if(vif.resetn && vif.awaddr < 128 && vif.awburst == 2'b01)
	        begin
	       
	          wait(vif.awvalid == 1'b1);
		  nextAddr = nextAddressIncr(vif.wstrb,vif.awaddr);
		  for(int i=0;i<vif.awlen;i++)begin
			  @(posedge vif.wready);
			  nextAddr = nextAddressIncr(vif.wstrb, nextAddr);
		  end
		 //Write logic for calculating next address based on current
		 //address and store the incoming data in that address in the
		 //local array
		 @(posedge vif.bvalid);
		 wrresp = bresp; 
	      end
	     
	     else if(vif.resetn && vif.awaddr < 128 && vif.awburst == 2'b10)
	     begin
		 //Task to calculate next address with wrap burst
		 wait(vif.awvalid == 1'b1);
		 wrapBoundaryValue = wrapBoundary(vif.awlen, vif.awsize);
		 nextAddr = nextAddressWrap(vif.wstrb, vif.awaddr, wrapBoundaryValue);
	         for(int i=0;i<vif.awlen;i++)begin
			@(posedge vif.wready);
		  	nextAddr = nextAddressWrap(vif.wstrb, nextAddr, wrapBoundaryValue);
		 end
 		 
		@(posedge vif.bvalid);
		wrresp = vif.bresp;		
	     end

	    else if(vif.resetn && vif.awaddr < 128 && vif.awburst == 2'b00)
	    begin
		     //Task to calculate next address with Fixed burst
		 wait(vif.awvalid == 1'b1);
		 nextAddr = nextAddressFix(vif.wstrb, vif.awaddr);
	         for(int i=0;i<vif.awlen;i++)begin
			@(posedge vif.wready);
		  	nextAddr = nextAddressFix(vif.wstrb, nextAddr);
		 end
 		 
		@(posedge vif.bvalid);
		wrresp = vif.bresp;
	    end 
	          	      
	 end      
	endtask	
endclass
