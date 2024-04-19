`timescale 1ns / 1ps
module multiplier(
    input       [31:0]  mul1,mul2,    //操作�?
    output      [31:0]  productl,     //运算结果 �? �?32�?
    output      [31:0]  producth      //运算结果 �? �?32�?
);
wire [63:0] part0;//32�?64位部分积
wire [63:0] part1;
wire [63:0] part2;
wire [63:0] part3;
wire [63:0] part4;
wire [63:0] part5;
wire [63:0] part6;
wire [63:0] part7;
wire [63:0] part8;
wire [63:0] part9;
wire [63:0] part10;
wire [63:0] part11;
wire [63:0] part12;
wire [63:0] part13;
wire [63:0] part14;
wire [63:0] part15;
wire [63:0] part16;
wire [63:0] part17;
wire [63:0] part18;
wire [63:0] part19;
wire [63:0] part20;
wire [63:0] part21;
wire [63:0] part22;
wire [63:0] part23;
wire [63:0] part24;
wire [63:0] part25;
wire [63:0] part26;
wire [63:0] part27;
wire [63:0] part28;
wire [63:0] part29;
wire [63:0] part30;
wire [63:0] part31;

mux #(64) MUL0(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<0),
    .s(mul2[0]),
    .y(part0)
);
mux #(64) MUL1(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<1),
    .s(mul2[1]),
    .y(part1)
);
mux #(64) MUL2(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<2),
    .s(mul2[2]),
    .y(part2)
);
mux #(64) MUL3(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<3),
    .s(mul2[3]),
    .y(part3)
);
mux #(64) MUL4(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<4),
    .s(mul2[4]),
    .y(part4)
);
mux #(64) MUL5(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<5),
    .s(mul2[5]),
    .y(part5)
);
mux #(64) MUL6(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<6),
    .s(mul2[6]),
    .y(part6)
);
mux #(64) MUL7(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<7),
    .s(mul2[7]),
    .y(part7)
);
mux #(64) MUL8(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<8),
    .s(mul2[8]),
    .y(part8)
);
mux #(64) MUL9(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<9),
    .s(mul2[9]),
    .y(part9)
);
mux #(64) MUL10(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<10),
    .s(mul2[10]),
    .y(part10)
);
mux #(64) MUL11(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<11),
    .s(mul2[11]),
    .y(part11)
);
mux #(64) MUL12(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<12),
    .s(mul2[12]),
    .y(part12)
);
mux #(64) MUL13(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<13),
    .s(mul2[13]),
    .y(part13)
);
mux #(64) MUL14(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<14),
    .s(mul2[14]),
    .y(part14)
);
mux #(64) MUL15(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<15),
    .s(mul2[15]),
    .y(part15)
);
mux #(64) MUL16(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<16),
    .s(mul2[16]),
    .y(part16)
);
mux #(64) MUL17(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<17),
    .s(mul2[17]),
    .y(part17)
);
mux #(64) MUL18(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<18),
    .s(mul2[18]),
    .y(part18)
);
mux #(64) MUL19(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<19),
    .s(mul2[19]),
    .y(part19)
);
mux #(64) MUL20(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<20),
    .s(mul2[20]),
    .y(part20)
);
mux #(64) MUL21(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<21),
    .s(mul2[21]),
    .y(part21)
);
mux #(64) MUL22(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<22),
    .s(mul2[22]),
    .y(part22)
);
mux #(64) MUL23(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<23),
    .s(mul2[23]),
    .y(part23)
);
mux #(64) MUL24(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<24),
    .s(mul2[24]),
    .y(part24)
);
mux #(64) MUL25(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<25),
    .s(mul2[25]),
    .y(part25)
);
mux #(64) MUL26(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<26),
    .s(mul2[26]),
    .y(part26)
);
mux #(64) MUL27(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<27),
    .s(mul2[27]),
    .y(part27)
);
mux #(64) MUL28(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<28),
    .s(mul2[28]),
    .y(part28)
);
mux #(64) MUL29(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<29),
    .s(mul2[29]),
    .y(part29)
);
mux #(64) MUL30(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<30),
    .s(mul2[30]),
    .y(part30)
);
mux #(64) MUL31(
    .a(0),
    .b({{32{mul1[31]}},mul1}<<31),
    .s(mul2[31]),
    .y(part31)
);
assign {producth,productl}=  part0 +part1 +part2 +part3 +part4 +part5 +part6 +part7 +part8 +part9
                            +part10+part11+part12+part13+part14+part15+part16+part17+part18+part19
                            +part20+part21+part22+part23+part24+part25+part26+part27+part28+part29
                            +part30-part31;//有符号数乘法，部分积均为补码，最后一次加法改为减法，得到补码
endmodule
