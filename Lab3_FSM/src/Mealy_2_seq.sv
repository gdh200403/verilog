`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 17:53:56
// Design Name: 
// Module Name: Mealy_2_seq
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


module Mealy_2_seq(
    input in,
    input clk,
    input rstn,
    output reg out,
    output reg [3:0] cs
    );

reg [3:0] ns;

//状态定义
parameter S0 = 4'o0;
parameter S1 = 4'o1;
parameter S2 = 4'o2;
parameter S3 = 4'o3;
parameter S4 = 4'o4;
parameter S5 = 4'o5;
parameter S6 = 4'o6;
parameter S7 = 4'o7;

//状态更新
always @(posedge clk, negedge rstn) begin
    if (!rstn) cs <= S0;
    else cs <= ns;
end

//状态转移
always_comb begin
    out = 0;
    ns = cs;
    case(cs)
        S0:begin
            if (in == 0) begin
                out = 0;
                ns = S0;
            end
            else begin
                out = 0;
                ns = S1;
            end
        end
        S1:begin
            if (in == 0) begin
                out = 0;
                ns = S2;
            end
            else begin
                out = 0;
                ns = S1;
            end
        end
        S2:begin
            if (in == 0) begin
                out = 0;
                ns = S0;
            end
            else begin
                out = 0;
                ns = S3;
            end
        end
        S3:begin
            if (in == 0) begin
                out = 0;
                ns = S4;
            end
            else begin
                out = 0;
                ns = S1;
            end
        end
        S4:begin
            if (in == 0) begin
                out = 0;
                ns = S0;
            end
            else begin
                out = 0;
                ns = S5;
            end
        end
        S5:begin
            if (in == 0) begin
                out = 0;
                ns = S6;
            end
            else begin
                out = 0;
                ns = S1;
            end
        end
        S6:begin
            if (in == 0) begin
                out = 0;
                ns = S0;
            end
            else begin
                out = 0;
                ns = S7;
            end
        end
        S7:begin
            if (in == 0) begin
                out = 0;
                ns = S6;
            end
            else begin
                out = 1;
                ns = S0;
            end
        end
        default;
    endcase
end

endmodule
