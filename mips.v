`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire[3:0] memwriteM,memtoregM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM ,
	output wire[31:0] pcW,
	output wire regwriteW,
	output wire [4:0] writeregW,
	output wire [31:0] resultW,
	output wire adesM,adelM,
	input wire i_stall,d_stall,
	output wire i_longest_stall,d_longest_stall,
	output wire inst_enF
    );
	
	wire [5:0] opD,functD;
	wire [4:0] rtD,rsD;
	wire regwriteD;
	wire regdstE,alusrcE;
	wire [3:0] memtoregD,memtoregE,memtoregW,memwriteE;
	wire regwriteE,regwriteM;
	wire [2:0] pcsrcD;
	wire [4:0] alucontrolE;
	wire [4:0] alucontrolM;
	wire flushE,stallE,equalD;
	wire hiD,loD,hiE,loE,hiM,loM,hiW,loW;
	wire islinkW;
	wire islinkE;
	wire islinkM;
	wire jrD,islinkD;
	wire stallM,stallW,stallD;
	
	wire jalrE;
	wire luW,luM,isvalidD,jalrD,cp0writeM,cp0readM,flushM,flushW;
	wire cp0readE;

	controller c(
		clk,rst,
		//decode stage
		opD,functD,rtD,rsD,
		equalD,pcsrcD,branchD,jumpD,hiD,loD,regwriteD,jrD,isvalidD,jalrD,islinkD,memtoregD,
		
		//execute stage
		flushE,stallE,flushM,flushW,
		memtoregE,memwriteE,alusrcE,
		regdstE,regwriteE,hiE,loE,islinkE,jalrE,	
		alucontrolE,cp0readE,

		//mem stage
		memtoregM,memwriteM,
		regwriteM,hiM,loM,islinkM,luM,cp0writeM,cp0readM,
		alucontrolM,
		//write back stage
		memtoregW,regwriteW,hiW,loW,islinkW,luW,
		
		stallM,stallW,stallD
		);
	datapath dp(
		clk,rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,branchD,
		jumpD,
		equalD,
		opD,functD,hiD,loD,regwriteD,jrD,isvalidD,jalrD,islinkD,memtoregD,
		//execute stage
		memtoregE,memwriteE,
		alusrcE,regdstE,
		regwriteE,
		alucontrolE,
		flushE,stallE,hiE,loE,islinkE,jalrE,cp0readE,
		//mem stage
		memtoregM,memwriteM,
		regwriteM,luM,adesM,adelM,
		aluoutM,writedataM,
		readdataM,hiM,loM,islinkM,cp0writeM,cp0readM,
		alucontrolM,
		//writeback stage
		memtoregW,
		regwriteW,hiW,loW,islinkW,luW,
		rtD,rsD,
		pcW,
		writeregW,
		resultW,flushM,flushW,
		
		inst_enF,
		i_stall,d_stall,
		i_longest_stall,d_longest_stall,
		stallM,stallW,stallD
	    );
	
endmodule
