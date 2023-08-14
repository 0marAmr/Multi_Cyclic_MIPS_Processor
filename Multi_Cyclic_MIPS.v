module Multi_Cyclic_MIPS #(
	parameter	ADDRESS_WIDTH = 32,
				INSTR_DATA_WIDTH = 32
)(
    input wire CLK, RST,
	input wire [INSTR_DATA_WIDTH-1:0] DATA,
	output wire MEM_WS,
	output wire [1:0] RAM_SEL,
	output wire [ADDRESS_WIDTH-1:0] Addr,
	output wire [INSTR_DATA_WIDTH-1:0] Reg2_Out
);

	
/////////////////////////////////////////////////////////////////////
//////////////////////// Control Structures  ////////////////////////
/////////////////////////////////////////////////////////////////////

    Combinational_Block CB (
    	.NF_OUT(NF_OUT), 
    	.ZF_OUT(ZF_OUT), 
    	.PCWrite_BLTZ(PCWrite_BLTZ), 
    	.PCWrite_BGTZ(PCWrite_BGTZ), 
    	.PCWrite_BLEZ(PCWrite_BLEZ), 
    	.PCWrite_BNE(PCWrite_BNE), 
    	.PCWrite_BEQ(PCWrite_BEQ), 
    	.PC_EN(PC_EN), 
    	.PC_LOAD(PC_LOAD)
    );

	wire [1:0] Reg_Dest;
	wire [2:0] REG_DATA_SEL, PC_SEL, ALU_OP, ALU_SEL2, MEMtoREG;
	wire [INSTR_DATA_WIDTH-1:0] Instr;

    Sequence_Controller CONTROL_UNIT(
    	.Reg_Dest(Reg_Dest),
    	.IR_EN(IR_EN),
    	.REG_DATA_SEL(REG_DATA_SEL),
    	.MEM_WS(MEM_WS),
    	.MEM_OE(MEM_OE),
    	.RAM_SEL(RAM_SEL),
    	.IorD(IorD),
    	.PC_EN(PC_EN),
    	.PCWrite_BEQ(PCWrite_BEQ),
    	.PCWrite_BNE(PCWrite_BNE),
    	.PCWrite_BGTZ(PCWrite_BGTZ),
    	.PCWrite_BLTZ(PCWrite_BLTZ),
    	.PCWrite_BLEZ(PCWrite_BLEZ),
    	.OF_OUT(OF_OUT),
    	.BF_OUT(BF_OUT),
    	.Funct(Instr[5:0]),
    	.Opcode(Instr[31:26]),
    	.Rd(Instr[15:11]),
    	.CLK(CLK),
    	.RST(RST),
    	.CAUSE_EN(CAUSE_EN),
    	.EPC_EN(EPC_EN),
    	.PC_SEL(PC_SEL),
    	.CAUSE_SEL(CAUSE_SEL),
    	.ALU_OP(ALU_OP),
    	.ALU_SEL2(ALU_SEL2),
    	.ALU_SEL1(ALU_SEL1),
    	.SIGNEXT_SEL(SIGNEXT_SEL),
    	.MEMtoREG(MEMtoREG),
    	.REG_WS(REG_WS),
    	.REG_OE(REG_OE)
    	);

	wire [3:0] ALU_CONTROL;
    ALU_Controller ALU_CTRL(
		.Funct(Instr[5:0]),
		.ctrl(ALU_OP),
		.Out(ALU_CONTROL)
	);


/////////////////////////////////////////////////////////////////////////
//////////////////////// Instruction Fetch Unit  ////////////////////////
/////////////////////////////////////////////////////////////////////////

	wire [INSTR_DATA_WIDTH-1:0] ALU_OUT;
	wire [INSTR_DATA_WIDTH-1:0] ALU_REG_OUT;
	wire [INSTR_DATA_WIDTH-1:0] Reg1_Out;
	wire [ADDRESS_WIDTH-1:0] PC_OUT, EPC_OUT;
	Instruction_Fetch_Unit IFU(
		.CLK(CLK),
		.RST(RST),
		.PC_LOAD(PC_LOAD),
		.IorD(IorD),
		.IR_EN(IR_EN),
		.EPC_EN(EPC_EN),
		.PC_SEL(PC_SEL),
		.ALU_OUT(ALU_OUT),
		.ALU_REG_OUT(ALU_REG_OUT),
		.Reg1_Out(Reg1_Out),
		.RAM_OUT(DATA),
		.Instr(Instr),
		.Addr(Addr),
		.PC_OUT(PC_OUT),
		.EPC_OUT(EPC_OUT)
	);

///////////////////////////////////////////////////////////
//////////////////////// Data Path ///////////////////////
//////////////////////////////////////////////////////////
	DataPath DP(
		.CLK(CLK),
		.RST(RST),
		.DATA(DATA),
		.Reg2_Out(Reg2_Out),
		.Instr(Instr),
		.PC_OUT(PC_OUT),
		.EPC_OUT(EPC_OUT),
		.REG_DATA_SEL(REG_DATA_SEL),
		.MEMtoREG(MEMtoREG),
		.ALU_SEL2(ALU_SEL2),
		.Reg_Dest(Reg_Dest),
		.CAUSE_EN(CAUSE_EN),
		.REG_WS(REG_WS),
		.ALU_SEL1(ALU_SEL1),
		.CAUSE_SEL(CAUSE_SEL),
		.SIGNEXT_SEL(SIGNEXT_SEL),
		.ALU_CONTROL(ALU_CONTROL),
		.ALU_OUT(ALU_OUT),
		.ALU_REG_OUT(ALU_REG_OUT),
		.Reg1_Out(Reg1_Out),
		.OF_OUT(OF_OUT),
		.BF_OUT(BF_OUT),
		.NF_OUT(NF_OUT),
		.ZF_OUT(ZF_OUT)
	);
    
endmodule