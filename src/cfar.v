`default_nettype none

`default_nettype wire

module cfar (
input  wire       clk,
input  wire       rst_n,
input  wire [7:0] sample_in,
output reg        detect
);


reg [7:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10;

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

        detect <= (w5 > threshold);
    end
end

// FIXED WIDTH
wire [11:0] sum =
      {4'b0,w0}+{4'b0,w1}+{4'b0,w2}+{4'b0,w3}+
      {4'b0,w7}+{4'b0,w8}+{4'b0,w9}+{4'b0,w10};

wire [7:0] avg = sum >> 3;

// 1.5 × avg (safe threshold)
wire [7:0] threshold = avg + (avg >> 1);


endmodule

