`default_nettype none

module tt_um_ttsky_cfar (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

wire detect;

cfar_detector core (
    .clk(clk),
    .rst_n(rst_n),
    .sample(ui_in),
    .detect(detect)
);

// Only LSB used
assign uo_out = {7'b0, detect};

// No bidirectional usage
assign uio_out = 8'b0;
assign uio_oe  = 8'b0;

// Prevent unused warnings
wire _unused = &{ena, uio_in, 1'b0};

endmodule
