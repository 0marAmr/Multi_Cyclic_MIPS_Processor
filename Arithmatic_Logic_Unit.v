module Arithmatic_Logic_Unit #(
	parameter OPERAND_WIDTH=32 
)(
//data inputs
input 	wire	[OPERAND_WIDTH-1:0] Operand1,Operand2,
//control signals
input	wire	[3:0]					Cntrl,
input 	wire	[4:0]					Shamt,
input 	wire							mult_start,div_start
//data out
output	reg  	[OPERAND_WIDTH-1:0]		ALU_OUT,ALU_OUT2,
//flags
output	reg							NF_OUT,ZF_OUT,OF_OUT,BF_OUT,mult_div_done
);



localparam 	[3:0]	AND		= 4'b0000,
					OR		= 4'b0001,
					ADD		= 4'b0010,
					XOR		= 4'b0011,
					NOR		= 4'b0100,
					SLTU	= 4'b0101,
					SUB		= 4'b0110,
					SLT		= 4'b0111,
					SLL     = 4'b1000,
					SLLV    = 4'b1001,
					SRL     = 4'b1010,
					SRLV    = 4'b1011,
					SRA     = 4'b1100,
					SRAV   = 4'b1101,
					MULT = 'b1110,
					DIV = 'b1111;
					
wire 	[OPERAND_WIDTH-1:0]  OP1_U,OP2_U,OP2_TEMP;

assign	OP1_U = Operand1;
assign	OP2_U = Operand2;
assign 	OP2_TEMP = (~Operand2)+'d1; //2's complement										

always @(*)begin
OF_OUT = 'd0;
BF_OUT = 'd0;
ALU_OUT2='d0;
mult_div_done='d0;	
	case(Cntrl)
		AND 	:begin
				ALU_OUT = Operand1 & Operand2;
		end
		OR  	:begin
				ALU_OUT = Operand1 | Operand2;
		end	
		XOR 	:begin
				ALU_OUT = Operand1 ^ Operand2;
				end	
		NOR 	:begin
				ALU_OUT = ~(Operand1 | Operand2);
				end
		ADD 	:begin
				ALU_OUT = Operand1 + Operand2;
				if((Operand1[OPERAND_WIDTH-1] && Operand2[OPERAND_WIDTH-1] && !ALU_OUT[OPERAND_WIDTH-1]) || (!Operand1[OPERAND_WIDTH-1] && !Operand2[OPERAND_WIDTH-1] && ALU_OUT[OPERAND_WIDTH-1]))begin
					OF_OUT = 'd1;
				end
				else begin
					OF_OUT = 'd0;
				end
				end	
		SLTU 	:begin
				if(OP1_U<OP2_U)begin
					ALU_OUT ='d1;
				end
				else begin
					ALU_OUT ='d0;
				end
				end	
		SLT 	:begin
				if(Operand1<Operand2)begin
					ALU_OUT ='d1;
				end
				else begin
					ALU_OUT ='d0;
				end
				end	
		SUB 	:begin
				ALU_OUT = Operand1 + OP2_TEMP; //Operand1-Operand2
				if((Operand1[OPERAND_WIDTH-1] && Operand2[OPERAND_WIDTH-1] && !ALU_OUT[OPERAND_WIDTH-1]) || (!Operand1[OPERAND_WIDTH-1] && !Operand2[OPERAND_WIDTH-1] && ALU_OUT[OPERAND_WIDTH-1])) begin
					OF_OUT = 'd1;
				end
				else begin
					OF_OUT = 'd0;
				end
				end	
		SLL 	:begin
				ALU_OUT = Operand2 << Shamt;
				end	
		SLLV 	:begin
				ALU_OUT = Operand2 << Operand1;
				end	
		SRL 	:begin
				ALU_OUT = Operand2 >> Shamt;
				end	
		SRLV 	:begin
				ALU_OUT = Operand2 >> Operand1;
				end	
		SRA 	:begin
				ALU_OUT = Operand2 >>> Shamt;
				end	
		SRAV 	:begin
				ALU_OUT = Operand2 >>> Operand1;
				end	
		MULT 	:begin
				ALU_OUT = // first 32 bits of multiplier module result 
				ALU_OUT2= // last 32 bits of multiplier module result 
				mult_div_done= //done output of multiplier module
				OF_OUT = ///////
				end	
		DIV 	:begin
				ALU_OUT = //  first 32 bits of divider module result 
				ALU_OUT2= // last 32 bits of divider module result 
				mult_div_done= //done output of divider module
				OF_OUT = ///////
				end					
		default :begin
				ALU_OUT = 'd0;
				BF_OUT = 'b1;
				end	
				
	endcase
end

always @(*)begin
	NF_OUT = ALU_OUT[OPERAND_WIDTH-1];
	ZF_OUT = (ALU_OUT=='d0);
end

endmodule
