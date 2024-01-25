`timescale 1ns / 1ps
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
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


module alu(
    input wire[4:0] sa,
	input wire[31:0] a,b,
	input wire[4:0] op,
	output reg[31:0] y,
	input wire hiM,loM,hiE,loE,
	input wire[63:0]aluoutM,
	input wire[63:0] hilo_G,
	output reg[63:0] hilo_R,
	output wire W_hilo, 
	input wire[63:0] div_result,
	input wire div_ready, 
	output reg overflow,
	input wire[4:0] alucontrolM
    );
	wire[31:0] s,bout;
	//定义有符号变量>>>移位运算符才起作用
	wire signed [31:0] str1;
	wire [31:0] str2,str3;
    wire [31:0] str4,str5;
    wire[31:0] str6;
    wire[31:0] wei1,wei2;
    wire[63:0] hilo_1;
    
	assign str2 = hiE ?  hilo_G[63:32]: b;
	assign str3=(hiM && alucontrolM != `MFHI_CONTROL && alucontrolM != `MFLO_CONTROL)?aluoutM[63:32]:str2;
	assign str4 = loE ?  hilo_G[31:0]: b;
	assign str5=(loM && alucontrolM != `MFLO_CONTROL && alucontrolM != `MFHI_CONTROL)?aluoutM[31:0]:str4;
    assign str1={b[31],b[30:0]};
   
   assign str6=((a[31]==1&&b[31]==0)||(a[31]==1&&b[31]==1&&a<b)||(a[31]==0&&b[31]==0&&a<b))?1:0;
   
   assign wei1=((op==`MULT_CONTROL)&&(a[31]==1'b1))?(~a+1):a;
   assign wei2=((op==`MULT_CONTROL)&&(b[31]==1'b1))?(~b+1):b;
   assign hilo_1=((op==`MULT_CONTROL)&&(a[31]^b[31]))?~(wei1*wei2)+1:wei1*wei2;
   assign W_hilo=((op==`MULT_CONTROL)||(op==`MULTU_CONTROL)||((op==`DIV_CONTROL)&&(div_ready==1'b1))||((op==`DIVU_CONTROL)&&(div_ready==1'b1)))?1:0;
   
	always @(*) begin
		case (op)
			`AND_CONTROL:begin y<=a&b;overflow<=0;end
            `XOR_CONTROL:begin y<=a^b;overflow<=0;end
            `OR_CONTROL:begin y<=a|b;overflow<=0;end
            `LUI_CONTROL:begin y<={b[15:0],{16{1'b0}}};overflow<=0;end
            `NOR_CONTROL:begin y<=~(a|b);overflow<=0;end
            
            `SLL_CONTROL:begin y<=b<<sa;overflow<=0;end
            `SRL_CONTROL:begin y<=b>>sa;overflow<=0;end
            `SRA_CONTROL:begin y<=str1>>>sa;overflow<=0;end
            `SLLV_CONTROL:begin y<=b<<a[4:0];overflow<=0;end
            `SRLV_CONTROL:begin y<=b>>a[4:0];overflow<=0;end
            `SRAV_CONTROL:begin y<=str1>>>a[4:0];overflow<=0;end
            
            `MFHI_CONTROL:begin y<=str3;overflow<=0;end
            `MTHI_CONTROL:begin y<=a;overflow<=0;hilo_R[63:32]=a;end
            `MFLO_CONTROL:begin y<=str5;overflow<=0;end
            `MTLO_CONTROL:begin y<=a;overflow<=0;hilo_R[31:0]=a;end
            
            `ADD_CONTROL:begin y<=a+b; 
            overflow<= (~y[31] & a[31] & b[31]) | (y[31] & ~a[31] & ~b[31]);end
            `ADDU_CONTROL:begin y<=a+b;overflow<=0;end
            `SUB_CONTROL:begin y<=a-b;
            overflow<= (~y[31] & a[31] & ~b[31]) | (y[31] & ~a[31] & b[31]);end
            `SUBU_CONTROL:begin y<=a-b;overflow<=0;end
            `SLT_CONTROL:begin y<=str6;overflow<=0;end
            `SLTU_CONTROL:begin y<=a<b;overflow<=0;end
            `MULT_CONTROL:begin hilo_R=hilo_1;overflow<=0;end
            `MULTU_CONTROL:begin hilo_R=hilo_1;overflow<=0;end
            `DIV_CONTROL:begin hilo_R=div_result;overflow<=0;end
            `DIVU_CONTROL:begin hilo_R=div_result;overflow<=0;end
			default :begin y <= 32'b0;overflow<=0;hilo_R<=0;end
		endcase	
	end

	
endmodule
