`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/29 19:30:51
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(
    input wire clk,rst,E_hilo,we1,we2,
	input wire [31:0] hi,lo,
	output reg[31:0] hi_o,lo_o
    );
    
    always@(negedge clk)begin
        if(rst) begin
            hi_o<=0;
            lo_o<=0;
         end else if(we1&~we2)begin
            hi_o<=hi;
         end else if(~we1&we2)begin
            lo_o<=lo;
         end else if(E_hilo)begin
            lo_o<=lo;
            hi_o<=hi;
         end
    end
endmodule
