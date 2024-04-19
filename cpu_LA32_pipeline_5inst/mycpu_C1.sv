module mycpu_C1 (
    input           clk,
    input           rstn,

    output          inst_sram_we,
    output  [31:0]  inst_sram_addr,
    output  [31:0]  inst_sram_wdata,
    input   [31:0]  inst_sram_rdata,

    output          data_sram_we_out,
    output  [31:0]  data_sram_addr,
    output  [31:0]  data_sram_wdata,
    input   [31:0]  data_sram_rdata

    //Ports For Debug
    ,input  [4:0] rra0
    ,output [31:0] rrd0
    //,output ctr_debug
    ,output [31:0] npc
    ,output [31:0] pc_out
    ,output [31:0] ir
    ,output [31:0] pc_id
    ,output [31:0] ir_id
    ,output [31:0] pc_ex
    ,output [31:0] ir_ex
    ,output [31:0] rrd1
    ,output [31:0] rrd2
    ,output [31:0] imm_out
    ,output [31:0] ir_mem
    ,output [31:0] res
    ,output [31:0] ir_wb
    ,output [31:0] res_wb
    ,output [31:0] rwd
);

reg         valid;
always @(posedge clk) begin
    if (!rstn) begin
        valid <= 1'b0;
    end
    else begin
        valid <= 1'b1;
    end
end

reg     [31:0]      pc;
wire    [31:0]      seqpc;
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
wire inst_beq;
wire inst_lu12i_w;
    
wire alu_src1_sel;
wire alu_src2_sel;
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

wire [31:0] alu_src1;     
wire [31:0] alu_src2; 
wire [31:0] alu_result;

wire [31:0] wb_data;
wire [31:0] rf_rdata1;
wire [31:0] rf_rdata2;

//Registers For Pipeline
reg [31:0] IFID_inst;//IR
reg [31:0] IFID_pc;

reg [31:0] IDEX_inst;
reg IDEX_inst_add_w;
reg IDEX_inst_addi_w;
reg IDEX_inst_ld_w;
reg IDEX_inst_st_w;
reg IDEX_inst_bne;
reg IDEX_inst_beq;
reg IDEX_inst_lu12i_w;
reg [4:0] IDEX_rk;
reg [4:0] IDEX_rj;
reg [4:0] IDEX_rd;
reg [15:0] IDEX_offs_16;
reg [31:0] IDEX_pc;
reg [31:0] IDEX_rf_rdata1;
reg [31:0] IDEX_rf_rdata2;
reg [31:0] IDEX_imm;
reg ctr_EX_alu_src1_sel;
reg ctr_EX_alu_src2_sel;
reg ctr_EX_alu_op;
reg ctr_MEM_data_sram_we;
reg ctr_WB_rf_we;
reg ctr_WB_wb_sel;

reg [31:0] EXMEM_inst;
reg EXMEM_inst_add_w;
reg EXMEM_inst_addi_w;
reg EXMEM_inst_ld_w;
reg EXMEM_inst_st_w;
reg EXMEM_inst_bne;
reg EXMEM_inst_beq;
reg EXMEM_inst_lu12i_w;
reg [4:0] EXMEM_rk;
reg [4:0] EXMEM_rj;
reg [4:0] EXMEM_rd;
reg [31:0] EXMEM_alu_result;
reg [31:0] EXMEM_rf_rdata2;
reg ctrm_MEM_data_sram_we;
reg ctrm_WB_rf_we;
reg ctrm_WB_wb_sel;

reg [31:0] MEMWB_inst;
reg MEMWB_inst_add_w;
reg MEMWB_inst_addi_w;
reg MEMWB_inst_ld_w;
reg MEMWB_inst_st_w;
reg MEMWB_inst_bne;
reg MEMWB_inst_beq;
reg MEMWB_inst_lu12i_w;
reg [4:0] MEMWB_rk;
reg [4:0] MEMWB_rj;
reg [4:0] MEMWB_rd;
reg [31:0] MEMWB_rf_rdata2;
reg [31:0] MEMWB_alu_result;
reg [31:0] MEMWB_data_sram_rdata;
reg ctrw_WB_rf_we;
reg ctrw_WB_wb_sel;

//流水线产生的控制信号
wire pc_we;
wire IFID_we;
wire IFID_cl;
wire IDEX_we;
wire IDEX_cl;

//forwarding unit
reg  [31:0] forward1;//转发合并后的信号
reg  [31:0] forward2;
reg  [1:0] forward1_sel;//00：不转发，01：转发EXMEM_alu_result，10：转发MEMWB_alu_result
reg  [1:0] forward2_sel;//00：不转发，01：转发EXMEM_alu_result，10：转发MEMWB_alu_result
wire forward1_en;
wire forward2_en;

//hazard detection unit
wire ld_hazard_rj_en;
wire ld_hazard_rk_en;
wire ld_hazard_rd_en;
wire br_hazard_en;
reg fStall;
reg dStall;
reg dFlush;
reg eFlush;

//debug端口赋值
assign npc = nextpc;
assign pc_out = pc;
assign ir = inst_sram_rdata;
assign pc_id = IFID_pc;
assign ir_id = IFID_inst;
assign pc_ex = IDEX_pc;
assign ir_ex = IDEX_inst;
assign rrd1 = rf_rdata1;
assign rrd2 = rf_raddr2;
assign imm_out = imm;
assign ir_mem = EXMEM_inst;
assign res = EXMEM_alu_result;
assign dwd = wb_data;
assign ir_wb = MEMWB_inst;
assign drd = data_sram_rdata;
assign res_wb = MEMWB_alu_result;
assign rwd = wb_data;

/*********************  IF  **********************/
assign inst_sram_we     = 1'b0;
assign inst_sram_addr   = pc[31:2];
assign inst_sram_wdata  = 32'b0;
//IFID_inst   <= inst_sram_rdata;已在IF/ID给出

always@(posedge clk) begin
    if(!rstn)begin
        pc <= 32'h1c000000;
    end
    else if(pc_we)begin
        pc <= nextpc;
    end
end

assign seqpc        = pc + 3'h4;
assign nextpc       = br_en ? br_target : seqpc;

//IF/ID
always@(posedge clk) begin
    if(IFID_cl)begin
        IFID_inst   <= 32'h00000000;
        IFID_pc     <= 32'h00000000;
    end else if(IFID_we)begin
        IFID_inst   <= inst_sram_rdata;
        IFID_pc     <= pc;
    end
end

/*********************  ID  **********************/
assign inst             = IFID_inst;
assign op_31_26 = inst[31:26];
assign op_25_22 = inst[25:22];
assign op_25_22 = inst[25:22];
assign op_21_20 = inst[21:20];
assign op_19_15 = inst[19:15];
assign rk       = inst[14:10];
assign rj       = inst[9:5];
assign rd       = inst[4:0];
assign si_12    = inst[21:10];
assign si_20    = inst[24:5];
assign offs_16  = inst[25:10];

decoder_6_64 u_dec0(.in(op_31_26),  .co(op_31_26_d));
decoder_4_16 u_dec1(.in(op_25_22),  .co(op_25_22_d));
decoder_2_4  u_dec2(.in(op_21_20),  .co(op_21_20_d));
decoder_5_32 u_dec3(.in(op_19_15),  .co(op_19_15_d));

assign inst_add_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00];
assign inst_addi_w  = op_31_26_d[6'h00] & op_25_22_d[4'ha];
assign inst_ld_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
assign inst_st_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h6];
assign inst_bne     = op_31_26_d[6'h17];
assign inst_beq     = op_31_26_d[6'h16];
assign inst_lu12i_w = op_31_26_d[6'h5];

//控制信号的生成
assign alu_src1_sel = inst_lu12i_w;//ALU源操作数1的选择逻辑，1时选择0，0时选择rf_rdata1
assign alu_src2_sel = inst_lu12i_w | inst_addi_w | inst_st_w | inst_ld_w;//ALU源操作数2的选择逻辑，1时选择imm，0时选择rf_rdata2
assign alu_op       = inst_add_w;//ALU操作数的生成逻辑，先暂时设置为加法，暂时用不上
assign data_sram_we = inst_st_w;
assign rf_we        = inst_add_w | inst_addi_w | inst_ld_w | inst_lu12i_w;
assign rf_raddr2_sel= inst_st_w | inst_bne | inst_beq;//值为1时，另一个寄存器为rd，否则为rk
assign imm_sel      = inst_lu12i_w;//值为1时，选择{si_20,12{0}}
assign wb_sel       = inst_ld_w;//值为1时，写回DR中的值; 值为0时，写回ALU_result
//assign br_type      = {inst_bne, inst_beq};//br_type生成逻辑，暂时等于inst_bne，暂时用不上

assign rf_raddr1    = rj;
assign rf_raddr2    = rf_raddr2_sel ? rd : rk;
regfile u_regfile(
    .clk    (clk            ),
    .rstn   (rstn           ),
    .raddr1 (rf_raddr1      ),
    .raddr2 (rf_raddr2      ),
    .rdata1 (rf_rdata1      ),
    .rdata2 (rf_rdata2      ),
    .we     (ctrw_WB_rf_we  ),
    .waddr  (MEMWB_rd       ),
    .wdata  (wb_data        )
    ,.rdata0(drd0           )
    ,.raddr0(dra0           )
);

assign si_12_to_32  = {{20{si_12[11]}},si_12[11:0]};
assign si_20_to_32  = {si_20[19:0],12'b0};
assign imm          = imm_sel ? si_20_to_32 : si_12_to_32;

//ID/EX
always@(posedge clk) begin
    if(!rstn || IDEX_cl)begin
        //data
        IDEX_inst           <= 32'h00000000;
        IDEX_pc             <= 32'h00000000;
        IDEX_inst_add_w     <= 1'b0;
        IDEX_inst_addi_w    <= 1'b0;
        IDEX_inst_ld_w      <= 1'b0;
        IDEX_inst_st_w      <= 1'b0;
        IDEX_inst_bne       <= 1'b0;
        IDEX_inst_beq       <= 1'b0;
        IDEX_inst_lu12i_w   <= 1'b0;
        IDEX_rk             <= 5'b00000;
        IDEX_rj             <= 5'b00000;
        IDEX_rd             <= 5'b00000;
        IDEX_offs_16        <= 16'h0000;
        IDEX_rf_rdata1      <= 32'h00000000;
        IDEX_rf_rdata2      <= 32'h00000000;
        IDEX_imm            <= 32'h00000000;
        //control signal
        ctr_EX_alu_src1_sel <= 0;
        ctr_EX_alu_src2_sel <= 0;
        ctr_EX_alu_op       <= 0;
        ctr_MEM_data_sram_we<= 0;
        ctr_WB_rf_we        <= 0;
        ctr_WB_wb_sel       <= 0;
    end else if(IDEX_we)begin
        //data
        IDEX_inst           <= IFID_inst;
        IDEX_pc             <= IFID_pc;
        IDEX_inst_add_w     <= inst_add_w;
        IDEX_inst_addi_w    <= inst_addi_w;
        IDEX_inst_ld_w      <= inst_ld_w;
        IDEX_inst_st_w      <= inst_st_w;
        IDEX_inst_bne       <= inst_bne;
        IDEX_inst_beq       <= inst_beq;
        IDEX_inst_lu12i_w   <= inst_lu12i_w;
        IDEX_rk             <= rk;
        IDEX_rj             <= rj;
        IDEX_rd             <= rd;
        IDEX_offs_16        <= offs_16;
        IDEX_rf_rdata1      <= rf_rdata1;
        IDEX_rf_rdata2      <= rf_rdata2;
        IDEX_imm            <= imm;
        //control signal
        ctr_EX_alu_src1_sel <= alu_src1_sel;
        ctr_EX_alu_src2_sel <= alu_src2_sel;
        ctr_EX_alu_op       <= alu_op;
        ctr_MEM_data_sram_we<= data_sram_we;
        ctr_WB_rf_we        <= rf_we;
        ctr_WB_wb_sel       <= wb_sel;
    end
end

/*********************  EX  **********************/
assign br_offs      = {IDEX_offs_16, 2'b0};
assign br_target    = IDEX_pc + br_offs;
assign rj_eq_rd     = (forward1 == forward2);
assign br_en        = valid && (IDEX_inst_bne && !rj_eq_rd
                             || IDEX_inst_beq && rj_eq_rd );

//forwarding unit
assign forward1_en = !EXMEM_inst_st_w & !EXMEM_inst_bne & !EXMEM_inst_beq;   //forward1管先指令(EX/MEM)的rd与后指令(ID/EX)的rj(读端口1)的冲突。
                                                            //对先指令，st和bne尽管含rd，但不写回寄存器；也可以用rf_we替代
                                                            //对后指令，所有指令（除了I26-type）几乎都含rj字段，暂且不管
assign forward2_en = (!EXMEM_inst_st_w & !EXMEM_inst_bne & !EXMEM_inst_beq) & (IDEX_inst_add_w | IDEX_inst_beq | IDEX_inst_bne);    //forward2管先指令(EX/MEM)的rd与后指令(ID/EX)的rk/rd(读端口2)的冲突。
                                                                                    //对先指令，st和bne尽管含rd，但不写回寄存器；
                                                                                    //对后指令，目前仅add.w含rk;仅beq和bne的rd会作操作数

always @(*) begin
    if ((EXMEM_rd == IDEX_rj) && forward1_en && EXMEM_rd)//EXMEM_rd == 0时，程序不规范，不允许前递
        forward1_sel <= 2'b01;
    else if((MEMWB_rd == IDEX_rj) && forward1_en && EXMEM_rd)
        forward1_sel <= 2'b10;
    else
        forward1_sel <= 2'b00;

    if ((EXMEM_rd == IDEX_rd || EXMEM_rd == IDEX_rk) && forward2_en && EXMEM_rd)
        forward2_sel <= 2'b01;
    else if((MEMWB_rd == IDEX_rd || MEMWB_rd == IDEX_rk) && forward2_en && MEMWB_rd)
        forward2_sel <= 2'b10;
    else
        forward2_sel <= 2'b00;

    case (forward1_sel)
        2'b00:
            forward1 <= IDEX_rf_rdata1;
        2'b01:
            forward1 <= EXMEM_alu_result;
        2'b10:
            forward1 <= wb_data;
        default: 
            forward1 <= IDEX_rf_rdata1;
    endcase


    case (forward2_sel)
        2'b00:
            forward2 = IDEX_rf_rdata2;
        2'b01:
            forward2 = EXMEM_alu_result;
        2'b10:
            forward2 = wb_data;
        default: 
            forward2 = IDEX_rf_rdata2;
    endcase
end

assign alu_src1     = ctr_EX_alu_src1_sel ? 32'h00000000 : forward1;
assign alu_src2     = ctr_EX_alu_src2_sel ? IDEX_imm : forward2;
assign alu_result   = alu_src1 + alu_src2;

//Hazard Detection Unit
assign ld_hazard_rj_en = EXMEM_inst_ld_w;
assign ld_hazard_rk_en = EXMEM_inst_ld_w & (IDEX_inst_add_w);
assign ld_hazard_rd_en = EXMEM_inst_ld_w & (IDEX_inst_beq | IDEX_inst_bne);

always @(*) begin
    if(ld_hazard_rj_en && (EXMEM_rd == IDEX_rj)
    || ld_hazard_rk_en && (EXMEM_rd == IDEX_rk)
    || ld_hazard_rd_en && (EXMEM_rd == IDEX_rd))begin
        fStall = 1;
        dStall = 1;
        eFlush = 1;
    end
    else begin
        fStall = 0;
        dStall = 0;
        eFlush = 0;
    end
end

assign br_hazard_en = br_en;

always @(*) begin
    if(br_hazard_en)begin
        dFlush = 1;
        eFlush = 1;
    end
    else begin
        dFlush = 0;
        eFlush = 0;
    end
end

assign pc_we = !fStall;
assign IFID_we = !dStall;
assign IFID_cl = dFlush;
assign IDEX_we = 1;
assign IDEX_cl = eFlush;

//EX/MEM
always@(posedge clk) begin
    if(!rstn)begin
        //data
        EXMEM_inst              <= 0;
        EXMEM_alu_result        <= 0;
        EXMEM_rf_rdata2         <= 0;
        EXMEM_inst_add_w        <= 0;
        EXMEM_inst_addi_w       <= 0;
        EXMEM_inst_ld_w         <= 0;
        EXMEM_inst_st_w         <= 0;
        EXMEM_inst_bne          <= 0;
        EXMEM_inst_beq          <= 0;
        EXMEM_inst_lu12i_w      <= 0;
        EXMEM_rk                <= 0;
        EXMEM_rj                <= 0;
        EXMEM_rd                <= 0;
        //control signal
        ctrm_MEM_data_sram_we   <= 0;
        ctrm_WB_rf_we           <= 0;
        ctrm_WB_wb_sel          <= 0;
    end else begin
        //data
        EXMEM_inst              <= IDEX_inst;
        EXMEM_alu_result        <= alu_result;
        EXMEM_rf_rdata2         <= IDEX_rf_rdata2;
        EXMEM_inst_add_w        <= IDEX_inst_add_w;
        EXMEM_inst_addi_w       <= IDEX_inst_addi_w;
        EXMEM_inst_ld_w         <= IDEX_inst_ld_w;
        EXMEM_inst_st_w         <= IDEX_inst_st_w;
        EXMEM_inst_bne          <= IDEX_inst_bne;
        EXMEM_inst_beq          <= IDEX_inst_beq;
        EXMEM_inst_lu12i_w      <= IDEX_inst_lu12i_w;
        EXMEM_rk                <= IDEX_rk;
        EXMEM_rj                <= IDEX_rj;
        EXMEM_rd                <= IDEX_rd;
        //control signal
        ctrm_MEM_data_sram_we   <= ctr_MEM_data_sram_we;
        ctrm_WB_rf_we           <= ctr_WB_rf_we;
        ctrm_WB_wb_sel          <= ctr_WB_wb_sel;
    end
end

/*********************  MEM  **********************/
assign data_sram_addr   = EXMEM_alu_result;
assign data_sram_wdata  = EXMEM_rf_rdata2;
assign data_sram_we_out = ctrm_MEM_data_sram_we;

//MEM/WB
always@(posedge clk) begin
    if(!rstn)begin
        //data
        MEMWB_inst              <= 0;
        MEMWB_data_sram_rdata   <= 0;
        MEMWB_alu_result        <= 0;
        MEMWB_inst_add_w        <= 0;
        MEMWB_inst_addi_w       <= 0;
        MEMWB_inst_ld_w         <= 0;
        MEMWB_inst_st_w         <= 0;
        MEMWB_inst_bne          <= 0;
        MEMWB_inst_beq          <= 0;
        MEMWB_inst_lu12i_w      <= 0;
        MEMWB_rk                <= 0;
        MEMWB_rj                <= 0;
        MEMWB_rd                <= 0;
        //control signal
        ctrw_WB_rf_we           <= 0;
        ctrw_WB_wb_sel          <= 0;
    end else begin
        //data
        MEMWB_inst              <= EXMEM_inst;
        MEMWB_data_sram_rdata   <= data_sram_rdata;
        MEMWB_alu_result        <= EXMEM_alu_result;
        MEMWB_inst_add_w        <= EXMEM_inst_add_w;
        MEMWB_inst_addi_w       <= EXMEM_inst_addi_w;
        MEMWB_inst_ld_w         <= EXMEM_inst_ld_w;
        MEMWB_inst_st_w         <= EXMEM_inst_st_w;
        MEMWB_inst_bne          <= EXMEM_inst_bne;
        MEMWB_inst_beq          <= EXMEM_inst_beq;
        MEMWB_inst_lu12i_w      <= EXMEM_inst_lu12i_w;
        MEMWB_rk                <= EXMEM_rk;
        MEMWB_rj                <= EXMEM_rj;
        MEMWB_rd                <= EXMEM_rd;
        //control signal
        ctrw_WB_rf_we           <= ctrm_WB_rf_we;
        ctrw_WB_wb_sel          <= ctrm_WB_wb_sel;
    end
end

/*********************  WB  **********************/
assign wb_data      = ctrw_WB_wb_sel ? MEMWB_data_sram_rdata : MEMWB_alu_result;

endmodule