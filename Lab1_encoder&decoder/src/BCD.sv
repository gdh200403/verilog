`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 07:06:35 AM
// Design Name: 
// Module Name: decoder4_10
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


module decoder4_10(
    input logic [3:0]     d,
    output logic [9:0]    y
    );
    always_comb begin
        case(d)
            4'b0000: y = 10'b0000000001;
            4'b0001: y = 10'b0000000010;
            4'b0010: y = 10'b0000000100;
            4'b0011: y = 10'b0000001000;
            4'b0100: y = 10'b0000010000;
            4'b0101: y = 10'b0000100000;
            4'b0110: y = 10'b0001000000;
            4'b0111: y = 10'b0010000000;
            4'b1000: y = 10'b0100000000;
            4'b1001: y = 10'b1000000000;
            default: y = 10'b0000000000;
        endcase
    end
endmodule
