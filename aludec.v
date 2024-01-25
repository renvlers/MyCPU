`timescale 1ns / 1ps
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:27:24
// Design Name: 
// Module Name: aludec
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


module aludec(
	input wire[5:0] funct,
	input wire[3:0] aluop,
	output reg[4:0] alucontrol
    );
	always @(*) begin
		case (aluop)
			`ANDI_OP:alucontrol <= `AND_CONTROL;
            `XORI_OP:alucontrol <= `XOR_CONTROL;
            `ORI_OP:alucontrol <= `OR_CONTROL;
            `LUI_OP:alucontrol <= `LUI_CONTROL;
            
            `ADDI_OP:alucontrol <= `ADD_CONTROL;
            `ADDIU_OP:alucontrol <= `ADDU_CONTROL;
            `SLTI_OP:alucontrol <= `SLT_CONTROL;
            `SLTIU_OP:alucontrol <= `SLTU_CONTROL;
			`R_TYPE_OP : case (funct)
				`AND:alucontrol <= `AND_CONTROL;
				`OR:alucontrol <= `OR_CONTROL;
				`XOR:alucontrol <= `XOR_CONTROL;
				`NOR:alucontrol <= `NOR_CONTROL;
				
				`SLL:alucontrol <= `SLL_CONTROL;
				`SRL:alucontrol <= `SRL_CONTROL;
				`SRA:alucontrol <= `SRA_CONTROL;
				`SLLV:alucontrol <= `SLLV_CONTROL;
				`SRLV:alucontrol <= `SRLV_CONTROL;
				`SRAV:alucontrol <= `SRAV_CONTROL;
				
				`MFHI:alucontrol <= `MFHI_CONTROL;
				`MTHI:alucontrol <= `MTHI_CONTROL;
				`MFLO:alucontrol <= `MFLO_CONTROL;
				`MTLO:alucontrol <= `MTLO_CONTROL;
				
				`ADD:alucontrol <= `ADD_CONTROL;
				`ADDU:alucontrol <= `ADDU_CONTROL;
				`SUB:alucontrol <= `SUB_CONTROL;
				`SUBU:alucontrol <= `SUBU_CONTROL;
				`SLT:alucontrol <= `SLT_CONTROL;
				`SLTU:alucontrol <= `SLTU_CONTROL;
				`MULT:alucontrol <= `MULT_CONTROL;
				`MULTU:alucontrol <= `MULTU_CONTROL;
				`DIV:alucontrol <= `DIV_CONTROL;
				`DIVU:alucontrol <= `DIVU_CONTROL;
				default:  alucontrol <= 5'b00000;
			endcase
			default:  alucontrol <= 5'b00000;
		endcase
	
	end
endmodule
