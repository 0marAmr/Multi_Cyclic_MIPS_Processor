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
	wire	NF_OUT,ZF_OUT,PCWrite_BLTZ,PCWrite_BGTZ,PCWrite_BLEZ,PCWrite_BNE,PCWrite_BEQ,PC_EN,PC_LOAD;

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
	wire [1:0] CAUSE_SEL;
	wire EPC_SEL;
	wire [4:0] Rs;
	assign Rs = Instr[25:21] ; //RS[2]: third bit in RS 
	wire			EPC_EN,CAUSE_EN,IR_EN,REG_WS;
	wire       		IorD,ALU_SEL1,SIGNEXT_SEL;
	wire	[3:0]	ALU_CONTROL;
	wire			OF_OUT,BF_OUT;
	wire			hi_SEL,hi_EN,lo_SEL,lo_EN;
	


    Sequence_Controller CONTROL_UNIT(
    	.Reg_Dest(Reg_Dest),
    	.IR_EN(IR_EN),
    	.REG_DATA_SEL(REG_DATA_SEL),
    	.MEM_WS(MEM_WS),
    	.RAM_SEL(RAM_SEL),
    	.IorD(IorD),
    	.PC_EN(PC_EN),
    	.Rs(Rs),
    	.hi_SEL(hi_SEL),
    	.lo_SEL(lo_SEL),
    	.hi_EN(hi_EN),
    	.lo_EN(lo_EN),
		.mult_start(mult_start),
		.div_start(div_start),
		.mult_div_done(mult_div_done),
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
    	.EPC_SEL(EPC_SEL),
    	.CAUSE_SEL(CAUSE_SEL),
    	.ALU_OP(ALU_OP),
    	.ALU_SEL2(ALU_SEL2),
    	.ALU_SEL1(ALU_SEL1),
    	.SIGNEXT_SEL(SIGNEXT_SEL),
    	.MEMtoREG(MEMtoREG),
    	.REG_WS(REG_WS)
    	);

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
		.EPC_SEL(EPC_SEL),
		.ALU_OUT(ALU_OUT),
		.ALU_REG_OUT(ALU_REG_OUT),
		.Reg1_Out(Reg1_Out),
		.Reg2_Out(Reg2_Out),
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
    	.hi_SEL(hi_SEL),
    	.lo_SEL(lo_SEL),
    	.hi_EN(hi_EN),
    	.lo_EN(lo_EN),
		.mult_start(mult_start),
		.div_start(div_start),
		.mult_div_done(mult_div_done),
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