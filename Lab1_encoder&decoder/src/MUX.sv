`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 07:06:35 AM
// Design Name: 
// Module Name: MUX
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


module MUX(
    input logic         s,
    input logic [3:0]   b,
    input logic [3:0]   a,
    output logic [3:0]  y
    );
    always_comb begin
        if(s)begin
            y = b;
        end
        else begin
            y = a;
        end
    end
endmodule
