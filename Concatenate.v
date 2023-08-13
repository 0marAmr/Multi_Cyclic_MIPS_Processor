module Concatenate(
input	wire	[1:0] 	in1,
input 	wire	[25:0] 	in2,
input	wire	[3:0]	in3,
output	wire	[31:0]	CAT_OUT
);

assign CAT_OUT = {in3,in2,in1};

endmodule
