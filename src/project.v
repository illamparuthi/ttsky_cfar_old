`timescale 1ns/1ps
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

    // ─────────────────────────
    // Tie off unused IO
    // ─────────────────────────
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // ─────────────────────────
    // Internal signals
    // ─────────────────────────
    wire detect;

    // Always valid (stable for TT + GL)
    wire valid = 1'b1;

    // ─────────────────────────
    // CFAR instance
    // ─────────────────────────
    cfar cfar_inst (
        .clk      (clk),
        .rst      (~rst_n),   // active-low → active-high
        .data_in  (ui_in),
        .valid_in (valid),
        .detect   (detect)
    );

    // ─────────────────────────
    // Registered output (important for GL)
    // ─────────────────────────
    reg [7:0] uo_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            uo_out_reg <= 8'b0;
        else
            uo_out_reg <= {7'b0, detect};
    end

    assign uo_out = uo_out_reg;

endmodule
