`default_nettype none
`default_nettype wire

module cfar (
input  wire       clk,
input  wire       rst_n,
input  wire [7:0] sample_in,
output reg        detect
);


reg [7:0] w0, w1, w2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        w0 <= 0;
        w1 <= 0;
        w2 <= 0;
        detect <= 0;
    end else begin
        // small window (fast response)
        w2 <= w1;
        w1 <= w0;
        w0 <= sample_in;

        // robust detection (GL-safe)
        if (w0 > 8'd100 || w1 > 8'd100 || w2 > 8'd100)
            detect <= 1;
        else
            detect <= 0;
    end
end


endmodule


