module decoder_6_64 (
    input [5:0] in,
    output reg [63:0] co
);

    always @(in) begin
        co = 64'b0; // 初始化输出为全0
        co[in] = 1'b1; // 将输入作为索引，将对应的输出位设置为1
    end

endmodule

module decoder_4_16 (
    input [3:0] in,
    output reg [16:0] co
);

    always @(in) begin
        co = 17'b0; // 初始化输出为全0
        co[in] = 1'b1; // 将输入作为索引，将对应的输出位设置为1
    end

endmodule

module decoder_2_4 (
    input [1:0] in,
    output reg [4:0] co
);

    always @(in) begin
        co = 5'b0; // 初始化输出为全0
        co[in] = 1'b1; // 将输入作为索引，将对应的输出位设置为1
    end

endmodule

module decoder_5_32 (
    input [4:0] in,
    output reg [32:0] co
);

    always @(in) begin
        co = 33'b0; // 初始化输出为全0
        co[in] = 1'b1; // 将输入作为索引，将对应的输出位设置为1
    end

endmodule