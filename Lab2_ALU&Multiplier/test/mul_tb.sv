`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 10:58:44
// Design Name: 
// Module Name: mul_tb
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


module multiplier_test;

    // 信号声明
    reg [31:0] mul1, mul2;  // 输入乘法操作数
    wire [31:0] productl;  // 低32位乘法结果
    wire [31:0] producth;  // 高32位乘法结果

    // 实例化乘法器模块
    multiplier myMultiplier(
        .mul1(mul1),
        .mul2(mul2),
        .productl(productl),
        .producth(producth)
    );

    // 初始化输入信号
    initial begin
        mul1 = 32'h00000002; // 设置输入数据 mul1
        mul2 = 32'h00000003; // 设置输入数据 mul2

        // 执行测试用例
        // 在每个测试用例中，将 mul1 和 mul2 设置为所需的值，然后等待一段时间以观察输出结果
        // 你可以添加更多的测试用例来验证乘法器的功能

        // 第一个测试用例
        #10;  // 等待 10 个时间单位

        // 第二个测试用例
        mul1 = 32'hFFFFFFFF; // 设置新的 mul1 值
        mul2 = 32'hFFFFFFFF; // 设置新的 mul2 值
        #10;  // 等待 10 个时间单位

        // 在这里可以继续添加更多测试用例

        $finish; // 结束仿真
    end

endmodule
