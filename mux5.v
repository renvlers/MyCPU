`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/29 21:09:42
// Design Name: 
// Module Name: mux5
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


module mux5 (
    input wire w1,
    input wire[31:0] d3,
	input wire[31:0] d0,
	input wire[31:0] d1,
	input wire s,
	output wire[31:0] y
    );
	wire [31:0] wei;
	
	assign wei =(s==1'b1)?d0:d1;
	assign y =(w1==1'b1)?d3:wei;
endmodule
