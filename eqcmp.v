`timescale 1ns / 1ps
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/23 22:57:01
// Design Name: 
// Module Name: eqcmp
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


module eqcmp(
    input wire [5:0] op,
    input wire [4:0] rt,
	input wire [31:0] a,b,
	output reg y
    );

	always@(*) begin
	   case(op)
	       `BEQ: y = a == b ? 1'b1 : 1'b0;
	       `BNE: y = a != b ? 1'b1 : 1'b0;
	       `BGTZ: y = (a[31] == 0 && a != 0) ? 1'b1 : 1'b0;
	       `BLEZ: y = (a[31] != 0 || a == 0) ? 1'b1 : 1'b0;
	       6'b000001: begin case(rt)
	           `BGEZ: y = a[31] == 0 ? 1 : 0;
	           `BGEZAL: y = a[31] == 0 ? 1 : 0;
	           `BLTZ: y =  a[31] != 0 ? 1 : 0;
	           `BLTZAL: y = a[31] != 0 ? 1 : 0;
	       endcase end
	       default: y = 0;
	   endcase
	end
endmodule
