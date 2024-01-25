`timescale 1ns / 1ps
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/22 10:23:13
// Design Name: 
// Module Name: hazard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hazard(
	//fetch stage
	output wire stallF,
	//decode stage
	input wire[4:0] rsD,rtD,
	input wire branchD,
	output reg[1:0] forwardaD,forwardbD,
	output wire stallD,
	input wire [3:0] memtoregD,
	//execute stage
	input wire[4:0] rsE,rtE,
	input wire[4:0] writeregE,
	input wire regwriteE,
	input wire [3:0] memtoregE,memwriteE,
	output reg[1:0] forwardaE,forwardbE,
	output wire flushE,stallE,
	input wire [31:0] aluoutE,
	//mem stage
	input wire[4:0] writeregM,
	input wire regwriteM,
	input wire [3:0] memtoregM,memwriteM,
	input wire [31:0] aluoutM,

	//write back stage
	input wire[4:0] writeregW,
	input wire regwriteW,
	input wire[4:0] alucontrolE,
	input wire div_ready,
	input wire [31:0] excepttypeM,
	output reg [31:0] newpcM,
	input wire [31:0] cp0_epcM,
	output wire flushF,flushD,flushM,flushW,
	input [4:1] rdE,rdM,
    input cp0readE, cp0writeM,
	output cp0forward,
	input wire i_stall,d_stall,
	output wire i_longest_stall, d_longest_stall,
	output wire stallM,stallW
    );

	wire lwstallD,branchstallD,stall_divE;
	
	assign cp0forward = (cp0readE && cp0writeM) && (rdE == rdM);

	//forwarding sources to D stage (branch equality)
	always@(*) begin
	   forwardaD = 2'b00;
	   forwardbD = 2'b00;
	   if(rsD != 0) begin
	       if(rsD == writeregE & regwriteE) forwardaD = 2'b01;
	       else if(rsD == writeregM & regwriteM) forwardaD = 2'b10;
	       else if(rsD == writeregW & regwriteW) forwardaD = 2'b11;
	   end
	   if(rtD != 0) begin
	       if(rtD == writeregE & regwriteE) forwardbD = 2'b01;
	       else if(rtD == writeregM & regwriteM) forwardbD = 2'b10;
	       else if(rtD == writeregW & regwriteW) forwardbD = 2'b11;
	   end
	end
	
	
	//forwarding sources to E stage (ALU)

	always @(*) begin
		forwardaE = 2'b00;
		forwardbE = 2'b00;
		if(rsE != 0) begin
			/* code */
			if(rsE == writeregM & regwriteM) begin
				/* code */
				forwardaE = 2'b10;
			end else if(rsE == writeregW & regwriteW) begin
				/* code */
				forwardaE = 2'b01;
			end
		end
		if(rtE != 0) begin
			/* code */
			if(rtE == writeregM & regwriteM) begin
				/* code */
				forwardbE = 2'b10;
			end else if(rtE == writeregW & regwriteW) begin
				/* code */
				forwardbE = 2'b01;
			end
		end
	end
    
    assign stall_divE = ((alucontrolE == `DIV_CONTROL)|(alucontrolE == `DIVU_CONTROL)) & ~div_ready;
	//stalls
	assign  lwstallD = (|memtoregE & |memtoregD) & (rtE == rsD) | (|memtoregE & ~|memtoregD) & (rtE == rsD | rtE == rtD);
	assign  branchstallD = branchD &
				(regwriteE & 
				(writeregE == rsD | writeregE == rtD) |
				(|memtoregM) &
				(writeregM == rsD | writeregM == rtD));
				
	assign i_longest_stall = i_stall | stall_divE;
	assign d_longest_stall = i_stall | d_stall | stall_divE;
	
		//stalling D stalls all previous stages

	assign stallD = lwstallD | stall_divE | i_stall === 1'b1 | d_stall;
	assign stallE = stall_divE | i_stall === 1'b1  | d_stall;
	assign stallF = stallD | stallE | i_stall === 1'b1 | d_stall;
	assign stallM = i_stall === 1'b1 | d_stall;
	assign stallW = i_stall === 1'b1 | d_stall;
	
	assign flushF = (excepttypeM!=0) & ~d_stall & ~i_stall;
	assign flushD = (excepttypeM!=0) & ~d_stall & ~i_stall;
    assign flushE = (lwstallD & ~d_stall & ~i_stall) | (excepttypeM!=0) & ~d_stall & ~i_stall;
	assign flushM = (excepttypeM!=0) & ~d_stall & ~i_stall;
	assign flushW = (excepttypeM!=0) & ~d_stall & ~i_stall;
	
	      always @(*) begin
        if(excepttypeM !=32'b0) begin
          case (excepttypeM)
             32'h00000001:begin
             newpcM <= 32'hBFC00380;
             end
             32'h00000004:begin
             newpcM <= 32'hBFC00380;
             end
             32'h00000005:begin
             newpcM <= 32'hBFC00380;
             end
             32'h00000008:begin
             newpcM <= 32'hBFC00380;
             end
             32'h00000009:begin
             newpcM <= 32'hBFC00380;
             end
             32'h0000000a:begin
             newpcM <= 32'hBFC00380;
             end 
             32'h0000000c:begin
             newpcM <= 32'hBFC00380;
             end
             32'h0000000e:begin
             newpcM <= cp0_epcM;
             end
             default:;
            endcase
          end
        end
endmodule
