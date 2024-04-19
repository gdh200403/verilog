`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 11:14:23
// Design Name: 
// Module Name: Mux
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


module mux 
# (
    parameter                   WIDTH = 8
)(
    input [WIDTH-1: 0]          a, b,
    input                       s,
    output reg [WIDTH-1: 0]     y
); 
always @(*) begin
    if (s)
        y = b;
    else
        y = a;
end
endmodule
