module TFD_tb();

    // Parameters
    parameter WIDTH = 32;
    parameter RST_VLU = 0;

    // Inputs
    reg [WIDTH-1:0] k;
    reg st;
    reg rst;
    reg clk;

    // Outputs
    wire [WIDTH-1:0] q;
    wire td;

    // Instantiate the TFD module
    TFD #(WIDTH,RST_VLU) dut (
        .k(k),
        .st(st),
        .rst(rst),
        .clk(clk),
        .q(q),
        .td(td)
    );

    //Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        k = 10;
        st = 0;
        rst = 0;
        clk = 0;

        // Apply reset
        #10 rst = 1;

        // Wait for a few clock cycles
        #20;

        // Start the timer
        st = 1;
        
        #20 st = 0;
        // Wait for the timer to finish
        #60;

        // Stop the timer
        st = 0;

        // Wait for a few clock cycles
        #20;

        // Apply reset
        rst = 0;

        // Wait for a few clock cycles
        #10;
    end

endmodule