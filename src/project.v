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

  // Tie off unused outputs
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Internal detect wire
  wire detect;

  cfar cfar_inst (
      .clk      (clk),
      .rst      (~rst_n),      // ← active-high rst from active-low rst_n
      .data_in  (ui_in),
      .valid_in (ena),         // or ui_in[7] or whatever your valid signal is
      .detect   (detect)
  );

  // Register the output to avoid X propagation
  reg [7:0] uo_out_reg;
  always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
          uo_out_reg <= 8'b0;   // ← clears X on reset
      else
          uo_out_reg <= {7'b0, detect};
  end

  assign uo_out = uo_out_reg;

endmodule
