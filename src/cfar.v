`timescale 1ns/1ps
`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

reg [3:0] detect_hold;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect <= 0;
        detect_hold <= 0;
    end else if (valid_in) begin

        //  GUARANTEED spike detection
        if (data_in > 8'd100) begin
            detect <= 1;
            detect_hold <= 4'd10;
        end 

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
