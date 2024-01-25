/*exception妯″潡
    IF,ID,EXE,MEM妫?娴嬪埌鐨勪緥澶栭兘鏀惧湪MEM闃舵杩涜澶勭悊
*/
`timescale 1ns / 1ps

module exception(
	input rst,
	input [7:0] exceptM,
	input [31:0] pcM,
	input adel,ades,
	input wire[31:0] cp0_status,cp0_cause,aluoutM,
	output wire [31:0] excepttype,bad_addr
    );
	// exception type
	assign excepttype = (rst)? 32'h0000_0000:
	                      ((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00 && cp0_status[1] == 1'b0 && cp0_status[0] == 1'b1)? 32'h0000_0001: // interrupt
						  (ades==1'b1)?       32'h0000_0005: // syscall
						  (exceptM[2]==1'b1)? 32'h0000_000c: // 溢出
						  (exceptM[3]==1'b1)? 32'h0000_000a: // reserve
						  (exceptM[4]==1'b1)? 32'h0000_000e: // errot
						  (exceptM[5]==1'b1)? 32'h0000_0009: // break
						  (exceptM[6]==1'b1)? 32'h0000_0008: // 系统调用
						  (exceptM[7]==1'b1||adel)? 32'h0000_0004: // adel
						  32'h0;
        assign bad_addr = (rst)? 32'h0:
                      ((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00 && cp0_status[1] == 1'b0 && cp0_status[0] == 1'b1)? 32'h0:
                      (pcM[1:0]!=2'b00)? pcM:
                      (exceptM[2])? 32'h0:
                      (exceptM[3])? 32'h0:
                      (exceptM[4])? 32'h0:
                      (exceptM[5])? 32'h0:
                      (exceptM[6])? 32'h0:
                      (ades)? aluoutM:
                      (adel)? aluoutM:
                      32'h0;
endmodule
