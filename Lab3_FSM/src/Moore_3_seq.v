`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 17:53:56
// Design Name: 
// Module Name: Moore_3_seq
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


module Moore_3_seq(
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

always @* begin
    ns = cs;
    case(cs)
        S0:begin
            if (in == 0)
                ns = S0;
            else
                ns = S1;
        end
        S1:begin
            if (in == 0)
                ns = S2;
            else
                ns = S1;
        end
        S2:begin
            if (in == 0)
                ns = S0;
            else
                ns = S3;
        end
        S3:begin
            if (in == 0)
                ns = S4;
            else
                ns = S1;
        end
        S4:begin
            if (in == 0)
                ns = S0;
            else
                ns = S5;
        end
        S5:begin
            if (in == 0)
                ns = S6;
            else
                ns = S1;
        end
        S6:begin
            if (in == 0)
                ns = S0;
            else
                ns = S7;
        end
        S7:begin
            if (in == 0)
                ns = S6;
            else
                ns = S8;
        end
        S8:begin
            if (in == 0)
                ns = S0;
            else
                ns = S1;
        end
        default;
    endcase
end

always @(posedge clk, negedge rstn) begin
    if(!rstn)
        out <= 0;
    else begin
        case(ns)
            S0: out <= 0;
            S1: out <= 0;
            S2: out <= 0;
            S3: out <= 0;
            S4: out <= 0;
            S5: out <= 0;
            S6: out <= 0;
            S7: out <= 0;
            S8: out <= 1;
            default;
        endcase
    end
end

endmodule
