`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 09:16:48
// Design Name: 
// Module Name: BRAM_1
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


module BRAM_1(
    input [5:0] addra,
    input [5:0] addrb,
    input [15:0] dina,
    input [15:0] dinb,
    input clka,
    input clkb,
    input ena,
    input enb,
    input wea,
    input web,
    output [15:0] douta,
    output [15:0] doutb
    );

    BRAM bram_inst(
        .addra(addra),
        .addrb(addrb),
        .dina(dina),
        .dinb(dinb),
        .clka(clka),
        .clkb(clkb),
        .ena(ena),
        .enb(enb),
        .wea(wea),
        .web(web),
        .douta(douta),
        .doutb(doutb)
    );
endmodule
