module tagv_way (
    input wire clk,
    input wire rstn,
    input wire [7:0] rindex,
    input wire [7:0] windex,
    input wire [19:0] wtag,
    input wire we,
    output wire [19:0] rtag,
    output wire rvalid
);
    
reg [20:0] tagv [0:255];

always @(posedge clk) begin
    if (~rstn) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            tagv[i] <= 21'h0;
        end
    end else begin
        if (we) begin
            tagv[windex] <= {wtag,1'b1};
        end
    end
end


assign rtag = tagv[rindex][20:1];
assign rvalid = tagv[rindex][0];


endmodule