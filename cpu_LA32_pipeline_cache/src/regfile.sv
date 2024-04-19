module regfile(
    input   wire clk,
    input   wire rstn,
    input   wire [4:0]   raddr1,
    input   wire [4:0]   raddr2,
    input   wire [4:0]   raddr0,//for debug
    output  wire [31:0]  rdata1,
    output  wire [31:0]  rdata2,
    output  wire [31:0]  rdata0,//for debug
    input   wire         we    ,
    input   wire [4:0]   waddr ,
    input   wire [31:0]  wdata 
);
    reg [31:0] regs [0:31];
    always @(posedge clk) begin
        if(!rstn)begin
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end
        if (we) begin
            regs[waddr] <= wdata;
        end
    end

    assign rdata1 = (we && raddr1 == waddr) ? wdata : ((raddr1 == 5'b0) ? 32'b0 : regs[raddr1]);//写优先

    assign rdata2 = (we && raddr2 == waddr) ? wdata : ((raddr2 == 5'b0) ? 32'b0 : regs[raddr2]);

    assign rdata0 = (raddr0 == 5'b0) ? 32'b0 : regs[raddr0];
endmodule