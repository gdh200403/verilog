`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 13:46:05
// Design Name: 
// Module Name: mycpu_top
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


module mycpu_top (
    input clk,
    input rstn

    //Ports For Debug
    , input  [31:0] dra0,
      output [31:0] drd0,
      input  [ 4:0] rra0,
      output [31:0] rrd0
    //,output ctr_debug
    , output [31:0] npc,
      output [31:0] pc,
      output [31:0] ir,
      output [31:0] pc_id,
      output [31:0] ir_id,
      output [31:0] pc_ex,
      output [31:0] ir_ex,
      output [31:0] rrd1,
      output [31:0] rrd2,
      output [31:0] imm,
      output [31:0] ir_mem,
      output [31:0] res,
      output [31:0] dwd,
      output [31:0] ir_wb,
      output [31:0] drd,
      output [31:0] res_wb,
      output [31:0] rwd
);

  assign dwd = data_sram_wdata;
  assign drd = data_sram_rdata;

  wire [31:0] inst_raddr;
  wire [31:0] inst_rdata;

  wire        inst_valid;
  wire        inst_ready;
  wire        inst_addr_valid;
  wire        inst_addr_ready;

  wire [31:0] inst_mem_raddr;
  wire [31:0] inst_mem_rdata;

  wire        data_sram_we;
  wire [31:0] data_sram_addr;
  wire [31:0] data_sram_wdata;
  wire [31:0] data_sram_rdata;

  mycpu_LA32 cpu (
      .clk (clk),
      .rstn(rstn),

      //cpu icahe ports
      .inst_raddr(inst_raddr),
      .inst_rdata(inst_rdata),
      .inst_valid(inst_valid),
      .inst_ready(inst_ready),
      .inst_addr_valid(inst_addr_valid),
      .inst_addr_ready(inst_addr_ready),

      //cpu dmem ports
      .data_sram_we_out(data_sram_we),
      .data_sram_addr  (data_sram_addr),
      .data_sram_wdata (data_sram_wdata),
      .data_sram_rdata (data_sram_rdata)
      // .data_sram_wdata(dwd),
      // .data_sram_rdata(drd)

      , .rra0(rra0),
      .rrd0(rrd0),
      .npc(npc),
      .pc_out(pc),
      .ir(ir),
      .pc_id(pc_id),
      .ir_id(ir_id),
      .pc_ex(pc_ex),
      .ir_ex(ir_ex),
      .rrd1(rrd1),
      .rrd2(rrd2),
      .imm_out(imm),
      .ir_mem(ir_mem),
      .res(res),
      .ir_wb(ir_wb),
      .res_wb(res_wb),
      .rwd(rwd)
  );

  icache u_icache (
      .clk           (clk),
      .rstn          (rstn),
      .raddr         (inst_raddr),
      .rdata         (inst_rdata),
      .addr_ready    (inst_addr_ready),
      .addr_valid    (inst_addr_valid),
      .inst_valid    (inst_valid),
      .inst_ready    (inst_ready),
      .inst_mem_raddr(inst_mem_raddr),
      .inst_mem_rdata(inst_mem_rdata)
  );


  ram_0 data_ram (
      .clk(clk),
      .we (data_sram_we),
      .a  (data_sram_addr),
      .d  (data_sram_wdata),
      .spo(data_sram_rdata)

      //debug
      , .dpra(dra0),
        .dpo (drd0)
  );

  ram_1 inst_ram (
      .clk(clk),
      .we (1'b0),
      .a  (inst_mem_raddr),
      .d  (32'b0),
      .spo(inst_mem_rdata)
  );
endmodule
