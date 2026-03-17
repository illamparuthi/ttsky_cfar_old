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

```
wire detect;
wire buzzer_out;

// CFAR module (FIXED PORT NAMES)
cfar cfar_inst (
    .clk(clk),
    .rst_n(rst_n),
    .sample_in(ui_in),
    .detect(detect)
);

// Buzzer module (FIXED PORT NAMES)
buzzer buzzer_inst (
    .clk(clk),
    .rst(~rst_n),        // buzzer uses active HIGH reset
    .detect(detect),
    .buzzer_out(buzzer_out)
);

// OUTPUT MAPPING
assign uo_out[0] = detect;
assign uo_out[1] = buzzer_out;
assign uo_out[7:2] = 0;

assign uio_out = 0;
assign uio_oe  = 0;
```

endmodule
