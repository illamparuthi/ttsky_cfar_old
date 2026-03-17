`timescale 1ns/1ps

module tb;

reg clk;
reg rst_n;
reg [7:0] sample_in;
wire detect;

cfar dut (
.clk(clk),
.rst_n(rst_n),
.sample_in(sample_in),
.detect(detect)
);

// clock
always #5 clk = ~clk;

initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb);


clk = 0;
rst_n = 0;
sample_in = 0;

#20;
rst_n = 1;

// noise
repeat (10) begin
    sample_in = 10;
    #10;
end

// spike
repeat (5) begin
    sample_in = 200;
    #10;
end

// back to noise
repeat (10) begin
    sample_in = 10;
    #10;
end

#100;
$finish;


end

endmodule
