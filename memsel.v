`timescale 1ns / 1ps
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/05 11:18:28
// Design Name: 
// Module Name: memsel
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


module memsel(
  input [31:0] addrs,     //访存地址
  input [5:0] opM,
    output reg adelM,       //LH、LW指令地址错例外
    output reg adesM        //SH、SW指令地址错例外
    );
    
    always@(*) begin
        adelM <= 1'b0;      //赋初值,否则生成latch
        adesM <= 1'b0;
        case (opM)
            `LH: if (addrs[1:0] != 2'b00 & addrs[1:0] != 2'b10 ) begin
                adelM <= 1'b1;
            end
            `LHU: if ( addrs[1:0] != 2'b00 & addrs[1:0] != 2'b10 ) begin
                adelM <= 1'b1;
            end
            `LW: if ( addrs[1:0] != 2'b00 ) begin
                adelM <= 1'b1;
            end
            `SH: if (addrs[1:0] != 2'b00 & addrs[1:0] != 2'b10 ) begin
                adesM <= 1'b1;
            end
            `SW: if ( addrs[1:0] != 2'b00 ) begin
                adesM <= 1'b1;
            end
            default: begin
                adelM <= 1'b0;
                adesM <= 1'b0;
            end
        endcase
    end
endmodule
