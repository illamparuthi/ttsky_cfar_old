
`default_nettype none
`default_nettype wire


module cfar (
input  wire       clk,
input  wire       rst_n,
input  wire [7:0] sample_in,
output reg        detect
);


// Small window for fast response
reg [7:0] w0, w1, w2;

// Hold register to stretch detection
reg [2:0] detect_hold;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        w0 <= 0;
        w1 <= 0;
        w2 <= 0;
        detect <= 0;
        detect_hold <= 0;
    end else begin
        // Shift window
        w2 <= w1;
        w1 <= w0;
        w0 <= sample_in;

        // Detection condition (threshold-based)
        if (w0 > 8'd100 || w1 > 8'd100 || w2 > 8'd100)
            detect_hold <= 3'd4;   // hold for 4 cycles
        else if (detect_hold > 0)
            detect_hold <= detect_hold - 1;

        // Output
        detect <= (detect_hold > 0);
    end
end


endmodule

