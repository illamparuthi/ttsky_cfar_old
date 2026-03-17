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
wire buzzer_out;

// IMPORTANT: gate input with ena (GL-safe)
wire [7:0] data_in = ena ? ui_in : 8'b0;

cfar cfar_inst (
    .clk(clk),
    .rst_n(rst_n),
    .sample_in(data_in),
    .detect(detect)
);

buzzer buzzer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .trigger(detect),
    .out(buzzer_out)
);

// Outputs
assign uo_out[0] = detect;
assign uo_out[1] = buzzer_out;
assign uo_out[7:2] = 6'b0;   // REQUIRED

// Unused IOs (REQUIRED for TT)
assign uio_out = 8'b0;
assign uio_oe  = 8'b0;


endmodule
