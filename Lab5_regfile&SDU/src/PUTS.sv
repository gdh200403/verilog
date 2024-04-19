`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 16:14:58
// Design Name: 
// Module Name: PUTS
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


module PUTS(
    input [31:0] din,
    input we,
    input rdy_tx,
    output reg vld_tx,
    output reg [7:0] d_tx,
    );
    reg [4:0] cnt;
    
endmodule
