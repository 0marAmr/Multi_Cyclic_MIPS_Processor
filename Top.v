module Top (
    input wire CLK, RST
);
    localparam ADDRESS_WIDTH = 32;
    localparam DATA_WIDTH = 32;


    wire [ADDRESS_WIDTH-1:0] Addr;
    wire [DATA_WIDTH-1:0] DATA, Reg2_Out;
    wire [1:0] RAM_SEL;
    RAM U0_RAM(
	.CLK(CLK),
	.RST(RST),
	.Data(Reg2_Out),
	.Addr(Addr),
	.W_EN(MEM_WS),
	.sel(RAM_SEL),
	.Output_Data(DATA)
	);

    Multi_Cyclic_MIPS MIPS(
	.CLK(CLK),
	.RST(RST),
    .Reg2_Out(Reg2_Out),
	.Addr(Addr),
	.DATA(DATA),
	.MEM_WS(MEM_WS),
    .RAM_SEL(RAM_SEL)
	);
endmodule