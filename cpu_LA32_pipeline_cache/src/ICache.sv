module icache (
    //和CPU的接口
    input  wire        clk,
    input  wire        rstn,
    input  wire [31:0] raddr,
    output wire [31:0] rdata,
    output reg         addr_ready,
    input  wire        addr_valid,      //接收cpu发的地址
    output wire        inst_valid,
    input  wire        inst_ready,      //向cpu发指令
    //和主存的接口
    output reg  [31:0] inst_mem_raddr,
    input  wire [31:0] inst_mem_rdata
);

  reg valid;
  always @(posedge clk) begin
    if (!rstn) begin
        valid <= 1'b0;
    end
    else begin
        valid <= 1'b1;
    end
  end
  always @(posedge clk) begin
    
  end
  //request buffer
  reg  [ 31:0] request_buffer;
  wire [ 31:0] raddr_reg;
  wire         rbuf_we;

  //return buffer
  reg          retbuf_we;
  reg  [127:0] return_buffer;
  reg  [ 31:0] inst_from_retbuf;

  wire [  1:0] block_offset;
  wire [  7:0] rindex;
  wire [127:0] rdata_way1;
  wire [127:0] rdata_way2;
  wire [  7:0] windex;
  wire [127:0] wdata;
  wire [ 19:0] tag_raddr;
  wire [ 19:0] tag_way1;
  wire [ 19:0] tag_way2;
  wire [ 19:0] wtag;
  wire         valid_way1;
  wire         valid_way2;
  wire [127:0] rdata_cache;
  reg  [ 31:0] inst_from_cache;

  wire         hit_way1;
  wire         hit_way2;
  wire         miss;
  reg          recently_hit_way   [0:255];
  wire         way_to_be_replaced;

  wire         is_i_rlast;
  wire         is_i_rtarget;
  wire         is_data_from_cache;
  wire         tagv_we_way1;
  wire         tagv_we_way2;
  wire         data_we_way1;
  wire         data_we_way2;
  reg          inst_mem_raddr_we;

  reg  [  2:0] state;
  reg  [  2:0] next_state;

  parameter LOOKUP = 3'b001;
  parameter MISS = 3'b010;
  parameter REFILL = 3'b100;

  //request buffer
  always @(posedge clk) begin
    if (!rstn) begin
      request_buffer <= 32'h0;
    end else begin
      if (addr_valid && rbuf_we) begin
        request_buffer <= raddr;
      end
    end
  end

  assign raddr_reg = request_buffer;

  //extract information from raddr
  assign block_offset = raddr[3:2];
  assign rindex = raddr[11:4];
  assign tag_raddr = raddr[31:12];

  //Cache Mem
  data_way data_way1 (
      .clk(clk),
      .rstn(rstn),
      .rindex(rindex),
      .rdata(rdata_way1),
      .windex(windex),
      .wdata(wdata),
      .we(data_we_way1)
  );

  data_way data_way2 (
      .clk(clk),
      .rstn(rstn),
      .rindex(rindex),
      .rdata(rdata_way2),

      .windex(windex),
      .wdata(wdata),
      .we(data_we_way2)
  );

  tagv_way tagv_way1 (
      .clk(clk),
      .rstn(rstn),
      .rindex(rindex),
      .rtag(tag_way1),
      .rvalid(valid_way1),

      .we(tagv_we_way1),
      .wtag(wtag),
      .windex(windex)
  );

  tagv_way tagv_way2 (
      .clk(clk),
      .rstn(rstn),
      .rindex(rindex),
      .rtag(tag_way2),
      .rvalid(valid_way2),

      .we(tagv_we_way2),
      .wtag(wtag),
    .windex(windex)
  );

  //Hit
  assign hit_way1 = (tag_way1 == tag_raddr) && valid_way1;
  assign hit_way2 = (tag_way2 == tag_raddr) && valid_way2;
  assign miss = ((~hit_way1) && (~hit_way2)) && (state == LOOKUP);

  //get inst from cache
  assign rdata_cache = hit_way1 ? rdata_way1 : rdata_way2;
  always @(*) begin
    case (block_offset)
      2'b00: begin
        inst_from_cache = rdata_cache[31:0];
      end
      2'b01: begin
        inst_from_cache = rdata_cache[63:32];
      end
      2'b10: begin
        inst_from_cache = rdata_cache[95:64];
      end
      2'b11: begin
        inst_from_cache = rdata_cache[127:96];
      end
    endcase
  end

  //Finite State Machine: Part1
  always @(posedge clk) begin
    if (!rstn) begin
      state <= LOOKUP;
    end else begin
      state <= next_state;
    end
  end

  //Part2
  always @(*) begin
    case (state)
      LOOKUP: begin
        if (valid && miss) next_state = MISS;
        else next_state = LOOKUP;
      end
      MISS: begin
        if (is_i_rlast) next_state = REFILL;
        else next_state = MISS;
      end
      REFILL: begin
        next_state = LOOKUP;
      end
      default: begin
        next_state = LOOKUP;
      end
    endcase
  end

  //Part3
  always @(*) begin
    case (state)
      LOOKUP: begin
        addr_ready = rstn;
        return_buffer = 128'h0;
        inst_mem_raddr_we = 1'b1;
        // inst_mem_raddr = {raddr[31:4], 2'b00};
      end
      MISS: begin
        // inst_mem_raddr = inst_mem_raddr + 1;
        addr_ready = 1'b0;
        retbuf_we = 1'b1;
        inst_mem_raddr_we = 1'b1;
      end
      REFILL: begin
        addr_ready = 1'b0;
        retbuf_we  = 1'b0;
        inst_mem_raddr_we = 1'b0; 
      end
    endcase
  end

always @(posedge clk) begin
  if(!rstn)begin
    inst_mem_raddr <= 32'h0;
  end
  else if(inst_mem_raddr_we && (state == LOOKUP))begin
    inst_mem_raddr <= {raddr[31:4], 2'b00};
  end
  else if(inst_mem_raddr_we && (state == MISS))begin
    inst_mem_raddr <= inst_mem_raddr + 1;
  end
  else if(next_state == REFILL)begin
    inst_mem_raddr <= 32'h0;
  end
end

  //control signals generated by conbinational logic, but related to current state
  assign is_i_rlast = (inst_mem_raddr == {raddr_reg[31:4], 2'b11}) && (state == MISS);
  assign inst_valid = (state == LOOKUP && !miss) || (state == REFILL);//没有对cpu的inst_ready信号检验，因为现有cpu给出的ready永远是1
  assign is_data_from_cache = (state == LOOKUP && !miss);
  assign rbuf_we = (state == LOOKUP && miss);
  assign tagv_we_way1 = (state == REFILL) && !way_to_be_replaced;
  assign tagv_we_way2 = (state == REFILL) && way_to_be_replaced;
  assign data_we_way1 = (state == REFILL) && !way_to_be_replaced;
  assign data_we_way2 = (state == REFILL) && way_to_be_replaced;

  //LRU regs
  always @(posedge clk) begin
    if (!rstn) begin
      integer i;
      for (i = 0; i < 256; i = i + 1) begin
          recently_hit_way[i] <= 1'b0;
      end
    end else if ((state == LOOKUP) && !miss) begin
      recently_hit_way[rindex] <= hit_way2;
    end
  end

  //refill signals
  assign wdata = return_buffer;
  assign wtag = raddr_reg[31:12];
  assign windex = raddr_reg[11:4];
  assign way_to_be_replaced = !recently_hit_way[windex];

  //return buffer
  always @(posedge clk) begin
    if (!rstn) begin
      return_buffer <= 128'b0;
    end else if (retbuf_we) begin
      return_buffer <= {inst_mem_rdata, return_buffer[127:32]};
      if (inst_mem_raddr == raddr_reg[31:2]) begin
        inst_from_retbuf <= inst_mem_rdata;
      end
    end
  end

  //final selection
  assign rdata = is_data_from_cache ? inst_from_cache : inst_from_retbuf;

endmodule
