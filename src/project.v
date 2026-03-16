/*
 * SPDX-License-Identifier: Apache-2.0
 */

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
wire buzzer;

// CFAR detector
cfar cfar_inst (
    .clk(clk),
    .rst(~rst_n),
    .sample_in(ui_in),
    .detect(detect)
);

// Buzzer controller
buzzer buzzer_inst (
    .clk(clk),
    .rst(~rst_n),   // <-- important fix
    .detect(detect),
    .buzzer_out(buzzer)
);

assign uo_out[0] = detect;
assign uo_out[1] = buzzer;
assign uo_out[7:2] = 6'b0;

assign uio_out = 8'b0;
assign uio_oe  = 8'b0;

wire _unused = &{ena, uio_in, 1'b0};

endmodule
