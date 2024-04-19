`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/21 18:06:09
// Design Name: 
// Module Name: mycpu_C1_top
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


module mycpu_C1_duo_top(
    input           clk,
    input           rstn,

    output  [31:0]  npc,    //next_pc
    output  [31:0]  pc,
    output  [31:0]  pc_chk,     
    output  [31:0]  IR,     //当前指令
    output  [31:0]  IMM,    //立即数
    output  [31:0]  CTL,    //控制信号，你可以将所有控制信号集成一根bus输出
    output  [31:0]  A,      //ALU的输入A
    output  [31:0]  B,      //ALU的输入B
    output  [31:0]  Y,      //ALU的输出
    output  [31:0]  MDR,    //数据存储器的输出
    /************SDU接口************/
    input   [31:0]  addr,   
    output  [31:0]  dout_rf,
    output  [31:0]  dout_dm,
    output  [31:0]  dout_im,
    input   [31:0]  din,
    input           we_dm,
    input           we_im,
    input           clk_ld,
    input           debug
);
    reg clk_mem;
    always @(*) begin
        clk_mem = debug ? clk : clk_ld;
    end

    wire inst_ram_we;
    wire [9:0]   inst_ram_addr;
    wire [9:0]   inst_ram_addr_final;
    wire [31:0]  inst_ram_wdata;
    wire [31:0]  inst_ram_rdata;

    wire         data_ram_we;           //CPU给出的DR写使能
    wire         dr_we_final;           //最终的DR写使能（考虑SDU）
    wire [9:0]   data_ram_addr;         //CPU给出的DR读地址
    wire [9:0]   data_ram_addr_final;   //最终的DR地址（考虑SDU）
    wire [31:0]  data_ram_wdata;        //CPU给出的DR写数据
    wire [31:0]  data_ram_wdata_final;  //最终的DR写数据（考虑SDU）
    wire [31:0]  data_ram_rdata;

    reg [2:0]   state;

    assign inst_ram_we = we_im;         //IM只由SDU写
    assign inst_ram_addr_final = (state == 3'b000) ? inst_ram_addr : addr[9:0];//只有在状态为IF（000）时，才会从CPU读取地址
    assign inst_ram_wdata = din;
    assign dout_im = inst_ram_rdata;
    
    assign dr_we_final = we_dm | data_ram_we;   //数据存储器的写使能由CPU和SDU共同决定
    assign data_ram_addr_final = (state == 3'b101) ? data_ram_addr : addr[9:0]; //只有在状态为MEM（101）时，才会从CPU读取地址
    assign data_ram_wdata_final = (state == 3'b101) ? data_ram_wdata : din;     //只有在状态为MEM（101）时，才会从CPU读取写数据
    assign dout_dm = data_ram_rdata;

    assign pc_chk = pc;
mycpu_C1_duo cpu_duo(
    .clk(clk),
    .rstn(rstn),

//    .inst_ram_we(inst_ram_we),
    .inst_ram_addr(inst_ram_addr),
//    .inst_ram_wdata(inst_ram_wdata),
    .inst_ram_rdata(inst_ram_rdata),

    .data_ram_we(data_ram_we),
    .data_ram_addr(data_ram_addr),
    .data_ram_wdata(data_ram_wdata),
    .data_ram_rdata(data_ram_rdata),

    .npc(npc),    //next_pc
    .pc(pc),
    .IR,     //当前指令
    .IMM(IMM),    //立即数
    .CTL(CTL),    //控制信号，你可以将所有控制信号集成一根bus输出
    .A(A),      //ALU的输入A
    .B(B),      //ALU的输入B
    .Y(Y),      //ALU的输出
    .MDR(MDR),    //数据存储器的输出

    .addr(addr),   
    .dout_rf(dout_rf),
    .state(state)
);

data_ram data_ram(
    .clk(clk_mem),
    .we(dr_we_final),//注意
    .a(data_ram_addr_final),//注意
    .d(data_ram_wdata_final),
    .spo(data_ram_rdata)
);

inst_ram inst_ram(
    .clk(clk_mem),
    .we(inst_ram_we),
    .a(inst_ram_addr_final),
    .d(inst_ram_wdata),
    .spo(inst_ram_rdata)
);
endmodule
