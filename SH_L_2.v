module SH_L_2(
input 	wire	[31:0] in,
output	wire	[31:0] out
);

assign out = in<<'d2; 

endmodule
