`timescale 1ns / 1ps
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/31 23:01:20
// Design Name: 
// Module Name: devdem
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


module devdem(
    input [4:0] alucontrol,
	input wire div_ready,
	flushM,
	output reg div_start, div_signed, div_annul
    );

	always @(*) begin
		case (alucontrol)
			`DIV_CONTROL: 
			begin
				if (div_ready)
					{div_start,div_signed,div_annul} = 3'b010;
				else
					{div_start,div_signed,div_annul} = 3'b110;
			end
			`DIVU_CONTROL: 
			begin
				if (div_ready)
					{div_start,div_signed,div_annul} = 3'b000;
				else
					{div_start,div_signed,div_annul} = 3'b100;
			end
			default: {div_start,div_signed,div_annul} = 3'b000;
		endcase
		if(flushM)		div_annul <= 1;
	end
endmodule
