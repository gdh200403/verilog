`timescale 1ns/1ps
module  TIF (//Transmit Interface 发送接口
    input                   clk,
    input       [7:0]       din,    //发送数据
    input                   tx_vld, //发送端_数据有效 
    output reg              tx_rdy, //发送端_准备好
    output reg              txd     //串行发送数据 
);
reg     [3:0]   cnt;    //单次发送计数
reg     [7:0]   data;//由低位向高位发送
always @(posedge clk) begin
    if(tx_vld&&tx_rdy)begin
        data<=din;
        cnt<=4'd8;
        tx_rdy<=0;
        txd<=0;
    end
    else if(cnt==4'd0)begin
        txd<=1'b1;
        tx_rdy<=1;
        end
    else if(!tx_rdy)begin
        txd<=data[0];
        data<=data>>1;
        cnt<=cnt-1;
    end
    else begin
        txd<=1'b1;
        tx_rdy<=1;
        data<={8'b1111_1111};
    end    
end
endmodule
