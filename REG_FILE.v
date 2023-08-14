module REG_FILE #(
	parameter 	DATA_WIDTH = 32,
				ADDR_WIDTH = 5
)(
	input	wire						CLK, RST,
	input	wire	[ADDR_WIDTH-1:0]	Reg1, Reg2, Write_Reg,
	input	wire	[DATA_WIDTH-1:0]	Write_Data,
	input	wire						Write
	output	wire	[DATA_WIDTH-1:0]	Reg1_Data, Reg2_Data
);

reg [DATA_WIDTH-1:0] REG [0:(2**ADDR_WIDTH)-1];
integer i;

always @(posedge CLK, negedge RST) begin
	if(!RST)begin
		for(i=0;i<(2**ADDR_WIDTH);i=i+1)begin
			REG[i] <= 'd0;
		end
	end
	else if(Write)begin
		REG[Write_Reg] <= Write_Data;
	end
end

assign Reg1_Data = REG[Reg1];
assign Reg2_Data = REG[Reg2];

endmodule
