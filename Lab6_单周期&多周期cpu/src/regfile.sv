module regfile(
    input   clk,
    input   [5:0]   raddr1,
    input   [5:0]   raddr2,
    output  [31:0]  rdata1,
    output  [31:0]  rdata2,
    input           we    ,
    input   [5:0]   waddr ,
    input   [31:0]  wdata 
);
    reg [31:0] regs [0:63];
    always @(posedge clk) begin
        if (we && waddr) begin
            regs[waddr] <= wdata;
        end
    end
    assign regs[0] = 0;
    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
endmodule