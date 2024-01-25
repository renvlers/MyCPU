module mycpu_top(
    input [5:0] ext_int,
    input aclk,
    input aresetn,  //low active

    //axi
    //ar
    output [3 :0] arid         ,
    output [31:0] araddr       ,
    output [7 :0] arlen        ,
    output [2 :0] arsize       ,
    output [1 :0] arburst      ,
    output [1 :0] arlock        ,
    output [3 :0] arcache      ,
    output [2 :0] arprot       ,
    output        arvalid      ,
    input         arready      ,
    //r           
    input  [3 :0] rid          ,
    input  [31:0] rdata        ,
    input  [1 :0] rresp        ,
    input         rlast        ,
    input         rvalid       ,
    output        rready       ,
    //aw          
    output [3 :0] awid         ,
    output [31:0] awaddr       ,
    output [7 :0] awlen        ,
    output [2 :0] awsize       ,
    output [1 :0] awburst      ,
    output [1 :0] awlock       ,
    output [3 :0] awcache      ,
    output [2 :0] awprot       ,
    output        awvalid      ,
    input         awready      ,
    //w          
    output [3 :0] wid          ,
    output [31:0] wdata        ,
    output [3 :0] wstrb        ,
    output        wlast        ,
    output        wvalid       ,
    input         wready       ,
    //b           
    input  [3 :0] bid          ,
    input  [1 :0] bresp        ,
    input         bvalid       ,
    output        bready       ,
    
    //debug
    output wire [31:0] debug_wb_pc,
	output wire [3:0] debug_wb_rf_wen,
	output wire [4:0] debug_wb_rf_wnum,
	output wire [31:0] debug_wb_rf_wdata
);

// �?个例�?
    wire inst_sram_en;
    wire [3:0] inst_sram_wen;
    wire [31:0] inst_sram_addr;
    wire [31:0] inst_sram_wdata;
    wire [31:0] inst_sram_rdata;
    wire i_stall;
    
    wire inst_req;
    wire inst_wr;
    wire [1:0] inst_size;
    wire [31:0] inst_addr;
    wire [31:0] inst_wdata;
    wire inst_addr_ok;
    wire inst_data_ok;
    wire [31:0] inst_rdata;
    wire i_longest_stall;
    
    wire data_sram_en;
    wire [3:0] data_sram_wen;
    wire [31:0] data_sram_addr;
    wire [31:0] data_sram_wdata;
    wire [31:0] data_sram_rdata;
    wire d_stall;
    
    wire data_req;
    wire data_wr;
    wire [1:0] data_size;
    wire [31:0] data_addr;   
    wire [31:0] data_wdata;
    wire [31:0] data_rdata;
    wire data_addr_ok;
    wire data_data_ok;
    wire d_longest_stall;

	wire [31:0] pc,pcconvert;
	wire [31:0] instr;
	wire [3:0] memwrite,memtoreg;
	wire [31:0] aluout, writedata, readdata, dataaddr;
	wire nocache;
	wire [31:0] pcW;
	wire regwrite;
	wire [4:0] writereg;
	wire [31:0] result;
	wire ades,adel;
	wire inst_en;
	wire clk,resetn;
	
	assign clk = aclk;
	assign resetn = aresetn;
	
//	wire cache_inst_req;
//    wire cache_inst_wr;
//    wire [1 :0] cache_inst_size;
//    wire [31:0] cache_inst_addr;
//    wire [31:0] cache_inst_wdata;
//    wire [31:0] cache_inst_rdata;
//    wire cache_inst_addr_ok;
//    wire cache_inst_data_ok ;
    
//    wire cache_data_req;
//    wire cache_data_wr;
//    wire [1 :0] cache_data_size;
//    wire [31:0] cache_data_addr;
//    wire [31:0] cache_data_wdata;
//    wire [31:0] cache_data_rdata;
//    wire cache_data_addr_ok;
//    wire cache_data_data_ok;
    
//    i_cache_direct_map icache(
//        clk,~resetn,
        
//        inst_req,
//        inst_wr,
//        inst_size,
//        inst_addr,
//        inst_wdata,
//        inst_rdata,
//        inst_addr_ok,
//        inst_data_ok,
        
//        cache_inst_req,
//        cache_inst_wr,
//        cache_inst_size,
//        cache_inst_addr,
//        cache_inst_wdata,
//        cache_inst_rdata,
//        cache_inst_addr_ok,
//        cache_inst_data_ok 
//    );
    
//    d_cache_write_through dcache(
//        clk,~resetn,
        
//        data_req,
//	    data_wr,
//	    data_size,
//	    data_addr,
//	    data_wdata,
//	    data_rdata,
//	    data_addr_ok,
//	    data_data_ok,
	    
//	    cache_data_req     ,
//        cache_data_wr      ,
//        cache_data_size    ,
//        cache_data_addr    ,
//        cache_data_wdata   ,
//        cache_data_rdata   ,
//        cache_data_addr_ok ,
//        cache_data_data_ok 
//    );
	
	i_sram_to_sram_like istil(
	   clk,
	   ~resetn,
	   
	   // sram
	   inst_sram_en,
	   inst_sram_addr,
	   inst_sram_rdata,
	   i_stall,
	   
	   // sram-like
	   inst_req,
	   inst_wr,
	   inst_size,
	   inst_addr,
	   inst_wdata,
	   inst_addr_ok,
	   inst_data_ok,
	   inst_rdata,
	   
	   i_longest_stall
	);
	
	d_sram_to_sram_like dstdl(
	   clk,
	   ~resetn,
	   
	   // sram
	   data_sram_en,
	   data_sram_addr,
	   data_sram_rdata,
	   data_sram_wen,
	   data_sram_wdata,
	   d_stall,
	   
	   // sram_like
	   data_req,
	   data_wr,
	   data_size,
	   data_addr,
	   data_wdata,
	   data_rdata,
	   data_addr_ok,
	   data_data_ok,
	   
	   d_longest_stall
	);
	
	mmu mmu0(
		.inst_vaddr(pc),
    	.inst_paddr(pcconvert),
  		.data_vaddr(aluout),
   		.data_paddr(dataaddr),
		.no_dcache(nocache)
		);
		
	cpu_axi_interface s2a(
	   clk,
       resetn, 
       
       inst_req     ,
       inst_wr      ,
       inst_size    ,
       inst_addr    ,
       inst_wdata   ,
       inst_rdata   ,
       inst_addr_ok ,
       inst_data_ok ,
    
       data_req     ,
       data_wr      ,
       data_size    ,
       data_addr    ,
       data_wdata   ,
       data_rdata   ,
       data_addr_ok ,
       data_data_ok ,

    //axi
    //ar
       arid         ,
       araddr       ,
       arlen        ,
       arsize       ,
       arburst      ,
       arlock        ,
       arcache      ,
       arprot       ,
       arvalid      ,
       arready      ,
    //r           
       rid          ,
       rdata        ,
       rresp        ,
       rlast        ,
       rvalid       ,
       rready       ,
    //aw          
       awid         ,
       awaddr       ,
       awlen        ,
       awsize       ,
       awburst      ,
       awlock       ,
       awcache      ,
       awprot       ,
       awvalid      ,
       awready      ,
    //w          
       wid          ,
       wdata        ,
       wstrb        ,
       wlast        ,
       wvalid       ,
       wready       ,
    //b           
       bid          ,
       bresp        ,
       bvalid       ,
       bready       
	);
	
    mips mips(
        .clk(~clk),
        .rst(~resetn),
        //instr
        // .inst_en(inst_en),
        .pcF(pc),                    //pcF
        .instrF(instr),              //instrF
        //data
        // .data_en(data_en),
        .memwriteM(memwrite),
        .memtoregM(memtoreg),
        .aluoutM(aluout),
        .writedataM(writedata),
        .readdataM(readdata),
        .pcW(pcW),
        .regwriteW(regwrite),
        .writeregW(writereg),
        .resultW(result),
        .adesM(ades),
        .adelM(adel),
        .i_stall(i_stall),
        .d_stall(d_stall),
        .i_longest_stall(i_longest_stall),
        .d_longest_stall(d_longest_stall),
        .inst_enF(inst_en)
    );

    assign inst_sram_en = inst_en;     //如果有inst_en，就用inst_en
    assign inst_sram_wen = 4'b0;
    assign inst_sram_addr = pcconvert;
    assign inst_sram_wdata = 32'b0;
    assign instr = inst_sram_rdata;

    assign data_sram_en = ~adel & (|memtoreg | (|memwrite));     //如果有data_en，就用data_en
    assign data_sram_wen = ~ades ? (memwrite == 4'b0001 ? memwrite << aluout[1:0] : (memwrite == 4'b0011 ? memwrite << {aluout[1], 1'b0} : (memwrite == 4'b1111 ? memwrite : 4'b0000))) : 4'b0000;
    assign data_sram_addr = dataaddr;
    assign data_sram_wdata = memwrite == 4'b0001 ? writedata << 8*aluout[1:0] : (memwrite == 4'b0011 ? writedata << 8*{aluout[1], 1'b0} : writedata);
    assign readdata = data_sram_rdata;
    
    assign	debug_wb_pc			= pcW;
	assign	debug_wb_rf_wen		= regwrite & (~i_stall & ~d_stall);
	assign	debug_wb_rf_wnum	= writereg;
	assign	debug_wb_rf_wdata	= result;

    //ascii
    instdec instdec(
        .instr(instr)
    );

endmodule