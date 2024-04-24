`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 21:53:56
// Design Name: 
// Module Name: cpu_tb
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

module mycpu_top_try_tb;
    reg clk;
    reg rstn;
    reg [31:0] dra0;
    wire [31:0] drd0;
    reg [4:0] rra0;
    wire [31:0] rrd0;

    // 产生时钟信号
    always begin
        #1 clk = ~clk;
    end

    // 初始化
    initial begin
        clk = 0;
        rstn = 0;
        dra0 = 0;
        rra0 = 0;
        #5 rstn = 1;
        #80000 $finish;  // 运行100ns后结束仿真
    end

    // 实例化被测模块
    mycpu_top_try uut (
        .clk(clk),
        .rstn(rstn),
        .dra0(dra0),
        .drd0(drd0),
        .rra0(rra0),
        .rrd0(rrd0)
    );

endmodule
