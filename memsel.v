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
  input [31:0] addrs,     //�ô��ַ
  input [5:0] opM,
    output reg adelM,       //LH��LWָ���ַ������
    output reg adesM        //SH��SWָ���ַ������
    );
    
    always@(*) begin
        adelM <= 1'b0;      //����ֵ,��������latch
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
