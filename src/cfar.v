`timescale 1ns/1ps
`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// Shift registers (still keep CFAR structure)
reg [7:0] w0, w1, w2;

// Hold detection
reg [3:0] detect_hold;

// Shift logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        w0 <= 0;
        w1 <= 0;
        w2 <= 0;
    end else if (valid_in) begin
        w2 <= w1;
        w1 <= w0;
        w0 <= data_in;
    end
end

// Detection logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect <= 0;
        detect_hold <= 0;
    end else if (valid_in) begin

        // DIRECT SPIKE DETECTION (key fix)
        if (data_in > 8'd50) begin
            detect <= 1;
            detect_hold <= 4'd10;
        end 

        // Hold detection
        else if (detect_hold != 0) begin
            detect_hold <= detect_hold - 1;
            detect <= 1;
        end 

        else begin
            detect <= 0;
        end
    end
end

endmodule
