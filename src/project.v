/*
 * Copyright (c) 2024 Illamparuthi G
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1
    input  wire       clk,      // clock
    input  wire       rst_n     // reset (active low)
);

    wire detect_signal;
    wire buzzer_signal;

    // CFAR module
    cfar cfar_inst (
        .clk(clk),
        .rst(~rst_n),
        .sample_in(ui_in),
        .detect(detect_signal)
    );

    // Buzzer module
    buzzer buzzer_inst (
        .clk(clk),
        .detect(detect_signal),
        .buzzer_out(buzzer_signal)
    );

    // Output mapping
    assign uo_out[0] = buzzer_signal;
    assign uo_out[7:1] = 7'b0;

    // No bidirectional IO used
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Prevent unused signal warnings
    wire _unused = &{ena, uio_in, 1'b0};

endmodule
