`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 21:45:48
// Design Name: 
// Module Name: TFD
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


module TFD #(
    parameter WIDTH = 32, 
             RST_VLU = 0
)(
    input [WIDTH-1:0] k,//定时常数，定时时长 = (k+1)*clk
    input st,//定时开始信号
    input rst,
    input clk,
    output reg [WIDTH-1:0] q,//定时器输出信号
    output reg td//定时结束信号
    );
    
    reg [WIDTH-1:0] counter = 0; // 计数器

    always @(posedge clk) begin
        if (!rst) begin
            counter <= 0; // 复位计数器到0
            td <= 1; // 设置定时结束信号
        end else if (st) begin
            counter <= k; // 装入定时常数
            td <= 0; // 清除定时结束信号
        end else if (counter > 0) begin
            counter <= counter - 1; // 开始倒计时
        end else if (counter == 0) begin
            td <= 1; // 输出定时结束信号
        end // 更新上一个时钟周期的定时开始信号
        q <= counter; // 输出计数器
    end

endmodule