module mycpu_C1_duo (
    input           clk,
    input           rstn,

//    output          inst_ram_we,
    output  [9:0]   inst_ram_addr,
//    output  [31:0]  inst_ram_wdata,
    input   [31:0]  inst_ram_rdata,

    output          data_ram_we,
    output  [9:0]   data_ram_addr,
    output  [31:0]  data_ram_wdata,
    input   [31:0]  data_ram_rdata,

    /************SDU接口************/
    output  [31:0]  npc,    //next_pc
    output reg [31:0]  pc,
    output reg [31:0]  IR,     //当前指令
    output  [31:0]  IMM,    //立即数
    output  [31:0]  CTL,    //控制信号，你可以将所有控制信号集成一根bus输出
    output  [31:0]  A,      //ALU的输入A
    output  [31:0]  B,      //ALU的输入B
    output  [31:0]  Y,      //ALU的输出
    output  [31:0]  MDR,    //数据存储器的输出

    input   [31:0]  addr,   
    output  [31:0]  dout_rf,
    output reg [2:0]   state
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

/**********PC和nextPC*********/
//reg     [31:0]      pc;     //PC
wire    [31:0]      nextpc; //nextPC

/**********指令译码过程的各信号*********/
wire    [31:0]      inst;   //指令
wire    [4:0]       rk;     //rk
wire    [4:0]       rj;     //rj
wire    [4:0]       rd;     //rd
wire    [11:0]      si_12;  //si_12
wire    [19:0]      si_20;  //si_20
wire    [15:0]      offs_16;//offs_16

wire    [5:0]       op_31_26;  //指令的31-26位
wire    [3:0]       op_25_22;  //指令的25-22位
wire    [1:0]       op_21_20;  //指令的21-20位
wire    [4:0]       op_19_15;  //指令的19-15位
wire    [63:0]      op_31_26_d;//将op_31_26译码为64位
wire    [16:0]      op_25_22_d;//将op_25_22译码为16位
wire    [4:0]       op_21_20_d;//将op_21_20译码为4位
wire    [32:0]      op_19_15_d;//将op_19_15译码为32位

wire                inst_add_w;     //add.w, 指令为add.w时，值为1
wire                inst_addi_w;    //addi.w
wire                inst_ld_w;      //ld.w
wire                inst_st_w;      //st.w
wire                inst_bne;       //bne
wire                inst_lu12i_w;   //lu12i.w

/******************控制信号*****************/
wire                alu_op;         //ALU操作码
wire                rf_we;          //寄存器堆的写使能信号
wire                rf_raddr2_sel;  //寄存器堆的读地址2选择信号
wire                imm_sel;        //立即数选择信号
wire                wb_sel;         //写回数据选择信号
wire                br_type;        //分支类型

/*************RF的读写信号****************/
wire    [4:0]       rf_raddr1;      //寄存器堆的读地址1
wire    [4:0]       rf_raddr2;      //寄存器堆的读地址2
wire    [31:0]      rf_rdata1;
wire    [31:0]      rf_rdata2;     

/*************BRANCH的信号****************/
wire    [31:0]      br_offs;        //分支偏移量（左移2位后）
wire    [31:0]      br_target;      
wire                rj_eq_rd;
wire                br_en;

/*************IMM的信号****************/
wire    [31:0]      si_12_to_32;  
wire    [31:0]      si_20_to_32;  
wire    [31:0]      imm;          

/*************ALU的信号****************/
wire    [31:0]      alu_src1;     
wire    [31:0]      alu_src2;       
wire    [31:0]      alu_result;   

/*************WB的信号****************/
wire    [31:0]      wb_data;

/*******多周期CPU状态机的状态定义*******/
//reg     [2:0]   state;
reg     [2:0]   next_state;
parameter IF    = 3'b000;
parameter ID    = 3'b001;
parameter EXE1  = 3'b010;
parameter WB1   = 3'b011;
parameter EXE2  = 3'b100;
parameter MEM2  = 3'b101;
parameter WB2   = 3'b110;
parameter EXE3  = 3'b111;

/*************多周期CPU添加的各寄存器************/
//IF后的寄存器
//reg     [31:0]      IR;//inst_reg
//ID后的寄存器
reg     [31:0]      rf_rdata1_reg;
reg     [31:0]      rf_rdata2_reg;
reg     [31:0]      imm_reg;
reg                 alu_src1_sel_reg;
reg                 alu_src2_sel_reg;
reg                 alu_op_reg;
reg                 data_ram_we_reg;
reg                 rf_we_reg;
reg     [31:0]      rd_reg;
reg                 wb_sel_reg;
reg                 br_type_reg;
//EXE后的寄存器
reg     [31:0]      alu_result_reg;
reg                 br_en_reg;
reg                 br_target_reg;
//MEM后的寄存器
reg     [31:0]      data_ram_rdata_reg;
//新增PC_we和IR_we
reg                 pc_we;
reg                 IR_we;

/********************SDU接口*******************/
assign npc = nextpc;
assign IMM = imm;
assign CTL = {alu_src1_sel,alu_src2_sel,alu_op,data_ram_we,rf_we,rf_raddr2_sel,imm_sel,wb_sel,br_type};
assign A = alu_src1;
assign B = alu_src2;
assign Y = alu_result;
assign MDR = data_ram_rdata;

assign dout_rf = rf_rdata1_reg;

/*************PC和IR的写入逻辑************/
//PC_we的生成逻辑
always @(negedge clk) begin
    if(next_state == IF)begin
        pc_we <= 1'b1;
    end
    else begin
        pc_we <= 1'b0;
    end
end

//IR_we的生成逻辑
always@(*)begin
    case(state)
        IF: begin
            IR_we = 1'b1;
        end
        default: begin
            IR_we = 1'b0;
        end
    endcase
end

//PC的写入逻辑
always@(posedge clk) begin
    if(!rstn)begin
        pc <= 32'h1c000000;
    end
    else begin
        if(pc_we)begin
            pc <= nextpc;
        end
    end
end

//IR的写入逻辑
always@(negedge clk) begin
    if(IR_we)begin
        IR <= inst_ram_rdata;
    end
end

/************************多周期CPU添加的各寄存器的写入逻辑**************************/
//注意：这里的各寄存器不需要写使能信号，其作用是切分数据通路，将大组合逻辑切分为若干个小组合逻辑，大延迟变为多个分段小延迟
//***又有文档说：“资料写了‘中间寄存器一律不需要写使能，起到把大延迟分割为小延迟的作用’，
//***“但是我本人认为单纯实现多周期CPU本身根本就没有中间寄存器的添加必要，只要IR寄存器内的值不变，数据通路上的中间值在计算稳定后就不会波动，并不需要加入时序寄存器来保存”
//指令执行的结果总是在时钟下降沿保存到寄存器和存储器中，PC的改变是在时钟上升沿进行的，这样稳定性较好
//也就是说，除PC外，各寄存器都在时钟下降沿写入，这样能保证下一周期有写入操作时，能够读到上一周期的结果（可能是数据，也可能是控制信号）
always@(negedge clk)begin
    rf_rdata1_reg       <= rf_rdata1;
    rf_rdata2_reg       <= rf_rdata2;
    imm_reg             <= imm;
    alu_src1_sel_reg    <= alu_src1_sel;
    alu_src2_sel_reg    <= alu_src2_sel;
    alu_op_reg          <= alu_op;
    data_ram_we_reg     <= data_ram_we;
    rf_we_reg           <= rf_we;
    rd_reg              <= rd;
    wb_sel_reg          <= wb_sel;
    br_type_reg         <= br_type;
    alu_result_reg      <= alu_result;
    br_en_reg           <= br_en;
    br_target_reg       <= br_target;
    data_ram_rdata_reg  <= data_ram_rdata;
end

/*********************多周期CPU添加的状态机************************/
//状态机的状态寄存器
always@(posedge clk) begin
    if(!rstn)begin
        state <= IF;
    end
    else begin
        state <= next_state;
    end
end

//状态机的状态转移逻辑
always@(*) begin
    case(state)
        IF: begin
            next_state = ID;
        end
        ID: begin
            if(inst_add_w | inst_addi_w | inst_lu12i_w)begin
                next_state = EXE1;
            end
            else if(inst_st_w | inst_ld_w)begin
                next_state = EXE2;
            end
            else begin//if(inst_bne)
                next_state = EXE3;
            end
        end
        EXE1: begin
            next_state = WB1;
        end
        WB1: begin
            next_state = IF;
        end
        EXE2: begin
            next_state = MEM2;
        end
        MEM2: begin
            if(inst_st_w)begin
                next_state = IF;
            end
            else begin//if(inst_ld_w)
                next_state = WB2;
            end
        end
        WB2: begin
            next_state = IF;
        end
        EXE3: begin
            next_state = IF;
        end
        default: begin
            next_state = IF;
        end
    endcase
end

//指令存储器相关数据
//assign inst_ram_we     = 1'b1;
assign inst_ram_addr   = pc;
//assign inst_ram_wdata  = 32'b0;
assign inst             = inst_ram_rdata;

//数据存储器相关数据
assign data_ram_addr   = alu_result_reg;
assign data_ram_wdata  = rf_rdata2_reg;

/******************************指令译码************************************/
//截取指令的各个字段
assign op_31_26 = IR[31:26];
assign op_25_22 = IR[25:22];
assign op_21_20 = IR[21:20];
assign op_19_15 = IR[19:15];
assign rk       = IR[14:10];
assign rj       = IR[9:5];
assign rd       = IR[4:0];
assign si_12    = IR[21:10];
assign si_20    = IR[24:5];
assign offs_16  = IR[25:10];

//各个字段的译码
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
assign alu_src1_sel = inst_lu12i_w;
assign alu_src2_sel = inst_lu12i_w | inst_addi_w | inst_st_w | inst_ld_w;
assign data_ram_we  = inst_st_w;
assign rf_we        = inst_add_w | inst_addi_w | inst_ld_w;
assign rf_raddr2_sel= inst_st_w | inst_bne;     //值为1时，另一个寄存器为rd，否则为rk
assign imm_sel      = inst_lu12i_w;             //值为1时，选择{si_20,12{0}}
assign wb_sel       = inst_ld_w;                //值为1时，写回DR中的值; 值为0时，写回ALU_result
assign br_type      = inst_bne;                 //br_type生成逻辑，暂时等于inst_bne，暂时用不上

//RF
assign rf_raddr1    = (state == MEM2) ? rj : addr[4:0];//注意
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

//ALU
assign alu_src1     = alu_src1_sel_reg ? 32'h00000000 : rf_rdata1;
assign alu_src2     = alu_src2_sel_reg ? imm : rf_rdata2;
assign alu_op       = inst_add_w;               //ALU操作数的生成逻辑，先暂时设置为加法，暂时用不上
assign alu_result   = alu_src1 + alu_src2;

//BRANCH
assign br_offs      = {14'b0, offs_16, 2'b0};
assign br_target    = pc + br_offs;
assign rj_eq_rd     = (rf_rdata1_reg == rf_rdata2_reg);
assign br_en        = inst_bne && !rj_eq_rd;

//nextpc
assign nextpc       = br_en_reg ? br_target_reg : (pc + 4);

//IMM
assign si_12_to_32  = {{20{si_12[11]}},si_12[11:0]};
assign si_20_to_32  = {si_20[19:0],12'b0};
assign imm          = imm_sel ? si_20_to_32 : si_12_to_32;

//WB
assign wb_data      = wb_sel_reg ? data_ram_rdata : alu_result;

endmodule