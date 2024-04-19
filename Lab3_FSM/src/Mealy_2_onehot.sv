`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 17:53:56
// Design Name: 
// Module Name: Mealy_2_onehot
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


module Mealy_2_onehot(
    input in,
    input clk,
    input rstn,
    output reg out,
    output reg [7:0] cs
);

reg [7:0] ns;

parameter S0 = 8'b0000_0001;
parameter S1 = 8'b0000_0010;
parameter S2 = 8'b0000_0100;
parameter S3 = 8'b0000_1000;
parameter S4 = 8'b0001_0000;
parameter S5 = 8'b0010_0000;
parameter S6 = 8'b0100_0000;
parameter S7 = 8'b1000_0000;

always @(posedge clk, negedge rstn) begin
    if (!rstn) cs <= S0;
    else cs <= ns;
end

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
