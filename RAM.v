module RAM #(
	parameter 	ADDRESS_WIDTH = 32,
				INSTR_DATA_WIDTH = 32,
				MEMORY_DEPTH = 2**30,
				PROGRAM = "text.txt"
)
(
input 	wire								CLK,
input 	wire	[INSTR_DATA_WIDTH-1:0] 		Data,
input 	wire	[ADDRESS_WIDTH-1:0] 		Addr,
input 	wire								W_EN,
input	wire	[1:0]						sel,
output	wire	[INSTR_DATA_WIDTH-1:0] 		Output_Data
);

	reg [7:0] memory [0:MEMORY_DEPTH-1];  /*byte accessable*/

	/*write modes*/
	localparam 	WW=2'b00;
	localparam	WH=2'b01;
	localparam	WB=2'b10;

	/*Instruction Segment*/
	localparam INSTR_SEG_START_ADDR = 32'h0040_0000;       
	localparam INSTR_SEG_END_ADDR 	= 32'h0048_0000;          

	always @(posedge CLK)begin
		 if(W_EN) begin
			case(sel)
				WW:		begin //little endian
						memory[Addr+3] <= Data[31:24];
						memory[Addr+2] <= Data[23:16];
						memory[Addr+1] <= Data[15:8];
						memory[Addr] <= Data[7:0];
						end
				WH:		begin
						memory[Addr+1] <= Data[15:8];
						memory[Addr] <= Data[7:0];
						end	
				WB:		begin
					//	memory[Addr+3] <= Data[7:0];
						memory[Addr] <= Data[7:0];
						end	
				default:begin
					//	memory[Addr+3] <= Data[7:0];
						memory[Addr] <= Data[7:0];
						end					
			endcase
		end
	end

	    // Initialize the instruction memory contents from the file specified by PROGRAM
	    initial begin
	        $readmemh(PROGRAM, memory, INSTR_SEG_START_ADDR, INSTR_SEG_END_ADDR);
	    end

	assign	Output_Data = {memory[Addr+3], memory[Addr+2], memory[Addr+1], memory[Addr]};

endmodule
