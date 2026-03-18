`timescale 1ns/1ps

module tb_ttsky_cfar_old;

reg clk;
reg rst;
reg [7:0] ui_in;

wire [7:0] uo_out;
wire [7:0] uio_out;
wire [7:0] uio_oe;

// DUT
ttsky_cfar_old dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(8'b0),   // not used
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .clk(clk),
    .rst_n(~rst)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

integer i;
reg [7:0] test_data [0:31];

initial begin
    // Init
    clk = 0;
    rst = 1;
    ui_in = 0;

    // VCD dump
    $dumpfile("ttsky_cfar.vcd");
    $dumpvars(0, tb_ttsky_cfar_old);

    // Reset
    #20;
    rst = 0;

    // -------------------------------
    // Test Pattern
    // -------------------------------
    // Noise + one strong target
    test_data[0]  = 8'd10;
    test_data[1]  = 8'd12;
    test_data[2]  = 8'd11;
    test_data[3]  = 8'd9;
    test_data[4]  = 8'd10;
    test_data[5]  = 8'd50; // TARGET
    test_data[6]  = 8'd11;
    test_data[7]  = 8'd10;
    test_data[8]  = 8'd12;
    test_data[9]  = 8'd9;

    // Remaining noise
    for (i = 10; i < 32; i = i + 1)
        test_data[i] = 8'd10 + (i % 3);

    // -------------------------------
    // Apply inputs
    // -------------------------------
    for (i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        ui_in = test_data[i];
    end

    // Wait to observe detection
    #100;

    $finish;
end

endmodule
