module Arithmatic_Logic_Unit #(
	parameter OPERAND_WIDTH=32 
)(
input wire CLK,
input wire RST,
//data inputs
input 	wire	[OPERAND_WIDTH-1:0] Operand1,Operand2,
//control signals
input	wire	[3:0]					Cntrl,
input 	wire	[4:0]					Shamt,
input 	wire							mult_start,
input 	wire							div_start,
//data out
output	reg  	[OPERAND_WIDTH-1:0]		ALU_OUT,
output	reg  	[OPERAND_WIDTH-1:0]		ALU_OUT2,
//flags
output	reg						mult_div_done,
output	reg							BF_OUT,
output	reg							OF_OUT,
output	reg							ZF_OUT,
output	reg							NF_OUT
);

	/*multiplication unit instance*/
	wire [2*OPERAND_WIDTH-1:0] 	mult_result;
	wire [OPERAND_WIDTH-1:0] 	div_result;
	wire mult_done, div_done;

    multiplier U0_mult (
        .CLK (CLK),
        .RST(RST),
        .Operand1(Operand1),
        .Operand2(Operand2),
        .start(mult_start),
        .result(mult_result),
        .valid(mult_done)
    );

	divider U0_div (
        .CLK (CLK),
        .RST(RST),
        .Operand1(Operand1),
        .Operand2(Operand2),
        .start(div_start),
        .result(div_result),
        .done(div_done)
    );


	localparam 	[3:0]	AND		= 'b0000,
						OR		= 'b0001,
						ADD		= 'b0010,
						XOR		= 'b0011,
						NOR		= 'b0100,
						SLTU	= 'b0101,
						SUB		= 'b0110,
						SLT		= 'b0111,
						SLL     = 'b1000,
						SLLV    = 'b1001,
						SRL     = 'b1010,
						SRLV    = 'b1011,
						SRA     = 'b1100,
						SRAV   	= 'b1101,
						MULT 	= 'b1110,
						DIV 	= 'b1111;

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
						ALU_OUT = mult_result[OPERAND_WIDTH-1:0];
						ALU_OUT2= mult_result[2*OPERAND_WIDTH-1:OPERAND_WIDTH];
						mult_div_done = mult_done;
					end	
			DIV 	:begin
						ALU_OUT = div_result;
						mult_div_done = div_done;
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
