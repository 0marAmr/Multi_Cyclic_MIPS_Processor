module register #(parameter width=32)(
input	wire					CLK,
input	wire 					RST,  /*active low asynchronous reset*/
input 	wire 	[width-1:0]		data_in,
output	reg		[width-1:0]		data_out
    );
	 
	 always @(posedge CLK,negedge RST)begin
		if(!RST)begin
			data_out <= 'd0;
		end
		else begin
			data_out <= data_in;
		end
	 end

endmodule
