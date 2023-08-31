module register_en #(
	parameter 	width = 32,
				INIT_VAL = 0
	)(
	input	wire					CLK,
	input	wire 					RST,  /*active low asynchronous reset*/
	input	wire 					EN,  
	input 	wire 	[width-1:0]		data_in,
	output	reg		[width-1:0]		data_out

    );
	 
	 always @(posedge CLK, negedge RST)begin
		if(!RST)begin
			data_out <= INIT_VAL;
		end
		else if (EN) begin
			data_out <= data_in;
		end
	 end

endmodule
