`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
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


module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire [2:0] pcsrcD,
	input wire branchD,
	input wire jumpD,
	output wire equalD,
	output wire[5:0] opD,functD,
	input wire hiD,loD,regwriteD,jrD,isvalidD,jalrD,islinkD,
	input wire [3:0] memtoregD,
	//execute stage
	input wire [3:0] memtoregE,memwriteE,
	input wire alusrcE,regdstE,
	input wire regwriteE,
	input wire[4:0] alucontrolE,
	output wire flushE,stallE,
	input wire hiE,loE,islinkE,jalrE,cp0readE,
	//mem stage
	input wire [3:0] memtoregM,memwriteM,
	input wire regwriteM,luM,
	output wire adesM,adelM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM,
	input wire hiM,loM,islinkM,cp0writeM,cp0readM,
	input wire[4:0] alucontrolM,
	//writeback stage
	input wire [3:0] memtoregW,
	input wire regwriteW,hiW,loW,islinkW,luW,
	output wire [4:0] rtD,rsD,
	output wire [31:0] pcW,
	output wire [4:0] writeregW,
	output wire [31:0] resultW,
	output wire flushM,flushW,
	
	output wire inst_enF,
	input wire i_stall,d_stall,
	output wire i_longest_stall,d_longest_stall,
	output wire stallM,stallW,stallD
    );
	
	//fetch stage
	wire stallF,flushF;
	//FD
	wire [31:0] pcnextFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D,instrD,instrE;
	wire [1:0] forwardaD,forwardbD;
	wire W_hilo;
	wire [4:0] rdD;
	wire flushD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	//execute stage
	wire [1:0] forwardaE,forwardbE;
	wire [4:0] rsE,rtE,rdE;
	wire [4:0] writeregE;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E,srcb4E,srcb5E;
	wire [31:0] aluoutE;
	//mem stage
	wire [4:0] writeregM;
	//writeback stage
	wire [63:0] hilo_W;//hilo¼Ä´æÆ÷
	wire [31:0] aluoutW,readdataW,div_a,div_b;
	wire[4:0] saD,saE;
	wire [63:0] temp,div_result;
	wire [63:0] hilo_G,hilo_R,hilo_M,hilo_R2;
    wire div_start,div_signed,div_annul;
	wire div_ready,M_hilo,E_hilo;
	
	//link output
	wire [31:0] linkD,linkE,linkM;
	
	wire [31:0] resulttmpM,resultM;
	
	wire [31:0] pcD, pcE, pcM;
    wire pcselect;
	reg pcselectreg;
	
	wire [31:0] pcnexttmpFD,temps;
	wire [31:0] jrtargetD;
	wire [7:0] exceptF,exceptD,exceptE,exceptM; 
	wire syscallD,breakD,eretD,overflowD,is_in_delayslot_i;
    wire [5:0] opE,opM;
	wire[4:0] writetmpregE,rdM;
	wire [31:0] cp0_status,cp0_cause,excepttype,bad_addr,newpc;
	wire is_in_delayslot_iF,is_in_delayslot_iE,is_in_delayslot_iD,is_in_delayslot_iM;
	wire[31:0] data_oE,count_oE,compare_oE,status_oE,cause_oE,epc_oE,config_oE,prid_oE,badvaddr,timer_int_oE,data_i;
	wire [31:0] data_o,count_o,compare_o,status_o,cause_o,epc_o,config_o,prid_o,timer_int_o;
	flopenrc #(32) cp0EM0(clk,rst,~stallM,flushM,data_oE,data_o);
	flopenrc #(32) cp0EM1(clk,rst,~stallM,flushM,status_oE,status_o);
	flopenrc #(32) cp0EM2(clk,rst,~stallM,flushM,cause_oE,cause_o);
	flopenrc #(32) cp0EM3(clk,rst,~stallM,flushM,epc_oE,epc_o);
	
	wire cp0forward;
	
	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		//decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,
		memtoregD,
		//execute stage
		rsE,rtE,
		writeregE,
		regwriteE,
		memtoregE,memwriteE,
		forwardaE,forwardbE,
		flushE,stallE,
		aluoutE,
		//mem stage
		writeregM,
		regwriteM,
		memtoregM,memwriteM,
		aluoutM,
		//write back stage
		writeregW,
		regwriteW,
		alucontrolE,
		div_ready,
		excepttype,
		newpc,
		epc_o,
		flushF,flushD,flushM,flushW,
		rdE,rdM,
		cp0readE, cp0writeM,
		cp0forward,
		i_stall,d_stall,
		i_longest_stall,d_longest_stall,
		stallM,stallW
		);

	//next PC logic (operates in fetch an decode)

	m4 jrforward(srcaD, islinkE ? linkE : (cp0readE ? data_oE : aluoutE), resultM, resultW, forwardaD, jrtargetD);
	
	mux3 #(32) pcmux(pcplus4F,pcbranchD,{pcplus4D[31:28],instrD[25:0],2'b00},pcsrcD[1:0],pcnexttmpFD);
	mux2 #(32) jrmux(pcnexttmpFD, jrtargetD, pcsrcD[2], pcnextFD);

	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

    
	//fetch stage logic
	pc #(32) pcreg(clk,rst,~stallF,flushF,pcnextFD,newpc,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);
	
	//pcÎ´¶ÔÆë
	assign exceptF=(pcF[1:0]==2'b00)?8'b00000000:8'b10000000;
	assign is_in_delayslot_iF=(jumpD|branchD|jrD|jalrD|islinkD);
	assign inst_enF = ~exceptF[7];
	//decode stage
	flopenrc #(32) r0D(clk,rst,~stallD,flushD,pcF,pcD);
	flopenrc #(32) r1D(clk,rst,~stallD,flushD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	flopenrc #(8) r3D(clk,rst,~stallD,flushD,exceptF,exceptD);
	flopenrc #(1) r4D(clk,rst,~stallD,flushD,is_in_delayslot_iF,is_in_delayslot_iD);
	signext se(instrD[15:0],instrD[29:28],signimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	m4 forwardamux(srcaD,islinkE ? linkE : (cp0readE ? data_oE : aluoutE),resultM,resultW,forwardaD,srca2D);
	m4 forwardbmux(srcbD,islinkE ? linkE : (cp0readE ? data_oE : aluoutE),resultM,resultW,forwardbD,srcb2D);
	eqcmp comp(opD,rtD,srca2D,srcb2D,equalD);
	adder linkadd2(pcplus4D, 32'b100, linkD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
    assign saD = instrD[10:6];
    
   
    assign syscallD=(opD==6'b000000&&functD==6'b001100);
    assign breakD=(opD==6'b000000&&functD==6'b001101);
    assign eretD=(instrD==32'b01000010000000000000000000011000);
    
	//execute stage
	flopenrc #(32) r0E(clk,rst,~stallE,flushE,pcD,pcE);
	flopenrc #(32) r2D1(clk,rst,~stallE,flushE,instrD,instrE);
	flopenrc #(32) r1E(clk,rst,~stallE,flushE,srcaD,srcaE);
	flopenrc #(32) r2E(clk,rst,~stallE,flushE,srcbD,srcbE);
	flopenrc #(32) r3E(clk,rst,~stallE,flushE,signimmD,signimmE);
	flopenrc #(5) r4E(clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5) r5E(clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5) r6E(clk,rst,~stallE,flushE,rdD,rdE);
	flopenrc #(6) r23E(clk,rst,~stallE,flushE,opD,opE);
    flopenrc #(5) r7E(clk,rst,~stallE,flushE,saD,saE);
    flopenrc #(32) r8E(clk,rst,~stallE,flushE,linkD,linkE);
    flopenrc #(8) r9E(clk,rst,~stallE,flushE,{exceptD[7],syscallD,breakD,eretD,isvalidD,exceptD[2:0]},exceptE);
    flopenrc #(1) r10E(clk,rst,~stallE,flushE,is_in_delayslot_iD,is_in_delayslot_iE);
    
	mux3 #(32) forwardaemux(srcaE,resultW,resultM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,resultM,forwardbE,srcb2E);
	mux2 #(32) srcbmux1(srcb2E,signimmE,alusrcE,srcb3E);
//	shshsh shsh(div_start,alucontrolE,srca2E,srcb3E,div_a,div_b);

	devdem divdec(alucontrolE,div_ready,flushM,div_start, div_signed, div_annul);
	div div(clk,rst,div_signed,srca2E,srcb3E,div_start,1'b0,i_stall,d_stall,div_result,div_ready);
	
	alu alu(saE,srca2E,srcb3E,alucontrolE,aluoutE,hiM,loM,hiE,loE,hilo_M,hilo_G,hilo_R,W_hilo,div_result,div_ready,overflowD,alucontrolM);
	
	
	mux2 #(5) wrmux(rtE,rdE,regdstE,writetmpregE);
	mux2 #(5) lmux(writetmpregE,5'b11111,islinkE & ~jalrE,writeregE);
    
	//mem stage
	flopenrc #(32) r0M(clk,rst,~stallM,flushM,pcE,pcM);
	flopenrc #(32) r19M(clk,rst,~stallM,flushM,opE,opM);
	flopenrc #(5) r20M(clk,rst,~stallM,flushM,rdE,rdM);
	flopenrc #(32) r12M(clk,rst,~stallM,flushM,srcb3E,data_i);
	flopenrc #(32) r1M(clk,rst,~stallM,flushM,srcb2E,writedataM);
	flopenrc #(32) r2M(clk,rst,~stallM,flushM,aluoutE,aluoutM);
	flopenrc #(8) r5M(clk,rst,~stallM,flushM,{exceptE[7:3],overflowD,exceptE[1:0]},exceptM);
	flopenrc #(1) r43M(clk,rst,~stallM,flushM,is_in_delayslot_iE,is_in_delayslot_iM);
	flopenrc #(1) r7M(clk,rst,~stallM,flushM,W_hilo,M_hilo);
	
	wire [31:0] dataotmpE;
	memsel ls(aluoutM,opM,adelM,adesM);
	exception shshshw(rst,exceptM,pcM,adelM,adesM,status_o,cause_o,aluoutM,excepttype,bad_addr);
	cp0_reg cp0(clk,rst,cp0writeM,rdM,rdE,data_i,6'b000000,excepttype,pcM,is_in_delayslot_iM,bad_addr,dataotmpE,count_oE,compare_oE,status_oE,cause_oE,epc_oE,config_oE,prid_oE,badvaddrE,timer_int_oE);
	mux2 #(32) cp0f(dataotmpE, data_i, cp0forward, data_oE);
	
	mux2 #(32) cp0selmux(aluoutM,data_o,cp0readM,temps);
	flopenrc #(64) xgxg(clk,rst,~stallM,flushM,hilo_R,hilo_M);
	flopenrc #(5) r3M(clk,rst,~stallM,flushM,writeregE,writeregM);
	flopenrc #(32) r4M(clk,rst,~stallM,flushM,linkE,linkM);
	ldmux resmux(temps,readdataM,memtoregM,aluoutM[1:0],luM,resulttmpM);
	mux2 #(32) restmpmux(resulttmpM, linkM, islinkM, resultM);

	//writeback stage
	flopenrc #(32) r0w(clk,rst,~stallW,flushW,pcM,pcW);
	flopenrc #(32) r1W(clk,rst,~stallW,flushW,resultM,resultW);
	flopenrc #(5) r3W(clk,rst,~stallW,flushW,writeregM,writeregW);
	flopenrc #(1) r8M(clk,rst,~stallW,flushW,M_hilo,E_hilo);
	flopenrc #(64) xgxg2(clk,rst,~stallW,flushW,hilo_M,hilo_R2);
	mux6 ts(temp[63:0],hilo_G[63:0]);
	mux5  srcbmux3(E_hilo,hilo_R2[63:32],aluoutW,temp[63:32],hiW,hilo_W[63:32]);
	mux5  srcbmux4(E_hilo,hilo_R2[31:0],aluoutW,temp[31:0],loW,hilo_W[31:0]);
	hilo_reg hsh1(clk,rst,E_hilo,hiW,loW,hilo_W[63:32],hilo_W[31:0],hilo_G[63:32],hilo_G[31:0]);
	
	
endmodule
