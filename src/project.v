`default_nettype none

module tt_um_ttsky_cfar (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire clk,
    input  wire rst_n,
    input  wire ena
);

wire detect;

// Convert active-low reset → active-high
wire rst = ~rst_n;

// Always valid (since TT feeds continuously)
wire valid = 1'b1;

cfar cfar_inst (
    .clk(clk),
    .rst(rst),
    .data_in(ui_in),
    .valid_in(valid),
    .detect(detect)
);

// Output mapping
assign uo_out[0] = detect;
assign uo_out[7:1] = 7'b0;

// No bidirectional IO used
assign uio_out = 8'b0;
assign uio_oe  = 8'b0;

endmodule
