module sign_extend_0 #(
    parameter   INPUT_WIDTH = 8,
                OUTPUT_WIDTH = 32
)(
input	wire	[INPUT_WIDTH-1: 0]		in,
output	wire	[OUTPUT_WIDTH-1: 0]		out_extend

);


localparam width = OUTPUT_WIDTH - INPUT_WIDTH;


assign out_extend [INPUT_WIDTH-1:0] = in;
assign out_extend [OUTPUT_WIDTH-1:INPUT_WIDTH] = {width{1'b0}};


endmodule
