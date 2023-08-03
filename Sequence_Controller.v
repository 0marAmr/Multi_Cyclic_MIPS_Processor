module Sequence_Controller(
	input 				OF_OUT,BF_OUT,		//‘OF_OUT’ and ‘BF_OUT’ are direct outputs of the ALU and indicate when a processor exception has occurred. 
											//OF_OUT is set true when an arithmetic overflow has occurred. BF_OUT is set true when an invalid operation is detected
	input 	[5:0] 		Funct,Opcode,		// opcode :determines the instruction type once it is fetched
	input 	[4:0] 		Rd,
	input 				CLK,
	input				RST,
	
	output 	reg 		PC_EN,				//Enables writing to the Program Counter
	output 	reg [2:0] 	PC_SEL,				//Determines the data source for the Program Counter
	output 	reg			IorD,				//Determines the address source for memory 
	output 	reg	[1:0]	MEM_DATA_SEL,		//Determines the source of data to be written to memory
	output 	reg			MEM_OE,				//Enables reads from memory
	output 	reg			MEM_WS,				//Enables writes to memory
	output 	reg	[2:0]	REG_DATA_SEL,		//Determines the source of data to be written to the Instruction Register (IR)
	output 	reg			IR_EN,				//Enables writes to the IR
	output	reg	[1:0]	Reg_Dest,			//Determines the address of a register in Register File to be written to
	output	reg [2:0]	MEMtoREG,			//Determines the source of data to be written to the Register File
	output	reg			REG_OE,				//Enables reads from the Resister File
	output	reg			REG_WS,				//Enables writes to the register file
	output	reg			SIGNEXT_SEL,		//Selects between immediate data sign extended with 0’s,
											//  in the case of an unsigned operation, and data sign extended with the MSB, which is used for signed operations
	output	reg			ALU_SEL1,			//Selects the ALU data source for the first operand 
	output	reg	[2:0]	ALU_SEL2,			//Selects the ALU data source for the second operand
	output	reg	[2:0]	ALU_OP,				//Determines the operation to be performed by the ALU
	output	reg			EPC_EN,				//Enables writes to the EPC register	
	output	reg			CAUSE_SEL,			//Determines whether the Cause register will be loaded with 0 or 1
	output	reg			CAUSE_EN,			//Enables writes to the Cause register
	output	reg			PCWrite_BEQ,		//Enables ‘branch if equal’ operation 
	output	reg			PCWrite_BNE,		//Enables ‘branch if not equal’ operation
	output	reg			PCWrite_BGTZ,		//Enables ‘branch if greater than zero’ operation
	output	reg			PCWrite_BLTZ,		//Enables ‘branch if less than zero’ operation
	output	reg			PCWrite_BLEZ		//Enables ‘branch if less than or equal to zero’ operation
);

/*  states	*/
localparam		[5:0]	State0='d0,
						State1='d1,
						State2='d2,
						State3='d3,
						State4='d4,
						State5='d5,
						State6='d6,
						State7='d7,
						State8='d8,
						State9='d9,
						State10='d10,
						State11='d11,
						State12='d12,
						State13='d13,
						State14='d14,
						State15='d15,
						State16='d16,
						State17='d17,
						State18='d18,
						State19='d19,
						State20='d20,
						State21='d21,
						State22='d22,
						State23='d23,
						State24='d24,
						State25='d25,
						State26='d26,
						State27='d27,
						State28='d28,
						State29='d29,
						State30='d30,
						State31='d31,
						State32='d32,
						State33='d33,
						State34='d34,
						State35='d35,
						State36='d36;
						
						
reg [5:0] current_state,next_state;
			
						
/*state transition*/
always@(posedge CLK,negedge RST) begin
	if(!RST)
		current_state	<=	State0;
	else
		current_state	<=	next_state;
end



/*	Next State logic	*/
always@(*) begin

case(current_state) 

	State0	: 	begin			// FETCH
			MEM_OE = 1;
			IorD = 0;
			IR_EN = 1;
			REG_DATA_SEL = 'b000;
			REG_OE = 1;
			ALU_SEL1 = 0;
			ALU_SEL2 = 'b001;
			ALU_OP = 'b000;
			PC_SEL = 'b000;
			PC_EN = 1;
			next_state = State1;
	end
	
	State1	:	begin			// DECODE
			MEM_OE = 0;
			SIGNEXT_SEL = 0;
			ALU_SEL1 = 0;
			ALU_SEL2 = 'b011;
			ALU_OP = 'b000;
			IR_EN=0;
			PC_EN=0;
			
			case(Opcode)
					'b000010	:	begin			//J
						next_state = State2;
					end
					'b000011	:	begin			//JAL
						next_state = State3; 
					end
					'b001101	:	begin			//ori
						next_state = State15; 
					end
					'b001110	:	begin			//xori
						next_state = State16; 
					end
					'b000100	:	begin			//beq
						next_state = State9; 
					end
					'b000101	:	begin			//bne
						next_state = State10; 
					end
					'b001011	:	begin			//SLTiu
						next_state = State28; 
					end
					'b001001	:	begin			//ADDiu
						next_state = State29; 
					end
					'b010000	:	begin			//MFC0
						if(Rd=='b01101)
							next_state = State33;
						else if(Rd=='b01110)
							next_state = State32;
						else						//various I type
							next_state = State7;
					end
					'b000001	:	begin			//BLTZ
						next_state = State13; 
					end
					'b000111	:	begin			//BGTZ
						next_state = State12; 
					end
					
					'b000000	:	begin			//R type
						if(Funct=='b001001)
							next_state = State21;	//JALR
						else if(Funct=='b001000)
							next_state = State20;
						else
							next_state = State4;
					end
					
					'b000110	:	begin			//BLEZ
						next_state = State11; 
					end
					'b000110	:	begin			//ANDi
						next_state = State14; 
					end
					'b001010	:	begin			//SLTi
						next_state = State6; 
					end
					
					default		:	begin		//various I type
						next_state = State7;
					end
					
					
			endcase
		end
	
	State2	:	begin
			PC_EN = 1;
			PC_SEL = 'b010;
			next_state = State0;
	end
	
	State3	:	begin
			MEMtoREG = 'b101;
			Reg_Dest ='b10;
			next_state = State36;
	end
	State4 :  begin
			ALU_SEL1=1;
			ALU_SEL2=3'b000;
			ALU_OP=3'b010;
			Reg_Dest=2'b01;
			MEMtoREG='b000;
			if(BF_OUT==1)begin
				next_state=State31;
			end
			else if(BF_OUT==0&&OF_OUT==1&&Funct[0]==1)
			begin
				next_state=State30;
			end
			else begin
				next_state=State5;
			end
	end

	State5 : begin
		REG_WS=1;
		next_state=State0;
	end

	State6:  begin
		ALU_SEL1=1;
		ALU_SEL2='b010;
		ALU_OP='b011;
		SIGNEXT_SEL=0;
		Reg_Dest='b00;
		MEMtoREG='b000;
		next_state=State8;

	end

	State7:  begin
		ALU_SEL1=1;
		ALU_SEL2='b010;
		ALU_OP='b000;
		SIGNEXT_SEL=0;
		Reg_Dest='b00;
		MEMtoREG='b000;
		case(Opcode)
		6'b101001: next_state= State27;   //SH 
		6'b101000: next_state= State26;   //SB
		6'b100101: next_state= State24;   //LHu
		6'b100000: next_state= State23;   //LB
		6'b100011: next_state= State18;   //LW
		6'b101011: next_state= State17;   //SW
		6'b100001: next_state= State25;   //LH
		6'b100100: next_state= State22;   //LBu
		6'b001000:begin
			if(OF_OUT==1)
				next_state=State30;  
				else
					next_state=State8;
		end

		endcase

	end

	State8: begin
		REG_WS=1;
		next_state=State0;

	end

	State9	:	begin
		ALU_SEL1 = 1;
		ALU_SEL2 ='b000;
		ALU_OP = 'b001;
		next_state = State0;
		PCWrite_BEQ = 1;
		PC_SEL = 'b001;
	
	end

	State10: begin
		ALU_SEL1=1;
		ALU_SEL2='b000;
		ALU_OP='b001;
		PCWrite_BNE=1;
		PC_SEL='b001;
		next_state=State0;
	end

	State11: begin
		ALU_SEL1=1;
		ALU_SEL2='b100;
		ALU_OP='b001;
		PCWrite_BLEZ=1;
		PC_SEL='b001;
		next_state=State0;
	end

	State12: begin
		ALU_SEL1=1;
		ALU_SEL2='b100;
		ALU_OP='b001;
		PCWrite_BGTZ=1;
		PC_SEL='b001;
		next_state=State0;
	end

	State13: begin
		ALU_SEL1=1;
		ALU_SEL2='b100;
		ALU_OP='b001;
		PCWrite_BLTZ=1;
		PC_SEL='b001;
		next_state=State0;
	end

	State14: begin
		ALU_SEL1=1;
		ALU_SEL2='b010;
		ALU_OP='b100;
		SIGNEXT_SEL=0;
		Reg_Dest='b00;
		MEMtoREG='b000;
		next_state=State8;
	end


	State15	:	begin
		ALU_SEL1 = 1;
		ALU_SEL2 ='b010;
		ALU_OP = 'b101;
		next_state = State8;
		SIGNEXT_SEL =0;
		Reg_Dest='b00;
		MEMtoREG = 'b000;
	
	end

	State16	:	begin
		ALU_SEL1 = 1;
		ALU_SEL2 ='b010;
		ALU_OP = 'b110;
		next_state = State8;
		SIGNEXT_SEL =0;
		Reg_Dest='b00;
		MEMtoREG = 'b000;
	
	end



	default	:	begin		//invalid opcode
		next_state = State31;
	end


endcase

end












endmodule