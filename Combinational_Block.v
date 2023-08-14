module Combinational_Block(
input	wire	NF_OUT,ZF_OUT,
input	wire	PCWrite_BLTZ,PCWrite_BGTZ,PCWrite_BLEZ,PCWrite_BNE,PCWrite_BEQ,
input	wire	PC_EN,
output	wire	PC_LOAD
);

wire w1,w2,w3,w4,w5,w6;

assign w1= NF_OUT & PCWrite_BLTZ;
assign w2= NF_OUT | ZF_OUT;
assign w3= (~w2) & PCWrite_BGTZ;
assign w4= w2 & PCWrite_BLEZ;
assign w5= (~ZF_OUT) & PCWrite_BNE;
assign w6= ZF_OUT & PCWrite_BEQ;

assign PC_LOAD = w1 | w3 | w4 | w5 | w6 | PC_EN;

endmodule
