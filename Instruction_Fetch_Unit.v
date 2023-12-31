module Instruction_Fetch_Unit 
#(
    parameter   ADDRESS_WIDTH = 32,
                INSTR_WIDTH = 32,
                DATA_WIDTH = 32
)(
    input   wire                        CLK, RST,
    input   wire                        PC_LOAD, IorD, IR_EN, EPC_EN,EPC_SEL,
    input   wire [2:0]                  PC_SEL,
    input   wire [DATA_WIDTH-1:0]       ALU_OUT, ALU_REG_OUT, Reg1_Out,Reg2_Out,
    input   wire [ADDRESS_WIDTH-1:0]    RAM_OUT,                /*Instruction From RAM*/
    output  wire [ADDRESS_WIDTH-1:0]    Instr, 
    output  wire [ADDRESS_WIDTH-1:0]    Addr, PC_OUT, EPC_OUT
);

localparam NC = 0;
localparam START_ADDR = 32'h0040_0000;
/////////////////////////////////////////////////////////////////
//////////////////////// Program Counter ////////////////////////
/////////////////////////////////////////////////////////////////
wire [ADDRESS_WIDTH-1:0] PC_SEL_WIRE;

register_en #(
    .width(ADDRESS_WIDTH),
    .INIT_VAL(START_ADDR)
) PC (
    .CLK(CLK),
    .RST(RST),
    .data_in(PC_SEL_WIRE),
    .EN(PC_LOAD),
    .data_out(PC_OUT)
);

/* Memory Addressing from the program counter (PC_OUT)
 or from the last ALU the last ALU execution output. (ALU_OUT) */
mux_2_to_1 #(
    .WIDTH(ADDRESS_WIDTH)
) MUX1 (
    .sel(IorD), 
    .in0(PC_OUT), 
    .in1(ALU_REG_OUT),
    .out(Addr)      /*Addr is an input to the RAM in TOP module*/
    );    

///////////////////////////////////////////////////////////////////////
//////////////////////// Memory Instruction Reg ///////////////////////
///////////////////////////////////////////////////////////////////////

register_en #(
    .width(INSTR_WIDTH)
) MIR (
    .CLK(CLK),
    .RST(RST),
    .EN(IR_EN),
    .data_in(RAM_OUT),
    .data_out(Instr)
);


/////////////////////////////////////////////////////////////////////////
//////////////////////////// PC Next State Logic ////////////////////////
/////////////////////////////////////////////////////////////////////////

wire [ADDRESS_WIDTH-1:0] CAT_OUT;

Concatenate concat_block (
    .in1(2'b00), 
    .in2(Instr[25:0]), 
    .in3(PC_OUT[31:28]), 
    .CAT_OUT(CAT_OUT)
    );

mux_8_to_1 #(
    .WIDTH(ADDRESS_WIDTH)
) MUX10 (
    .sel(PC_SEL), 
    .in0(ALU_OUT), 
    .in1(ALU_REG_OUT),   
    .in2(CAT_OUT), 
    .in3(Reg1_Out), 
    .in4({ADDRESS_WIDTH{1'b0}}), 
    .in5(NC),  
    .in6(NC),	
    .in7(NC), 	
    .out(PC_SEL_WIRE)  
);

/////////////////////////////////////////////////////////////
/////////////////////// EPC Register ////////////////////////
/////////////////////////////////////////////////////////////
wire [DATA_WIDTH-1:0] EPC_IN;

register_en #(
    .width(ADDRESS_WIDTH)
) EPC (
    .CLK(CLK),
    .RST(RST),
    .EN(EPC_EN),
    .data_in(EPC_IN),
    .data_out(EPC_OUT)
);

mux_2_to_1 #(
    .WIDTH(ADDRESS_WIDTH)
) MUX11 (
    .sel(EPC_SEL), 
    .in0(PC_OUT), 
    .in1(Reg2_Out),	//rt data
    .out(EPC_IN)      
    );   

endmodule
