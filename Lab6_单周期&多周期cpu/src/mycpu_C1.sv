module mycpu_C1 (
    input           clk,
    input           rstn,

    output          inst_ram_we,
    output  [9:0]   inst_ram_addr,
    output  [31:0]  inst_ram_wdata,
    input   [31:0]  inst_ram_rdata,

    output          data_ram_we,
    output  [9:0]   data_ram_addr,
    output  [31:0]  data_ram_wdata,
    input   [31:0]  data_ram_rdata

    //用于测试的对外接口
    // output    [4:0]       rd;
    // output    [31:0] wb_data;
    // output    [31:0]      nextpc;
    // output reg    [31:0]      pc;
    // output    [31:0]      inst;
    // output    [4:0] rf_raddr1;
    // output    [4:0] rf_raddr2;   
    // output    [31:0] alu_result;
);

reg     [31:0]      pc;
wire    [31:0]      nextpc;
wire    [31:0]      inst;
wire    [4:0]       rk;
wire    [4:0]       rj;
wire    [4:0]       rd;
wire    [11:0]      si_12;
wire    [19:0]      si_20;
wire    [15:0]      offs_16;

wire    [5:0]       op_31_26;
wire    [3:0]       op_25_22;
wire    [1:0]       op_21_20;
wire    [4:0]       op_19_15;
wire    [63:0]      op_31_26_d;
wire    [16:0]      op_25_22_d;
wire    [4:0]       op_21_20_d;
wire    [32:0]      op_19_15_d;

wire inst_add_w;
wire inst_addi_w; 
wire inst_ld_w;   
wire inst_st_w;   
wire inst_bne;    
wire inst_lu12i_w;

wire alu_src1;     
wire alu_src2;     
wire alu_op;       
wire rf_we;        
wire rf_raddr2_sel;
wire imm_sel;      
wire wb_sel;       
wire br_type;

wire [4:0] rf_raddr1;
wire [4:0] rf_raddr2;

wire [31:0] br_offs  ;
wire [31:0] br_target;
wire rj_eq_rd;
wire br_en;

wire [31:0] si_12_to_32;  
wire [31:0] si_20_to_32;  
wire [31:0] imm;          
wire [31:0] alu_result;   
wire [31:0] wb_data;
wire [31:0] rf_rdata1;
wire [31:0] rf_rdata2;     

assign inst_ram_we     = 1'b1;
assign inst_ram_addr   = pc;
assign inst_ram_wdata  = 32'b0;
assign inst             = inst_ram_rdata;

assign data_ram_addr   = alu_result;
assign data_ram_wdata  = rf_rdata2;

always@(posedge clk) begin
    if(!rstn)begin
        pc <= 32'h1c000000;
    end
    else begin
        pc <= nextpc;
    end
end

//指令的截取
assign op_31_26 = inst[31:26];
assign op_25_22 = inst[25:22];
assign op_21_20 = inst[21:20];
assign op_19_15 = inst[19:15];
assign rk       = inst[14:10];
assign rj       = inst[9:5];
assign rd       = inst[4:0];
assign si_12    = inst[21:10];
assign si_20    = inst[24:5];
assign offs_16  = inst[25:10];

//指令分段译码
decoder_6_64 u_dec0(.in(op_31_26),  .co(op_31_26_d));
decoder_4_16 u_dec1(.in(op_25_22),  .co(op_25_22_d));
decoder_2_4  u_dec2(.in(op_21_20),  .co(op_21_20_d));
decoder_5_32 u_dec3(.in(op_19_15),  .co(op_19_15_d));

//指令信号的生成
assign inst_add_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00];
assign inst_addi_w  = op_31_26_d[6'h00] & op_25_22_d[4'ha];
assign inst_ld_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
assign inst_st_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h6];
assign inst_bne     = op_31_26_d[6'h17];
assign inst_lu12i_w = op_31_26_d[6'h5];

//控制信号的生成
assign alu_src1     = inst_lu12i_w ? 32'h00000000 : rf_rdata1;
assign alu_src2     = (inst_lu12i_w | inst_addi_w | inst_st_w | inst_ld_w) ? imm : rf_rdata2;
assign alu_op       = inst_add_w;//ALU操作数的生成逻辑，先暂时设置为加法，暂时用不上
assign data_ram_we = inst_st_w;
assign rf_we        = inst_add_w | inst_addi_w | inst_ld_w;
assign rf_raddr2_sel= inst_st_w | inst_bne;//值为1时，另一个寄存器为rd，否则为rk
assign imm_sel      = inst_lu12i_w;//值为1时，选择{si_20,12{0}}
assign wb_sel       = inst_ld_w;//值为1时，写回DR中的值; 值为0时，写回ALU_result
assign br_type      = inst_bne;//br_type生成逻辑，暂时等于inst_bne，暂时用不上

assign rf_raddr1    = rj;
assign rf_raddr2    = rf_raddr2_sel ? rd : rk;

regfile u_regfile(
    .clk    (clk        ),
    .raddr1 (rf_raddr1  ),
    .raddr2 (rf_raddr2  ),
    .rdata1 (rf_rdata1  ),
    .rdata2 (rf_rdata2  ),
    .we     (rf_we      ),
    .waddr  (rd         ),
    .wdata  (wb_data    )
);

assign br_offs      = {14'b0, offs_16, 2'b0};
assign br_target    = pc + br_offs;
assign rj_eq_rd     = (rf_rdata1 == rf_rdata2);
assign br_en        = inst_bne && !rj_eq_rd;
assign nextpc       = br_en ? br_target : (pc + 4);

assign si_12_to_32  = {{20{si_12[11]}},si_12[11:0]};
assign si_20_to_32  = {si_20[19:0],12'b0};
assign imm          = imm_sel ? si_20_to_32 : si_12_to_32;

assign alu_result   = alu_src1 + alu_src2;

assign wb_data      = wb_sel ? data_ram_rdata : alu_result;

endmodule