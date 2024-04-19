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

    // �ź�����
    reg [31:0] mul1, mul2;  // ����˷�������
    wire [31:0] productl;  // ��32λ�˷����
    wire [31:0] producth;  // ��32λ�˷����

    // ʵ�����˷���ģ��
    multiplier myMultiplier(
        .mul1(mul1),
        .mul2(mul2),
        .productl(productl),
        .producth(producth)
    );

    // ��ʼ�������ź�
    initial begin
        mul1 = 32'h00000002; // ������������ mul1
        mul2 = 32'h00000003; // ������������ mul2

        // ִ�в�������
        // ��ÿ�����������У��� mul1 �� mul2 ����Ϊ�����ֵ��Ȼ��ȴ�һ��ʱ���Թ۲�������
        // �������Ӹ���Ĳ�����������֤�˷����Ĺ���

        // ��һ����������
        #10;  // �ȴ� 10 ��ʱ�䵥λ

        // �ڶ�����������
        mul1 = 32'hFFFFFFFF; // �����µ� mul1 ֵ
        mul2 = 32'hFFFFFFFF; // �����µ� mul2 ֵ
        #10;  // �ȴ� 10 ��ʱ�䵥λ

        // ��������Լ�����Ӹ����������

        $finish; // ��������
    end

endmodule
