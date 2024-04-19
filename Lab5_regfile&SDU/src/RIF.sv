`timescale 1ns/1ps
module  RIF (//Receive Interface 接收接口
    input                   clk,
    input                   rxd,    //串行接收数据 
    input                   rx_rdy, //接收端_准备好 
    output reg              rx_vld, //接收端_数据有效
    output reg  [7:0]       dout    //接收数据

);
    reg     [2:0]   start_cnt;     //起始位检测计数器
    reg     [3:0]   data_cnt;     //数据位读取计数器
    reg             start;  //是否已有起始位
    reg     [3:0]   stop_cnt;     //停止位到来计数器
    reg [7:0] data_temp;

    always @(posedge clk) begin
        if(!start&&!rxd)begin
            start_cnt<=start_cnt+1;
            if(start_cnt==3'b111)begin
                start<=1;
                data_cnt<=4'b0000;
                rx_vld<=1'b0;
                stop_cnt<=4'd0;
            end
        end
        else if(start&&stop_cnt!=4'd8)begin
            data_cnt<=data_cnt+1;
            if(data_cnt==4'b1111)begin
                data_temp<={rxd,data_temp[7:1]};
                stop_cnt<=stop_cnt+1;
            end
        end
        else if(start&&stop_cnt==4'd8)begin
            data_cnt<=data_cnt+1;
            if(data_cnt==4'b1111)begin
                if(rxd)begin
                    rx_vld<=1'b1;
                    dout<=data_temp;
                end
                start<=1'b0;
            end
        end
        else begin  //自启动
            start<=0;
            start_cnt<=3'b000;
            data_cnt<=4'b0000;
            stop_cnt<=4'b000;
        end
    end
endmodule