`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/03 23:05:16
// Design Name: 
// Module Name: ldmux
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


module ldmux(
    input wire [31:0] in1, in2,
    input wire [3:0] memtoreg,
    input wire [1:0] offset,
    input wire lu,
    output wire [31:0] out
    );
    
    reg [31:0] outreg,outregtmp;
    reg [31:0] numshift;
    
    always@(*) begin
        if(memtoreg == 4'b0001) numshift = in2 >> (8 * offset);
        else if(memtoreg == 4'b0011) numshift = in2 >> (8 * {offset[1], 1'b0});
        else numshift = in2;
    
        case(memtoreg)
            4'b0000: outregtmp = in1;
            default: outregtmp = numshift & ({{8{memtoreg[3]}}, {8{memtoreg[2]}}, {8{memtoreg[1]}}, {8{memtoreg[0]}}});
        endcase
        
        if((|memtoreg) && ~lu) begin
            if(memtoreg == 4'b0001) outreg = {{24{outregtmp[7]}}, outregtmp[7:0]};
            else if(memtoreg == 4'b0011) outreg = {{16{outregtmp[15]}}, outregtmp[15:0]};
            else outreg = outregtmp;
        end
        else outreg = outregtmp;
    end
    
    assign out = outreg;
    
endmodule
