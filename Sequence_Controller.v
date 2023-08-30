module Sequence_Controller(
	input 				OF_OUT,BF_OUT,		//‘OF_OUT’ and ‘BF_OUT’ are direct outputs of the ALU and indicate when a processor exception has occurred. 
											//OF_OUT is set true when an arithmetic overflow has occurred. BF_OUT is set true when an invalid operation is detected
	input 	[5:0] 		Funct,Opcode,		// opcode :determines the instruction type once it is fetched
	input 	[4:0] 		Rd,Rs,
	input 				CLK,
	input				RST,mult_div_done,
	output	reg			hi_SEL,hi_EN,lo_SEL,lo_EN,
	output 	reg 		PC_EN,				//Enables writing to the Program Counter
	output 	reg [2:0] 	PC_SEL,				//Determines the data source for the Program Counter
	output 	reg			IorD,				//Determines the address source for memory 
	output 	reg			MEM_WS,				//Enables writes to memory
	output 	reg	[2:0]	REG_DATA_SEL,		//Determines the source of data to be written to the Instruction Register (IR)
	output 	reg			IR_EN,				//Enables writes to the IR
	output	reg	[1:0]	Reg_Dest,			//Determines the address of a register in Register File to be written to
	output	reg [2:0]	MEMtoREG,			//Determines the source of data to be written to the Register File
	output	reg			REG_WS,				//Enables writes to the register file
	output	reg			SIGNEXT_SEL,		//Selects between immediate data sign extended with 0’s,
											//  in the case of an unsigned operation, and data sign extended with the MSB, which is used for signed operations
	output	reg			ALU_SEL1,			//Selects the ALU data source for the first operand 
	output	reg	[2:0]	ALU_SEL2,			//Selects the ALU data source for the second operand
	output	reg	[2:0]	ALU_OP,				//Determines the operation to be performed by the ALU
	output	reg			EPC_SEL,EPC_EN,		//Enables writes to the EPC register	
	output	reg	[1:0]	CAUSE_SEL,			//Determines whether the Cause register will be loaded with 0 or 1
	output	reg			CAUSE_EN,			//Enables writes to the Cause register
	output	reg			PCWrite_BEQ,		//Enables ‘branch if equal’ operation 
	output	reg			PCWrite_BNE,		//Enables ‘branch if not equal’ operation
	output	reg			PCWrite_BGTZ,		//Enables ‘branch if greater than zero’ operation
	output	reg			PCWrite_BLTZ,		//Enables ‘branch if less than zero’ operation
	output	reg			PCWrite_BLEZ,		//Enables ‘branch if less than or equal to zero’ operation
	output	reg	[1:0]	RAM_SEL	,			//to choose whether to store a word, half-word or a byte in memory
	output	reg			mult_start,div_start
);



	/*	states	*/
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
							State36='d36,
							State37='d37;

	///////////////////////different op code parameters //////////////////////////

	localparam 		[5:0]	OP_J      = 6'b000010,
							OP_JAL	  = 6'b000011,
							OP_R_TYPE = 6'b000000,
							OP_M_F_T_C0   = 6'b010000,
							OP_BLTZ   = 6'b000001,
							OP_BEQ 	  = 6'b000100,
							OP_BNE    = 6'b000101,
							OP_BLEZ   = 6'b000110,
							OP_BGTZ   = 6'b000111,
							OP_ADDi   = 6'b001000,
							OP_ADDiu  = 6'b001001,
							OP_SLTiu  = 6'b001011,
							OP_SLTi   = 6'b001010,
							OP_ANDi   = 6'b001100,
							OP_ORi    = 6'b001101,
							OP_XORI   = 6'b001110,
							OP_LW     = 6'b100011,
							OP_LBU    = 6'b100100,
							OP_LB     = 6'b100000,
							OP_LHu    = 6'b100101,
							OP_LH     = 6'b100001,
							OP_SB     = 6'b101000,
							OP_SH     = 6'b101001,
							OP_SW     = 6'b101011,
							OP_MUL    = 6'b011100;

	localparam      [1:0] 	WW=2'b00, 		//mem wrire word
							WH=2'b01, 		//mem write half-word
							WB=2'b10;		//mem wrirte byte				

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
	//default values
	PC_EN			= 'd0;				
	PC_SEL          = 'd0;	
	IorD			= 'd1;
	MEM_WS			= 'd0;
	REG_DATA_SEL	= 'd0;	
	IR_EN			= 'd0;	
	Reg_Dest		= 'd0;	
	MEMtoREG		= 'd0;	
	REG_WS			= 'd0;
	SIGNEXT_SEL		= 'd0;										
	ALU_SEL1		= 'd0;	 
	ALU_SEL2		= 'd0;	
	ALU_OP			= 'd0;
	EPC_EN			= 'd0;
	EPC_SEL			= 'd0;
	CAUSE_SEL		= 'd0;	
	CAUSE_EN		= 'd0;	
	PCWrite_BEQ		= 'd0;
	PCWrite_BNE		= 'd0;
	PCWrite_BGTZ	= 'd0;	
	PCWrite_BLTZ	= 'd0;	
	PCWrite_BLEZ    = 'd0;
	RAM_SEL			= 'd0;
	next_state		= State0;
	hi_SEL			= 'd0;
	hi_EN 			= 'd0;
	lo_SEL			= 'd0;
	lo_EN 			= 'd0;	
	mult_start		= 'd0;
	div_start		= 'd0;
	case(current_state) 
		State0	: 	begin			// FETCH
				IorD = 0;
				IR_EN = 1;
			//	REG_DATA_SEL = 'b000;
				ALU_SEL1 = 0;
				ALU_SEL2 = 'b001;
				ALU_OP = 'b000;
				PC_SEL = 'b000;
				PC_EN = 1;
				next_state = State1;
		end
		
		State1	:	begin			// DECODE
				SIGNEXT_SEL = 0;
				ALU_SEL1 = 0;
				ALU_SEL2 = 'b011;
				ALU_OP = 'b000;
				IR_EN=0;
				PC_EN=0;
				
				case(Opcode)
						OP_J	:	begin			//J
							next_state = State2;
						end
						OP_JAL	:	begin			//JAL
							next_state = State3; 
						end
						OP_ORi	:	begin			//ori
							next_state = State15; 
						end
						OP_XORI	:	begin			//xori
							next_state = State16; 
						end
						OP_BEQ	:	begin			//beq
							next_state = State9; 
						end
						OP_BNE	:	begin			//bne
							next_state = State10; 
						end
						OP_SLTiu	:	begin			//SLTiu
							next_state = State28; 
						end
						OP_ADDi	:	begin			//ADDiu
							next_state = State29; 
						end
						OP_M_F_T_C0	:	begin			//MFC0_MTC0
							if(Rs=='d4 && (Rd=='b01101 || Rd=='b01110))begin 			//MTC0 -->> CAUSE OR EPC, SINCE THEY ARE THE ONLY CO-PROCESSOR_0 REGISTERS EXISTING 
								next_state = State34;
							end
							else if(Rs=='d0 && (Rd=='b01101 || Rd=='b01110))begin			//MFC0
								next_state = State32;
							end
							else begin						
								next_state = State0;  //invalid///////////////////////////////////////////
							end
						end
						OP_BLTZ	:	begin			//BLTZ
							next_state = State13; 
						end
						OP_BGTZ	:	begin			//BGTZ
							next_state = State12; 
						end
						
						OP_R_TYPE	:	begin			//R type
							case(Funct)
								'b001001:	begin
									next_state = State21;	//JALR
								end
								'b001000:	begin
									next_state = State20;   //JR
								end
								'b010000:	begin			//mfhi
									Reg_Dest=2'b01;
									MEMtoREG='b110; 
									REG_WS=1;
									next_state = State0;  //fetch
								end
								'b010001:	begin			//mthi
									hi_SEL = 'd0;
									hi_EN = 'd1;
									next_state = State0;  //fetch
								end
								'b010010:	begin		  //mflo
									Reg_Dest=2'b01;
									MEMtoREG='b111; 
									REG_WS=1;
									next_state = State0;  //fetch

								end
								'b010011:	begin		  //mtlo
									lo_SEL = 'd0;
									lo_EN = 'd1;
									next_state = State0;  //fetch
								end
								'b011000:	begin	//mult	  
									next_state = State36;
									mult_start='d1;
								end
								'b011010:	begin	//div	  
									next_state = State36;
									div_start='d1;
								end								
								default:	begin
									next_state = State4;   //other R-type
								end
								
							endcase

						end
						
						OP_BLEZ	:	begin			//BLEZ
							next_state = State11; 
						end
						OP_ANDi	:	begin			//ANDi
							next_state = State14; 
						end
						OP_SLTi	:	begin			//SLTi
							next_state = State6; 
						end
						OP_MUL	:	begin			//MUL
							if(Funct=='d2)begin
								next_state = State33;
								mult_start='d1;
							end
							else begin
								next_state = State0;  //invalid instruction
								mult_start='d0;
							end
						end
						default		:	begin		//invalid instaruction or unconsidered one////////////////////////////////////////////
							next_state = State0;
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
				PC_EN = 1;
				PC_SEL = 'b010;
				REG_WS = 1;
				next_state = State0; //fetch
		end
		State4 :  begin
				ALU_SEL1=1;
				ALU_SEL2=3'b000;
				ALU_OP=3'b010;
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
				Reg_Dest=2'b01;
				MEMtoREG='b000; //المفروض يبقي دة يخليني اختار ال alu out regggggg
				REG_WS=1;
				next_state=State0;
		end
		State6:  begin
			ALU_SEL1=1;
			ALU_SEL2='b010;
			ALU_OP='b011;
			SIGNEXT_SEL=0;
			next_state=State8;

		end
		State7:  begin
			ALU_SEL1=1;
			ALU_SEL2='b010;
			ALU_OP='b000;
			SIGNEXT_SEL=0;
			case(Opcode)
			OP_SH: next_state= State27;   //SH 
			OP_SB: next_state= State26;   //SB
			OP_LHu: next_state= State24;   //LHu
			OP_LB: next_state= State23;   //LB
			OP_LW: next_state= State18;   //LW
			OP_SW: next_state= State17;   //SW
			OP_LH: next_state= State25;   //LH
			OP_LBU: next_state= State22;   //LBu
			OP_ADDi:begin
				if(OF_OUT==1)
					next_state=State30;  
					else
					next_state=State8;
			end

			endcase  
		end
		State8: begin
			Reg_Dest='b00;
			MEMtoREG='b000; 
			REG_WS=1;
			next_state=State0;
		end
		State9	:begin
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
			next_state=State8;
		end
		State15	:	begin
			ALU_SEL1 = 1;
			ALU_SEL2 ='b010;
			ALU_OP = 'b101;
			next_state = State8;
			SIGNEXT_SEL =0;
		end
		State16	:	begin
			ALU_SEL1 = 1;
			ALU_SEL2 ='b010;
			ALU_OP = 'b110;
			next_state = State8;
			SIGNEXT_SEL =0;  
		end
		State17	:	begin
			RAM_SEL = WW;
			IorD='d1;
			MEM_WS=1;
			next_state = State0;
		end		
		State18	:	begin
			IorD='d1;
			next_state = State19;
		end
		State19:  begin
			Reg_Dest='b00;
			MEMtoREG='b100;
			case(Opcode)
				OP_LW:	begin
						REG_DATA_SEL='b000;
						end
				OP_LBU:	begin
						REG_DATA_SEL='b001;
						end
				OP_LB:	begin
						REG_DATA_SEL='b010;
						end	
				OP_LHu:	begin
						REG_DATA_SEL='b011;
						end	
				OP_LH:	begin
						REG_DATA_SEL='b100;
						end
				default:begin
						REG_DATA_SEL='b000;
						end
			endcase
			REG_WS=1;
			next_state=State0; //fetch  
		end		
		State20:  begin
			PC_EN=1;
			PC_SEL='b011;
			next_state=State0; //FETCH
		end	
		State21:  begin
			MEMtoREG='b101;
			Reg_Dest='b10; //EDITED --- WRITE OVER $ra not Rd
			//STATE 35 COMBINED
			PC_EN=1;
			PC_SEL='b011;
			REG_WS = 1;
			next_state=State0; //FETCH
		end
		State22:  begin
			IorD='d1;
			next_state=State19; 
		end
		State23:  begin
			IorD='d1;
			next_state=State19; 
		end	
		State24:  begin
			IorD='d1;
			next_state=State19; 
		end	
		State25:  begin
			IorD='d1;
			next_state=State19; 
		end	
		State26	:	begin
			IorD='d1;
			RAM_SEL=WB;
			MEM_WS=1;
			next_state = State0;
		end
		State27	:	begin
			IorD='d1;
			RAM_SEL=WH;
			MEM_WS=1;
			next_state = State0;
		end			
		State28:  begin
			ALU_SEL1='d1;
			ALU_SEL2='b010;
			ALU_OP='b011;
			SIGNEXT_SEL='d1;
			next_state=State8;
		end			
		State29:  begin
			ALU_SEL1='d1;
			ALU_SEL2='b010;
			ALU_OP='b000;
			SIGNEXT_SEL='d1;
			next_state=State8;
		end	
		State30:  begin
			CAUSE_SEL='d0;
			CAUSE_EN='d1;
			EPC_SEL = 'd0;
			EPC_EN='d1;
			PC_SEL='b100;
			next_state=State0; //fetch
		end
		State31:  begin
			CAUSE_SEL='d1;
			CAUSE_EN='d1;
			EPC_SEL='d0;
			EPC_EN='d1;
			PC_SEL='b100;
			next_state=State0; //fetch
		end		
		State32:  begin
			Reg_Dest='b00; //EDITED --- WRITE OVER $rt not Rd
			REG_WS=1;
			if(Rd=='b01101)		//CAUSE
				MEMtoREG='b011;
			else				//EPC
				MEMtoREG='b010;
			next_state=State0; //fetch

		end
		State33:  begin 
			ALU_SEL1 = 'd1;
			ALU_SEL2 = 'd0;
			ALU_OP=3'b111;
			if(mult_div_done)
				next_state=State35;
			else
				next_state=State33;
		end	
		State34:  begin
			CAUSE_SEL='d2;
			EPC_SEL='d1;
			if(Rd=='b01101)begin    //CAUSE
				CAUSE_EN='d1;
				EPC_EN='d0;
			end
			else begin		  //EPC
				CAUSE_EN='d0;
				EPC_EN='d1;
			end
			next_state=State0; //fetch
		end		
		State35:  begin 
			Reg_Dest=2'b01;
			MEMtoREG='b000; 
			REG_WS=1;
			next_state=State0; //fetch
		end
		State36:  begin 
			ALU_SEL1 = 'd1;
			ALU_SEL2 = 'd0;
			ALU_OP=3'b010;
			if(mult_div_done)
				next_state=State37;
			else
				next_state=State36;
		end	
		State37:  begin 
			lo_SEL = 'd1;
			lo_EN = 'd1;
			hi_SEL = 'd1;
			hi_EN = 'd1;
			next_state=State0; //fetch
		end			
		default	:	begin		//invalid opcode
			next_state = State31;
		end

	endcase

	end

endmodule