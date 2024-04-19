`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 17:56:24
// Design Name: 
// Module Name: top_TFD_tb
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


module top_TFD_testbench;
    reg clk;
    reg rstn;
    reg [15:0] sw;
    reg st;
    reg ent;
    reg del;
    reg pre;
    reg nxt;
    wire [15:0] taddr;
    wire [7:0] an;
    wire [6:0] seg;
    wire td;

    // 实例化被测试模块
    top_TFD uut (
        .clk(clk),
        .rstn(rstn),
        .sw(sw),
        .st(st),
        .ent(ent),
        .del(del),
        .pre(pre),
        .nxt(nxt),
        .taddr(taddr),
        .an(an),
        .seg(seg),
        .td(td)
    );

    // 生成时钟信号
    always begin
        #5 clk = ~clk;
    end

    // 初始化输入信号并进行测试
    initial begin
        clk = 0;
        rstn = 0;
        sw = 16'h0;
        st = 0;
        ent = 0;
        del = 0;
        pre = 0;
        nxt = 0;

        #10 rstn = 1; // 复位结束
        #10 sw = 16'hF; // 改变sw的值
        #10 nxt = 1;
        #10 nxt = 0;//输入sw的值到taddr(16'd0)
        #10 nxt = 1;
        #10 nxt = 0;//将taddr切换到下一个地址(16'd1)        
        #10 nxt = 1;
        #10 nxt = 0;//输入sw的值到taddr(16'd1)
        #10 nxt = 1;
        #10 nxt = 0;//将taddr切换到下一个地址(16'd2)
        #10 st = 1;
        #10 st = 0;//开始计时，在taddr2观察倒计时的实时显示

        #100 rstn = 0; // 结束仿真
    end
endmodule
