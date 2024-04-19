`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 11:24:32
// Design Name: 
// Module Name: RIF_tb
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


module RIF_tb(

);
    reg             clk;
    reg             rxd;
    reg             rx_rdy;
    wire            rx_vld;
    wire    [7:0]   dout;

    RIF RIF0(
    .clk(clk),
    .rxd(rxd),
    .rx_rdy(rx_rdy),
    .rx_vld(rx_vld),
    .dout(dout)
    );

    initial begin
        clk=0;
        forever  #1 clk=~clk;
    end

    initial begin
        #32 rxd=0;// start bit
        #32 rxd=1;
        #32 rxd=0;
        #32 rxd=1;
        #32 rxd=0;
        #32 rxd=0;
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=0;
        #32 rxd=1;// stop bit

        #32 rxd=0;// start bit just after stop bit
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=1;
        #32 rxd=0;// invalid stop bit

    end
endmodule