`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 08:04:28
// Design Name: 
// Module Name: ALU
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


module ALU(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [11:0] op,
    output reg [31:0] out
    );

    always_comb begin
        case(op)
            12'b000000000001: out = a + b;
            12'b000000000010: out = a - b;
            12'b000000000100: //有符号数的小于比较
                begin
                    if(a[31] == 1 && b[31] == 0) begin
                        out = 1'b1;
                    end
                    else if(a[31] == 0 && b[31] == 1) begin
                        out = 1'b0;
                    end
                    else begin
                        out = a < b;
                    end
                end
            12'b000000001000: out = a < b;
            12'b000000010000: out = ~(a | b);
            12'b000000100000: out = a & b;
            12'b000001000000: out = a | b;
            12'b000010000000: out = a ^ b;
            12'b000100000000: out = a << b[4:0];
            12'b001000000000: out = a >> b[4:0];
            12'b010000000000: out = a >>> b[4:0];
            12'b100000000000: out = b;
            default: out = 0;
        endcase
    end

endmodule
