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


module mycpu_C1_top(
    input clk,
    input rstn,

    output inst_ram_we,
    output [9:0]   inst_ram_addr,
    output [31:0]  inst_ram_wdata,
    output [31:0]  inst_ram_rdata,
    output         data_ram_we,
    output [9:0]   data_ram_addr,
    output [31:0]  data_ram_wdata,
    output [31:0]  data_ram_rdata

    // output    [4:0]       rd,
    // output    [31:0] wb_data,
    // output    [31:0]      nextpc,
    // output reg    [31:0]      pc,
    // output    [31:0]      inst,
    // output    [4:0] rf_raddr1,
    // output    [4:0] rf_raddr2, 
    // output    [31:0] alu_result
    );

    wire inst_ram_we;
    wire [9:0]   inst_ram_addr;
    wire [31:0]  inst_ram_wdata;
    wire [31:0]  inst_ram_rdata;
    wire         data_ram_we;
    wire [9:0]   data_ram_addr;
    wire [31:0]  data_ram_wdata;
    wire [31:0]  data_ram_rdata;

mycpu_C1 cpu(
    .clk(clk),
    .rstn(rstn),

    .inst_ram_we(inst_ram_we),
    .inst_ram_addr(inst_ram_addr),
    .inst_ram_wdata(inst_ram_wdata),
    .inst_ram_rdata(inst_ram_rdata),

    .data_ram_we(data_ram_we),
    .data_ram_addr(data_ram_addr),
    .data_ram_wdata(data_ram_wdata),
    .data_ram_rdata(data_ram_rdata)

    // .rd(rd),
    // .wb_data(wb_data),
    // .nextpc(nextpc),
    // .pc(pc),
    // .inst(inst),
    // .rf_raddr1(rf_raddr1),
    // .rf_raddr2(rf_raddr2),   
    // .alu_result(alu_result) 
);

data_ram data_ram(
    .clk(clk),
    .we(data_ram_we),
    .a(data_ram_addr),
    .d(data_ram_wdata),
    .spo(data_ram_rdata)
);

inst_ram inst_ram(
    .clk(clk),
    .we(inst_ram_we),
    .a(inst_ram_addr),
    .d(inst_ram_wdata),
    .spo(inst_ram_rdata)
);
endmodule
