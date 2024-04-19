`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 17:53:56
// Design Name: 
// Module Name: Moore_2_seq
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


module Moore_2_seq(
    input in,
    input clk,
    input rstn,
    output reg out,
    output reg [4:0] cs
    );
    
reg [4:0] ns;

parameter S0 = 5'h0;
parameter S1 = 5'h1;
parameter S2 = 5'h2;
parameter S3 = 5'h3;
parameter S4 = 5'h4;
parameter S5 = 5'h5;
parameter S6 = 5'h6;
parameter S7 = 5'h7;
parameter S8 = 5'h8;

always @(posedge clk, negedge rstn) begin
    if (!rstn) cs <= S0;
    else cs <= ns;
end

always_comb begin
    out = 0;
    ns = cs;
    case(cs)
        S0:begin
            out = 0;
            if (in == 0)begin
                ns = S0;
            end
            else begin
                ns = S1;
            end
        end
        S1:begin
            out = 0;
            if (in == 0) begin
                ns = S2;
            end
            else begin
                ns = S1;
            end
        end
        S2:begin
            out = 0;
            if (in == 0) begin
                ns = S0;
            end
            else begin
                ns = S3;
            end
        end
        S3:begin
            out = 0;
            if (in == 0) begin
                ns = S4;
            end
            else begin
                ns = S1;
            end
        end
        S4:begin
            out = 0;
            if (in == 0) begin
                ns = S0;
            end
            else begin
                ns = S5;
            end
        end
        S5:begin
            out = 0;
            if (in == 0) begin
                ns = S6;
            end
            else begin
                ns = S1;
            end
        end
        S6:begin
            out = 0;
            if (in == 0) begin
                ns = S0;
            end
            else begin
                ns = S7;
            end
        end
        S7:begin
            out = 0;
            if (in == 0) begin
                ns = S6;
            end
            else begin
                ns = S8;
            end
        end
        S8:begin
            out = 1;
            if (in == 0) begin
                ns = S0;
            end
            else begin
                ns = S1;
            end
        end
        default;
    endcase
end

endmodule
