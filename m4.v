`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/03 20:25:23
// Design Name: 
// Module Name: m4
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


module m4(
    input [31:0] in1, in2, in3, in4,
    input [1:0] sw,
    output [31:0] out
    );
    
    assign out = sw == 2'b00 ? in1 :
                 sw == 2'b01 ? in2 :
                 sw == 2'b10 ? in3 :
                 in4;
    
//    always@(*) case(sw)
//        2'b00: out = in1;
//        2'b01: out = in2;
//        2'b10: out = in3;
//        2'b11: out = in4;
//    endcase
    
endmodule
