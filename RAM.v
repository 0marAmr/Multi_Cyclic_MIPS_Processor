module RAM 
(
input 	wire				CLK,RST,
input 	wire	[31:0] 		Data,
input 	wire	[31:0] 		Addr,
input 	wire				W_EN,
input	wire	[1:0]		sel,
output	wire	[31:0] 		Output_Data
);

reg [7:0] mem [0:(2**32)-1];  //byte accessable
integer i;
localparam WW=2'b00, WH=2'b01, WB=2'b10;

always @(posedge CLK,negedge RST)begin
	if(!RST)begin
		for(i=0;i<(2**32);i=i+1)begin
			mem[i] <= 'd0;
		end
	end
	else if(W_EN)begin
		case(sel)
			WW:		begin //little endian
					mem[Addr+3] <= Data[31:24];
					mem[Addr+2] <= Data[23:16];
					mem[Addr+1] <= Data[15:8];
					mem[Addr] <= Data[7:0];
					end
			WH:		begin
					mem[Addr+1] <= Data[15:8];
					mem[Addr] <= Data[7:0];
					end	
			WB:		begin
				//	mem[Addr+3] <= Data[7:0];
					mem[Addr] <= Data[7:0];
					end	
			default:begin
				//	mem[Addr+3] <= Data[7:0];
					mem[Addr] <= Data[7:0];
					end					
		endcase
	end
end

assign	Output_Data = {mem[Addr+3],mem[Addr+2],mem[Addr+1],mem[Addr]};

endmodule
