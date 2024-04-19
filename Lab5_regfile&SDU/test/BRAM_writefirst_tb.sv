`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 10:03:10
// Design Name: 
// Module Name: BRAM_writefirst_tb
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


module BRAM_writefirst_tb(

    );
    
    reg clka;
    reg wea;
    reg [5:0] addra, addrb;
    reg [63:0] dina;
    wire [63:0] doutb;

    dual_port_1_clock_bram_write_first #(
        .RAM_WIDTH(64),
        .RAM_DEPTH(64)
    ) u_bram (
        .addra(addra),
        .addrb(addrb),
        .dina(dina),
        .clka(clka),
        .wea(wea),
        .doutb(doutb)
    );

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
            wea = 0;
            #5;
        end
        addra = 0;
        addrb = 0;
        #5;
        for (addrb = 0; addrb < 64; addrb = addrb + 1) begin
            #5;
        end
    end

endmodule
