`timescale 1ns/1ps
module ALUtop(
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

    wire [31:0] alu_src1, alu_src2, alu_out, alu_out_reg;
    wire [11:0] alu_op;

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
        .q      (alu_src1)
    );

    register# ( .WIDTH(32), .RST_VAL(0))
    register_inst_src2 (
        .clk    (clk),
        .rst    (rst),
        .en     (taddr == 16'h1 && twe),
        .d      (tdout),
        .q      (alu_src2)
    );

    register# ( .WIDTH(12), .RST_VAL(0))
    register_inst_alu_op(
        .clk    (clk),
        .rst    (rst),
        .en     (taddr == 16'h2 && twe),
        .d      (tdout[11:0]),
        .q      (alu_op)
    );

    ALU alu_inst (
        .a      (alu_src1),
        .b      (alu_src2),
        .op      (alu_op),
        .out      (alu_out)
    );

    register# ( .WIDTH(32), .RST_VAL(0))
    register_inst_alu_out (
        .clk    (clk),
        .rst    (rst),
        .en     (1'b1),
        .d      (alu_out),
        .q      (alu_out_reg)
    );

    always@(*) begin
        case(taddr)
        16'h0:   tdin = alu_src1;
        16'h1:   tdin = alu_src2;
        16'h2:   tdin = {20'h0, alu_op};
        16'h3:   tdin = alu_out_reg;
        default: tdin = 0;
        endcase
    end


endmodule