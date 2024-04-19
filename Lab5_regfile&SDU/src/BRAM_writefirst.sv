`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 09:32:06
// Design Name: 
// Module Name: BRAM_readfirst
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


module dual_port_1_clock_bram_write_first #(
    parameter RAM_WIDTH = 64,            // Specify RAM data width
    parameter RAM_DEPTH = 512            // Specify RAM depth (number of entries)
)(
    input [$clog2(RAM_DEPTH)-1:0] addra, // Write address bus, width determined from RAM_DEPTH
    input [$clog2(RAM_DEPTH)-1:0] addrb, // Read address bus, width determined from RAM_DEPTH
    input [RAM_WIDTH-1:0] dina,          // RAM input data
    input clka,                          // Clock
    input wea,                           // Write enable
    output [RAM_WIDTH-1:0] doutb         // RAM output data
);
    (*ram_style="block"*)
    reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
    reg [$clog2(RAM_DEPTH)-1:0] addr_r;

    generate
       integer ram_index;
       initial
            for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
                BRAM[ram_index] = {RAM_WIDTH{1'b0}};
    endgenerate

    always @(posedge clka) begin
        addr_r <= addra == addrb ? addra : addrb;
        if (wea) BRAM[addra] <= dina;
    end    

    assign doutb = BRAM[addr_r];

endmodule