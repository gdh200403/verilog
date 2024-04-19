`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 09:34:33 AM
// Design Name: 
// Module Name: CODER
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


module CODER(
    input logic         e,
    input logic         t,
    input logic [9:0]   a,
    input logic [3:0]   b,
    output logic        f,
    output logic [3:0]  d,
    output logic [9:0]  y,
    output logic [6:0]  cn,
    output logic        dp,
    output logic [7:0]  an
    );
    logic f_ECD;
    logic [3:0] y_ECD, y_MUX;
    encoder10_4 ECD(
        .e(e),
        .t(t),
        .a(a),
        .f(f_ECD),
        .y(y_ECD)
    );
    MUX MUX(
        .s(f_ECD),
        .b(y_ECD),
        .a(b),
        .y(y_MUX)
    );
    decoder4_10 BCD(
        .d(y_MUX),
        .y(y)
    );
    seven_seg_decoder SSD(
        .d(y_MUX),
        .yn(cn)
    );
    always_comb begin
        d = y_ECD;
        f = f_ECD;
        dp = 1'b1;
        an = 8'b1111_1110;
    end
endmodule
