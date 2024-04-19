`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 09:03:26
// Design Name: 
// Module Name: DRAM_1
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


module DRAM_1(
    input  [5:0] a,
    input  [15:0] d,
    input  [5:0] dpra,
    input  clk,
    input  we,
    output reg  [15:0] spo,
    output reg  [15:0] dpo
    );

DRAM dram_inst(
    .a          (a),
    .d          (d),
    .dpra       (dpra),
    .clk        (clk),
    .we         (we),
    .spo        (spo),
    .dpo        (dpo)
);

endmodule
