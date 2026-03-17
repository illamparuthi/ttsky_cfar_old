`timescale 1ns/1ps

module tb;

reg clk;
reg rst_n;
reg [7:0] ui_in;
wire [7:0] uo_out;

tt_um_ttsky_cfar dut (
    .clk(clk),
    .rst_n(rst_n),
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(0),
    .uio_out(),
    .uio_oe(),
    .ena(1)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    rst_n = 0;
    ui_in = 0;

    #50;
    rst_n = 1;

    #500;
    $finish;
end

endmodule
