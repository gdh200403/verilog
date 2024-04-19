`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 07:06:35 AM
// Design Name: 
// Module Name: encoder10_4
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


module encoder10_4(
    input logic         e,//enable
    input logic         t,//type 0-putong 1-youxian
    input logic [9:0]   a,//input
    output logic        f,//if the output works
    output logic [3:0]  y//BCD code
    );
    logic [3:0] sum;
    
    always_comb begin
        if(e)begin
            if(a[9]) y = 4'b1001;
            else if(a[8]) y = 4'b1000;
            else if(a[7]) y = 4'b0111;
            else if(a[6]) y = 4'b0110;
            else if(a[5]) y = 4'b0101;
            else if(a[4]) y = 4'b0100;
            else if(a[3]) y = 4'b0011;
            else if(a[2]) y = 4'b0010;
            else if(a[1]) y = 4'b0001;
            else  y = 4'b0000;
            if(t)begin
                if(a) f = 1;
                else f = 0;
            end
            else begin
                sum = a[0] + a[1] +  a[2] +  a[3] + a[4] + a[5] + a[6] + a[7] + a[8] + a[9];
                if (sum  == 1) f =1;
                else f = 0;
            end
        end
        else begin
            y = 4'b0000;
            f = 0;
        end
    end
endmodule
