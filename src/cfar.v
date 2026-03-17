`default_nettype none
`default_nettype wire

module cfar (
input  wire       clk,
input  wire       rst_n,
input  wire [7:0] sample_in,
output reg        detect
);


reg [7:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10;

// shift register
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        w0<=0; w1<=0; w2<=0; w3<=0; w4<=0;
        w5<=0; w6<=0; w7<=0; w8<=0; w9<=0; w10<=0;
        detect<=0;
    end else begin
        w10<=w9;
        w9<=w8;
        w8<=w7;
        w7<=w6;
        w6<=w5;
        w5<=w4;
        w4<=w3;
        w3<=w2;
        w2<=w1;
        w1<=w0;
        w0<=sample_in;

        //  DIRECT DETECTION BOOST (fix)
        if (w0 > 8'd100 || w1 > 8'd100 || w2 > 8'd100)
    detect <= 1;
else
    detect <= 0;
    end
end


endmodule


