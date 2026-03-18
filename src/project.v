module tt_um_ilamparuthi_cfar (
    input  [7:0] ui_in,    // Dedicated inputs
    output [7:0] uo_out,   // Dedicated outputs
    input  [7:0] uio_in,   // IOs: Input path
    output [7:0] uio_out,  // IOs: Output path
    output [7:0] uio_oe,   // IOs: Output enable
    input clk,             // Clock
    input rst_n            // Active low reset
);

// --------------------------------------------------
// CFAR Core Instance
// --------------------------------------------------
wire detect;

cfar_core cfar_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(ui_in),
    .detect(detect)
);

// --------------------------------------------------
// Output mapping
// --------------------------------------------------
assign uo_out[0] = detect;
assign uo_out[7:1] = 7'b0;

// --------------------------------------------------
// Unused IOs
// --------------------------------------------------
assign uio_out = 8'b0;
assign uio_oe  = 8'b0;

endmodule
