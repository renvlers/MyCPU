`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input wire clk,rst,
	//decode stage
	input wire[5:0] opD,functD,
	input wire[4:0] rtD,rsD,
	input wire equalD,
	output wire[2:0] pcsrcD,
	output wire branchD,jumpD,hiD,loD,regwriteD,jrD,isvalidD,jalrD,islinkD,
	output wire [3:0] memtoregD,
	
	//execute stage
	input wire flushE,stallE,flushM,flushW,
	output wire [3:0] memtoregE,memwriteE,
	output wire alusrcE,
	output wire regdstE,regwriteE,hiE,loE,islinkE,jalrE,
	output wire[4:0] alucontrolE,
	output wire cp0readE,

	//mem stage
	output wire [3:0] memtoregM,memwriteM,
	output wire regwriteM,hiM,loM,islinkM,luM,cp0writeM,cp0readM,
	output wire[4:0] alucontrolM,
	//write back stage
	output wire [3:0] memtoregW,
	output wire regwriteW,hiW,loW,islinkW,luW,
	
	input wire stallM, stallW, stallD
    );
	
	//decode stage
	wire[3:0] aluopD;
	wire [3:0] memwriteD;
	wire alusrcD,regdstD;
	wire[4:0] alucontrolD;
//	wire islinkD;
	
//	wire jalrD;

	//execute stage
	
	wire luD,luE;
    wire cp0writeD,cp0writeE,cp0readD;
    
	maindec md(
		opD,
		functD,
		rtD,rsD,
		memtoregD,memwriteD,
		branchD,alusrcD,
		regdstD,regwriteD,
		jumpD,
		hiD,
		loD,
		aluopD,
		islinkD,
		jrD,
		jalrD,
		luD,
		isvalidD,
		cp0writeD,cp0readD
		);
	aludec ad(functD,aluopD,alucontrolD);

	assign pcsrcD = {jrD, jumpD, branchD & equalD};

	//pipeline registers
	flopenrc #(23) regE(
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,hiD,loD,alucontrolD,islinkD,jalrD,luD,cp0writeD,cp0readD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,hiE,loE,alucontrolE,islinkE,jalrE,luE,cp0writeE,cp0readE}
		);
	flopenrc #(20) regM(
		clk,rst,~stallM,flushM,
		{memtoregE,memwriteE,regwriteE,hiE,loE,islinkE,luE,cp0writeE,cp0readE,alucontrolE},
		{memtoregM,memwriteM,regwriteM,hiM,loM,islinkM,luM,cp0writeM,cp0readM,alucontrolM}
		);
	flopenrc #(9) regW(
		clk,rst,~stallW,flushW,
		{memtoregM,regwriteM,hiM,loM,islinkM,luM},
		{memtoregW,regwriteW,hiW,loW,islinkW,luW}
		);
endmodule
