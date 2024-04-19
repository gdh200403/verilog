`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 08:54:16
// Design Name: 
// Module Name: CSA
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


module adder (
    input   Add_A,
    input   Add_B,
    input   Add_Cin,
    output  Cout,
    output  Sum
 );
 
 assign Cout     = (Add_A & Add_B) | (Add_Cin & (Add_A | Add_B));
 assign Sum      = Add_A ^ Add_B ^ Add_Cin;
 // assign {Cout, Sum} = Add_A + Add_B + Add_Cin;
 endmodule
 
