`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/16 13:57:03
// Design Name: 
// Module Name: top_TFD
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


module top_TFD(
    input                clk,       // 时钟信号
    input                rstn,      // 复位信号
    input         [15:0] sw,        //sw15-0
    input                st,        //开始计时
    input                ent,
    input                del,
    input                pre,
    input                nxt,
    output     [15:0] taddr,     //led15-0
    output     [ 7:0] an,        // 数码管位选信号
    output      [ 6:0] seg,       // 数码管段选信号
    output reg            td         // 定时器到时信号，接入任何一个led灯即可
);
    wire twe;
    wire rst, tclk;
    wire  [15:0] number_h;
    wire  [15:0] number_l;
    wire   [31:0]  count; //32位当前剩余时间
    wire   [31:0]  count_reg; //32位当前剩余时间
    reg [26:0] counter = 0; // 分频器计数器
    reg clk_out2 = 0; // 分频后的时钟信号
    reg [31:0] tdin;
    wire [31:0]  tdout;

    always @(posedge clk) begin
        if(counter < 100000000) begin // 100MHz的时钟分频到1s
            counter <= counter + 1;
        end else begin
            counter <= 0;
            clk_out2 <= ~clk_out2; // 翻转输出信号
        end
    end

    // 实例化定时器模块
    TFD timer (
        .k({number_h,number_l}),
        .st(st),
        .rst(rstn),
        .clk(clk_out2),
        .q(count),
        .td(td)
    );

    utu UTU(
        .clk(clk),
        .rstn(rstn),
        .x(sw),
        .ent(ent),
        .del(del),
        .step(0),
        .pre(pre),
        .nxt(nxt),
        .taddr(taddr),
        .tdin(tdin),
        .tdout(tdout),
        .twe(twe),
        .rst(rst),
        .tclk(tclk),
        .an(an),
        .seg(seg)
    );

    register# ( .WIDTH(16), .RST_VAL(0))
    Number_h (
        .clk    (clk),
        .rst    (rst),
        .en     (taddr == 16'h0 && twe),
        .d      (tdout),
        .q      (number_h)
    );

    register# ( .WIDTH(16), .RST_VAL(0))
    Number_l (
        .clk    (clk),
        .rst    (rst),
        .en     (taddr == 16'h1 && twe),
        .d      (tdout),
        .q      (number_l)
    );

    register# ( .WIDTH(32), .RST_VAL(0))
    Count (
        .clk    (clk),
        .rst    (rst),
        .en     (1'b1),
        .d      (count),
        .q      (count_reg)
    );

    // // 数码管段选信号的生成逻辑
    // reg [2:0] digit = 0; // 数码管位选计数器
    // reg [3:0] display [0:7]; // 数码管显示值的寄存器数组

    // always_comb begin
    //     display[0] = count_reg[3:0];
    //     display[1] = count_reg[7:4];
    //     display[2] = count_reg[11:8];
    //     display[3] = count_reg[15:12];
    //     display[4] = count_reg[19:16];
    //     display[5] = count_reg[23:20];
    //     display[6] = count_reg[27:24];
    //     display[7] = count_reg[31:28];
    // end

    // reg [26:0] counter1 = 0; // 分频器计数器
    // reg clk_out1 = 0; // 分频后的时钟信号

    // always @(posedge clk) begin
    //     if(counter1 < 5000000) begin // 100MHz的时钟分频到20ms
    //         counter1 <= counter1 + 1;
    //     end else begin
    //         counter1 <= 0;
    //         clk_out1 <= ~clk_out1; // 翻转输出信号
    //     end
    // end

    always@(*) begin
        case(taddr)
        16'h0:   tdin = number_h;
        16'h1:   tdin = number_l;
        16'h2:   tdin = count_reg;
        default: tdin = 0;
        endcase
    end

    // always @(posedge clk_out1) begin
    //     digit <= digit + 1; // 更新数码管位选计数器
    //     case(display[digit])
    //         4'b0000: seg <= 7'b0000001;
    //         4'b0001: seg <= 7'b1001111;
    //         4'b0010: seg <= 7'b0010010;
    //         4'b0011: seg <= 7'b0000110;
    //         4'b0100: seg <= 7'b1001100;
    //         4'b0101: seg <= 7'b0100100;
    //         4'b0110: seg <= 7'b0100000;
    //         4'b0111: seg <= 7'b0001111;
    //         4'b1000: seg <= 7'b0000000;
    //         4'b1001: seg <= 7'b0000100;
    //         4'b1010: seg <= 7'b0001000;//A
    //         4'b1011: seg <= 7'b1100000;//b
    //         4'b1100: seg <= 7'b0110001;//C
    //         4'b1101: seg <= 7'b1000010;//d
    //         4'b1110: seg <= 7'b0110000;//E
    //         4'b1111: seg <= 7'b0111000;//f
    //         default: seg <= 7'b0000000;
    //     endcase
    //     an <= ~(1 << digit); // 更新数码管位选信号
    // end

endmodule
