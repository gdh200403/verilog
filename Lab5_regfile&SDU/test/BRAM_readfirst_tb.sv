`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 09:42:30
// Design Name: 
// Module Name: BRAM_readfirst_tb
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


module BRAM_readfirst_tb(

    );//首先将所有的BRAM地址写入与地址相同的值，然后读取所有的地址，并将结果输出到doutb。
    reg clka;
    reg wea;
    reg [5:0] addra, addrb;
    reg [63:0] dina;
    reg [63:0] doutb;

    initial begin
        clka = 0;
        wea = 0;
        addra = 0;
        addrb = 0;
        dina = 0;
        forever #5 clka = ~clka;
    end

    initial begin
        #5;
        for (addra = 0; addra < 64; addra = addra + 1) begin
            wea = 1;
            dina = addra + 1;
            #5;
        end
        addra = 0;
        addrb = 0;
        #5;
        for (addrb = 0; addrb < 64; addrb = addrb + 1) begin
            #5;
        end
    end

    always @(*) begin
        if(dina >= 2)begin
            doutb = 1;
        end
    end

endmodule
