module DataPath #(
    parameter   INSTR_WIDTH = 32,
                DATA_WIDTH = 32,
                ADDRESS_WIDTH = 32
)(
input	wire			CLK,
input	wire			RST,
input   wire [DATA_WIDTH-1: 0]      DATA,  
input   wire [INSTR_WIDTH-1: 0]     Instr,
input   wire [ADDRESS_WIDTH-1: 0]   PC_OUT, EPC_OUT,

/*Control Signals*/
input	wire    [2:0]	REG_DATA_SEL, MEMtoREG, ALU_SEL2,	
input	wire 	[1:0] 	Reg_Dest,
input 	wire			CAUSE_EN, REG_WS,
input	wire       		ALU_SEL1,CAUSE_SEL,SIGNEXT_SEL,
input 	wire	[3:0]	ALU_CONTROL,

output wire     [DATA_WIDTH-1:0] ALU_OUT, ALU_REG_OUT, Reg1_Out, Reg2_Out, 
//outputs -->> control unit inputs
output	wire		OF_OUT,BF_OUT,
//outputs -->> Combinational Blcok outputs
output  wire        NF_OUT, ZF_OUT


);

localparam NC                  =  0;
localparam BYTE                =  8;
localparam HALF_WORD           =  16;
localparam REG_FILE_ADDR_WIDTH =  5;

///////////////////////////////////////////////////////////////////
///////////////////// Reg File Write Data Logic ///////////////////
///////////////////////////////////////////////////////////////////


/************ MDR reg ************/

	wire [DATA_WIDTH-1: 0] MDR_DATA;	

	register #(.width('d32)) MDR (
		 .CLK(CLK), 
		 .RST(RST), 
		 .data_in(DATA), 
		 .data_out(MDR_DATA)
		 );

/************ Byte sign extend ***********/
    wire [DATA_WIDTH-1: 0] EBZ1_Out;

    sign_extend_0 #(
        .INPUT_WIDTH(BYTE),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EXT_0_BYTE_MUX3 (
        .in(MDR_DATA[BYTE-1:0]), 
        .out_extend(EBZ1_Out)
    );

    wire [DATA_WIDTH-1: 0] EB2_Out;

    sign_extend #(
        .INPUT_WIDTH(BYTE),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EX_BYTE_MUX3 (
        .in(MDR_DATA[BYTE-1:0]), 
        .out_extend(EB2_Out)
    );	

/************ Half Word sign extend ***********/
    wire [DATA_WIDTH-1: 0] EWZ1_Out;

    sign_extend_0 #(
        .INPUT_WIDTH(HALF_WORD),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EXT_0_HALF_WORD_MUX3 (
        .in(MDR_DATA[HALF_WORD-1:0]), 
        .out_extend(EWZ1_Out)
        );

    wire [DATA_WIDTH-1: 0] EW2_Out;

    sign_extend #(
        .INPUT_WIDTH(HALF_WORD),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EX_HALF_WORD_MUX3 (
        .in(MDR_DATA[HALF_WORD-1:0]), 
        .out_extend(EW2_Out)
    );	


/************ Sign extension multiplexter ************/
    wire [DATA_WIDTH-1: 0] DATA_WIRE;

    mux_8_to_1 #(
        .WIDTH(DATA_WIDTH)
    ) MUX3 (
        .sel(REG_DATA_SEL), 
        .in0(MDR_DATA), 
        .in1(EBZ1_Out), 
        .in2(EB2_Out), 
        .in3(EWZ1_Out), 
        .in4(EW2_Out), 
        .in5(NC),
        .in6(NC),	
        .in7(NC), 	
        .out(DATA_WIRE)  
    );

/************ Register File Write Data Multipexer ************/
    wire [DATA_WIDTH-1: 0] CAUSE_OUT;
    wire [DATA_WIDTH-1: 0] Reg_Write_Data;
  //  wire [DATA_WIDTH-1: 0] ALU_OUT; //commentted

    mux_8_to_1 #(
        .WIDTH(DATA_WIDTH)
    ) MUX5 (
        .sel(MEMtoREG), 
        .in0(ALU_REG_OUT),  //edited
        .in1(Instr), 
        .in2(EPC_OUT), 
        .in3(CAUSE_OUT), 
        .in4(DATA_WIRE), 
        .in5(PC_OUT), 
        .in6(NC), 
        .in7(NC), 
        .out(Reg_Write_Data)
    );

/************ Register File Write Register Address Multipexer ************/
    wire [REG_FILE_ADDR_WIDTH-1: 0] Dest_Addr;
    mux_4_to_1 #(
        .WIDTH(REG_FILE_ADDR_WIDTH)
    ) MUX4 (
        .sel(Reg_Dest), 
        .in0(Instr[20:16]), 
        .in1(Instr[15:11]), 
        .in2(5'd31), 
        .in3(5'd0), //NC 
        .out(Dest_Addr)
    );

///////////////////////////////////////////////////////////////////////
///////////////////// Register File  and Output Regs///////////////////
///////////////////////////////////////////////////////////////////////
    wire [DATA_WIDTH-1: 0] Reg1_Data;
    wire [DATA_WIDTH-1: 0] Reg2_Data;

    REG_FILE #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(5)
    ) REGISTER_FILE (
        .CLK(CLK), 
        .RST(RST), 
        .Reg1(Instr[25:21]), 
        .Reg2(Instr[20:16]), 
        .Write_Reg(Dest_Addr), 
        .Write_Data(Reg_Write_Data), 
        .Write(REG_WS), 
        .Reg1_Data(Reg1_Data), 
        .Reg2_Data(Reg2_Data)
    );	

 //   wire [DATA_WIDTH-1: 0] Reg1_Out; ///commentted
  //  wire [DATA_WIDTH-1: 0] Reg2_Out;

    register #(
        .width('d32)
    ) Reg1 (
        .CLK(CLK), 
        .RST(RST), 
        .data_in(Reg1_Data), 
        .data_out(Reg1_Out)
    );

    register #(
        .width('d32)
    ) Reg2 (
        .CLK(CLK), 
        .RST(RST), 
        .data_in(Reg2_Data), 
        .data_out(Reg2_Out)
    );

//////////////////////////////////////////////////////////////
///////////////////////// ALU Operands ///////////////////////
//////////////////////////////////////////////////////////////

/************ Operand 2************/
   wire [DATA_WIDTH-1: 0] EWZ2_Out;

    sign_extend_0 #(
        .INPUT_WIDTH(HALF_WORD),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EXT_0_HALF_WORD_MUX6 (
        .in(Instr[HALF_WORD-1:0]), 
        .out_extend(EWZ2_Out)
        );

    wire [DATA_WIDTH-1: 0] EW3_Out;

    sign_extend #(
        .INPUT_WIDTH(HALF_WORD),
        .OUTPUT_WIDTH(DATA_WIDTH)
    ) S_EX_MUX6 (
        .in(Instr[HALF_WORD-1:0]), 
        .out_extend(EW3_Out)
    );	

    wire [INSTR_WIDTH-1: 0] Immediate_Out;
    mux_2_to_1 #(
        .WIDTH(INSTR_WIDTH)
    ) MUX6 (
    .sel(SIGNEXT_SEL), 
    .in0(EW3_Out), 
    .in1(EWZ2_Out), 
    .out(Immediate_Out)
    );	

    wire [INSTR_WIDTH-1: 0] Immediate_SL;
    SH_L_2 Shift_Left_2 (
    .in(Immediate_Out), 
    .out(Immediate_SL)
    );	

    wire [DATA_WIDTH-1: 0] ALU_OPR2;
    mux_8_to_1 #(
        .WIDTH(DATA_WIDTH)
    ) MUX8 (
        .sel(ALU_SEL2), 
        .in0(Reg2_Out), 
        .in1('d4),  /// هم عاملينها 1
        .in2(Immediate_Out), 
        .in3(Immediate_SL), 
        .in4('d0), 
        .in5(NC), //NC
        .in6(NC),	//NC
        .in7(NC), 	//NC
        .out(ALU_OPR2) 
    );

/************ Operand 1 ************/
    
    wire [DATA_WIDTH-1: 0] ALU_OPR1;
    mux_2_to_1 #(
        .WIDTH(DATA_WIDTH)
    ) MUX7 (
        .sel(ALU_SEL1), 
        .in0(PC_OUT), 
        .in1(Reg1_Out), 
        .out(ALU_OPR1)
    );	

///////////////////////////////////////////////////////////////
///////////////////////// ALU & ALU REG ///////////////////////
///////////////////////////////////////////////////////////////

    Arithmatic_Logic_Unit #(
        .OPERAND_WIDTH(DATA_WIDTH)
    ) ALU (
        .Operand1(ALU_OPR1), 
        .Operand2(ALU_OPR2), 
        .Cntrl(ALU_CONTROL), 
        .Shamt(Instr[10:6]), 
        .ALU_OUT(ALU_OUT), 
        .NF_OUT(NF_OUT), 
        .ZF_OUT(ZF_OUT), 
        .OF_OUT(OF_OUT), 
        .BF_OUT(BF_OUT)
        );	

    register #(
        .width(DATA_WIDTH)
    ) ALU_Register (
        .CLK(CLK), 
        .RST(RST), 
        .data_in(ALU_OUT), 
        .data_out(ALU_REG_OUT)
    );

/////////////////////////////////////////////////////////////
///////////////////// Exception Cause ///////////////////////
/////////////////////////////////////////////////////////////

    wire [DATA_WIDTH-1: 0] CAUSE_DATA;
    mux_2_to_1 #(
        .WIDTH(DATA_WIDTH)
    ) MUX9 (
        .sel(CAUSE_SEL), 
        .in0('d0), 
        .in1('d1), 
        .out(CAUSE_DATA)
    );	

    register_en #(
        .width(DATA_WIDTH)
    ) CAUSE (
        .CLK(CLK), 
        .RST(RST), 
        .EN(CAUSE_EN),
        .data_in(CAUSE_DATA), 
        .data_out(CAUSE_OUT)
    );	


endmodule
