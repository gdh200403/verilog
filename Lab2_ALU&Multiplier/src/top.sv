`timescale 1ns/1ps
module Mul_top(
    input               clk,            //clk100mhz
    input               rstn,           //cpu_resetn
        
    input [15:0]        x,              //sw15-0
	input               ent,            //btnc
    input               del,            //btnl
    input               step,           //btnr
	input               pre,            //btnu	
    input               nxt,            //btnd
        
    //输出指示
    output [15:0]       taddr,          //led15-0 
    output [2:0]        flag,           //led 16 15-0，指示数码管显示的数据类型
    output [7:0]        an,             //an7-0
    output [6:0]        seg             //ca-cg
);
    wire [31:0]  tdout;
    reg [31:0] tdin;
    wire twe;

    wire [31:0] mul_src1, mul_src2, mul_prol, mul_proh,mul_prol_reg, mul_proh_reg;

    wire rst, tclk;

    utu  utu_inst (
        .clk    (clk),
        .rstn   (rstn),
        .x      (x),
        .ent    (ent),
        .del    (del),
        .step   (step),
        .pre    (pre),
        .nxt    (nxt),
        .taddr  (taddr),
        .tdin   (tdin),
        .tdout  (tdout),
        .twe    (twe),
        .flag   (flag),
        .an     (an),
        .seg    (seg),
        .rst    (rst),
        .tclk   (tclk)
    );


    register# ( .WIDTH(32), .RST_VAL(0))
    register_inst_src1 (
        .clk    (clk),
        .rst    (rst),
        .en     (taddr == 16'h0 && twe),
        .d      (tdout),
        .q      (mul_src1)
    );

    register# ( .WIDTH(32), .RST_VAL(0))
    register_inst_src2 (
        .clk    (clk),
        .rst    (rst),
        .en     (taddr == 16'h1 && twe),
        .d      (tdout),
        .q      (mul_src2)
    );

    multiplier mul_inst (
        .mul1    (mul_src1),
        .mul2    (mul_src2),
        .productl   (mul_prol),
        .producth   (mul_proh)
    );

    register# ( .WIDTH(32), .RST_VAL(0))
    register_inst_mul_prol (
        .clk    (clk),
        .rst    (rst),
        .en     (1'b1),
        .d      (mul_prol),
        .q      (mul_prol_reg)
    );

    register# ( .WIDTH(32), .RST_VAL(0))
    register_inst_mul_proh (
        .clk    (clk),
        .rst    (rst),
        .en     (1'b1),
        .d      (mul_proh),
        .q      (mul_proh_reg)
    );

    always@(*) begin
        case(taddr)
        16'h0:   tdin = mul_src1;
        16'h1:   tdin = mul_src2;
        16'h2:   tdin = mul_prol_reg;
        16'h3:   tdin = mul_proh_reg;
        default: tdin = 0;
        endcase
    end

endmodule