`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 13:46:05
// Design Name: 
// Module Name: mycpu_top
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


module mycpu_C1_top(
    input clk,
    input rstn

//Ports For Debug
    ,input  [31:0] dra0
    ,output [31:0] drd0
    ,input  [4:0]  rra0
    ,output [31:0] rrd0
    //,output ctr_debug
    ,output [31:0] npc
    ,output [31:0] pc
    ,output [31:0] ir
    ,output [31:0] pc_id
    ,output [31:0] ir_id
    ,output [31:0] pc_ex
    ,output [31:0] ir_ex
    ,output [31:0] rrd1
    ,output [31:0] rrd2
    ,output [31:0] imm
    ,output [31:0] ir_mem
    ,output [31:0] res
    ,output [31:0] dwd
    ,output [31:0] ir_wb
    ,output [31:0] drd
    ,output [31:0] res_wb
    ,output [31:0] rwd   
    );

    wire            inst_sram_we;
    wire [31:0]      inst_sram_addr;
    wire [31:0]     inst_sram_wdata;
    wire [31:0]     inst_sram_rdata;
    wire            data_sram_we;
    wire [31:0]      data_sram_addr;
    wire [31:0]     data_sram_wdata;
    wire [31:0]     data_sram_rdata;

    assign dwd = data_sram_wdata;
    assign drd = data_sram_rdata;

mycpu_C1 cpu(
    .clk(clk),
    .rstn(rstn),

    .inst_sram_we(inst_sram_we),
    .inst_sram_addr(inst_sram_addr),
    .inst_sram_wdata(inst_sram_wdata),
    .inst_sram_rdata(inst_sram_rdata),

    .data_sram_we_out(data_sram_we),
    .data_sram_addr(data_sram_addr),
    .data_sram_wdata(data_sram_wdata),
    .data_sram_rdata(data_sram_rdata)
    // .data_sram_wdata(dwd),
    // .data_sram_rdata(drd)

,.rra0(rra0)
,.rrd0(rrd0)
,.npc(npc)
,.pc_out(pc)
,.ir(ir)
,.pc_id(pc_id)
,.ir_id(ir_id)
,.pc_ex(pc_ex)
,.ir_ex(ir_ex)
,.rrd1(rrd1)
,.rrd2(rrd2)
,.imm_out(imm)
,.ir_mem(ir_mem)
,.res(res)
,.ir_wb(ir_wb)
,.res_wb(res_wb)
,.rwd(rwd)
);

// sram data_sram(
//     // .clk(clk),
//     .we(data_sram_we),
//     .addr(data_sram_addr),
//     .wdata(data_sram_wdata),
//     .rdata(data_sram_rdata)

// //debug
//     ,.addr0(dra0)
//     ,.rdata0(drd0)
// );

// sram inst_sram(
//     // .clk(clk),
//     .we(inst_sram_we),
//     .addr(inst_sram_addr),
//     .wdata(inst_sram_wdata),
//     .rdata(inst_sram_rdata)
// );

ram_0 data_ram(
    .clk(clk),
    .we(data_sram_we),
    .a(data_sram_addr),
    .d(data_sram_wdata),
    .spo(data_sram_rdata)

//debug
    ,.dpra(dra0)
    ,.dpo(drd0)
);

ram_1 inst_ram(
    .clk(clk),
    .we(inst_sram_we),
    .a(inst_sram_addr),
    .d(inst_sram_wdata),
    .spo(inst_sram_rdata)
);
endmodule
