`timescale 1ns / 1ps
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: maindec
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


module maindec(
	input wire[5:0] op,
	input wire[5:0] op2,
	input wire[4:0] rt,
	input wire[4:0] rs,
	output wire [3:0] memtoreg,
	output wire [3:0] memwrite,
	output wire branch,alusrc,
	output wire regdst,regwrite,
	output wire jump,
	output wire hi,
	output wire lo,
	output wire[3:0] aluop,
	output wire islink,jr,jalr,lu,isvalid,cp0write,cp0read
    );
	reg[25:0] controls;
	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,hi,lo,aluop,islink,jr,jalr,lu,isvalid,cp0write,cp0read} = controls;
	always @(*) begin
		case (op)
			6'b000000:begin
			             case(op2)
			`MFHI:controls <= 26'b11000000000001110000000000;//R-TYRE
			`MTHI:controls <= 26'b01000000000001010000000000;//R-TYRE
			`MFLO:controls <= 26'b11000000000001110000000000;//R-TYRE
			`MTLO:controls <= 26'b01000000000000110000000000;//R-TYRE
			
			`MULT:controls <=  26'b01000000000001110000000000;//R-TYRE
			`MULTU:controls <= 26'b01000000000001110000000000;//R-TYRE
			`DIV:controls <=   26'b01000000000001110000000000;//R-TYRE
			`DIVU:controls <=  26'b01000000000001110000000000;//R-TYRE
			
			`JR: controls <= 26'b00000000000010000000100000;
			`JALR: controls <= 26'b11000000000010000001110000;

			`AND:controls<=26'b11000000000000010000000000;
			`OR:controls<= 26'b11000000000000010000000000;
			`XOR:controls<=26'b11000000000000010000000000;
			`NOR:controls<=26'b11000000000000010000000000;

			`SLL:controls<=26'b11000000000000010000000000;
			`SRL:controls<=26'b11000000000000010000000000;
			`SRA:controls<=26'b11000000000000010000000000;
			`SLLV:controls<=26'b11000000000000010000000000;
			`SRLV:controls<=26'b11000000000000010000000000;
			`SRAV:controls<=26'b11000000000000010000000000;
			
			`ADD:controls<= 26'b11000000000000010000000000;
			`ADDU:controls<=26'b11000000000000010000000000;
			`SUB:controls<=26'b11000000000000010000000000;
			`SUBU:controls<=26'b11000000000000010000000000;
			`SLT:controls<=26'b11000000000000010000000000;
			`SLTU:controls<=26'b11000000000000010000000000;
			
			`BREAK:controls<=26'b00000000000000011110000000;
			`SYSCALL:controls<=26'b00000000000000011110000000;
			default: controls<=26'b00000000000000011110000100;//illegal op
			endcase
			end
			
			//mfc0 and mtc0
            `SPECIAL3_INST: case(op2)
                6'b011000: controls<=26'b00000000000000011110000000;
                default: case(rs)
                    `MTC0:controls <= 26'b00000000000000010100000010;
                    `MFC0:controls <= 26'b10000000000000010010000001;
                    default: controls<=26'b00000000000000010000000100;
                endcase
            endcase

			//逻辑立即数指令扩展
			6'b001100:controls <= 26'b10100000000000000000000000;//ANDI
			6'b001110:controls <= 26'b10100000000000000010000000;//xori
			6'b001101:controls <= 26'b10100000000000000100000000;//ori
			6'b001111:controls <= 26'b10100000000000000110000000;//luii

            `ADDI:controls <=  26'b10100000000000001000000000;//R-TYRE
            `ADDIU:controls <= 26'b10100000000000001010000000;//R-TYRE
            `SLTI:controls <=  26'b10100000000000001100000000;//R-TYRE
            `SLTIU:controls <= 26'b10100000000000001110000000;//R-TYRE
            
             `BEQ,`BNE,`BLEZ,`BGTZ: controls=26'b00010000000000000000000000;
             
             6'b000001: begin case(rt)
                `BGEZ: controls = 26'b00010000000000000000000000;
                `BLTZ: controls = 26'b00010000000000000000000000;
                `BGEZAL: controls = 26'b10010000000000000001000000;
                `BLTZAL: controls = 26'b10010000000000000001000000;
             endcase end
             
             `J:controls <= 26'b00000000000010000000000000;//J
             `JAL:controls <= 26'b10000000000010000001000000;//JAL
             
             `LW: controls <= 26'b10100000111100001000000000;
             `LB: controls <= 26'b10100000000100001000000000;
             `LH: controls <= 26'b10100000001100001000000000;
             `LBU: controls <= 26'b10100000000100001000001000;
             `LHU: controls <= 26'b10100000001100001000001000;
             
             `SB: controls <= 26'b00100001000000001000000000;
             `SH: controls <= 26'b00100011000000001000000000;
             `SW: controls <= 26'b00101111000000001000000000;
             
             
             
             
			default:  controls <= 26'b00000000000000011110000100;//illegal op
		endcase
	end
endmodule
