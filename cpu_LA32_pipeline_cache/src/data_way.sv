module data_way (
    input wire clk,
    input wire rstn,
    input wire [7:0] rindex,
    input wire [7:0] windex,
    input wire [127:0] wdata,
    input wire we,
    output wire [127:0] rdata
);
    
reg [127:0] data [0:255];

always @(posedge clk) begin
    if (~rstn) begin
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            data[i] <= 128'h0;
        end
    end else begin
        if (we) begin
            data[windex] <= wdata;
        end
    end
end

assign rdata = data[rindex];

endmodule