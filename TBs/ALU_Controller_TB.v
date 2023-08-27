`timescale 1ns/1ps;
module ALU_CONTROLLER_TB();




/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////


reg [5:0] Funct_TB;     
reg [2:0] ctrl_TB;      
wire [3:0] Out_TB;
	
////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial begin
	
	/************* Load/Store ****************/
	ctrl_TB = 'b000;
	Funct_TB= 'bxxxxxx;
	#1;
	if(Out_TB == 'b0010)  begin // output should be ADD
		$display("Load/Store Success");
	end
	else begin
		$display("Load/Store Fail");
	end

	/************* Jump Register ****************/
	ctrl_TB = 'b010;
	Funct_TB= 'b001000;
	#1;
		$display("Out_TB = %b",Out_TB);

	
	/************* ANDi ****************/
	ctrl_TB = 'b100;
	#1;
	if(Out_TB == 'b0000)  begin // output should be AND
		$display("ANDi Success");
	end
	else begin
		$display("ANDi Fail");
	end


	/************* Jump and Link Register ****************/
	ctrl_TB = 'b010;
	Funct_TB= 'b001001;
	#1;
	if(Out_TB == 'b0010)  begin // output should be ADD
		$display("Jump and Link Register Success");
	end
	else begin
		$display("Jump and Link Register Fail");
	end

	/************* ORi ****************/
	ctrl_TB = 'b101;
	#1;
	if(Out_TB == 'b0001)  begin // output should be OR
		$display("ORi Success");
	end
	else begin
		$display("ORi Fail");
	end

	/************* ADD ****************/
	ctrl_TB = 'b010;
	Funct_TB= 'b100000;
	#1;
	if(Out_TB == 'b0010)  begin // output should be ADD
		$display("ADD Success");
	end
	else begin
		$display("ADD Fail");
	end

	/************* XORi ****************/
	ctrl_TB = 'b110;
	#1;
	if(Out_TB == 'b0011)  begin // output should be XOR
		$display("XORi Success");
	end
	else begin
		$display("XORi Fail");
	end

	/************* Add Unsigned ****************/
	ctrl_TB = 'b010;
	Funct_TB= 'b100001;
	#1;
	if(Out_TB == 'b0010)  begin // output should be ADD
		$display("Add Unsigned Success");
	end
	else begin
		$display("Add Unsigned Fail");
	end

	/************* Branch ****************/
	ctrl_TB = 'b010;
	Funct_TB= 'b100100;
	#1;
	if(Out_TB == 'b0000)  begin // output should be AND
		$display("Branch Success");
	end
	else begin
		$display("Branch Fail");
	end


	/************* Set-if-less-than immediate ****************/
	ctrl_TB = 'b011;
	#1;
	if(Out_TB == 'b0111)  begin // output should be 0111
		$display("Set-if-less-than immediate Success");
	end
	else begin
		$display("Set-if-less-than immediate Fail");
	end


	/************* Subtract ****************/
	ctrl_TB = 'b010;
	Funct_TB= 'b100010;
	#1;
	if(Out_TB == 'b0110)  begin // output should be 0110
		$display("Subtract Success");
	end
	else begin
		$display("Subtract Fail");
	end

	/************* illegal operation ****************/
	ctrl_TB = 'b111;
	#1;
		$display("illegal operation , Out = %b",Out_TB);
	

	/************* Subtract Unsigned ****************/
	ctrl_TB = 'b010;
	Funct_TB= 'b100011;
	#1;
	if(Out_TB == 'b0110)  begin // output should be 0110
		$display("Subtract Unsigned Success");
	end
	else begin
		$display("Subtract Unsigned Fail");
	end

	/************* OR ****************/
	Funct_TB= 'b100101;
	#1;
	if(Out_TB == 'b0001)  begin // output should be 0001
		$display("OR Success");
	end
	else begin
		$display("OR Fail");
	end

	/************* XOR ****************/
	Funct_TB= 'b100110;
	#1;
	if(Out_TB == 'b0011)  begin // output should be 0011
		$display("XOR Success");
	end
	else begin
		$display("XOR Fail");
	end

	/************* NOR ****************/
	Funct_TB= 'b100111;
	#1;
	if(Out_TB == 'b0100)  begin // output should be 0100
		$display("NOR Success");
	end
	else begin
		$display("NOR Fail");
	end

	/************* SLL ****************/
	Funct_TB= 'b000000;
	#1;
	if(Out_TB == 'b1000)  begin // output should be 1000
		$display("SLL Success");
	end
	else begin
		$display("SLL Fail");
	end


	/************* SLLV ****************/
	Funct_TB= 'b000100;
	#1;
	if(Out_TB == 'b1001)  begin // output should be 1001
		$display("SLLV Success");
	end
	else begin
		$display("SLLV Fail");
	end


	/************* SRL ****************/
	Funct_TB= 'b000010;
	#1;
	if(Out_TB == 'b1010)  begin // output should be 1010
		$display("SRL Success");
	end
	else begin
		$display("SRL Fail");
	end

	/************* SRLV ****************/
	Funct_TB= 'b000110;
	#1;
	if(Out_TB == 'b1011)  begin // output should be 1011
		$display("SRLV Success");
	end
	else begin
		$display("SRLV Fail");
	end

	/************* SRA ****************/
	Funct_TB= 'b000011;
	#1;
	if(Out_TB == 'b1100)  begin // output should be 1100
		$display("SRA Success");
	end
	else begin
		$display("SRA Fail");
	end

	/************* SRAV ****************/
	Funct_TB= 'b000111;
	#1;
	if(Out_TB == 'b1101)  begin // output should be 1101
		$display("SRAV Success");
	end
	else begin
		$display("SRAV Fail");
	end

	/************* Set if less than Unsigned ****************/
	Funct_TB= 'b101001;
	#1;
	if(Out_TB == 'b0101)  begin // output should be 0101
		$display("Set if less than Unsigned Success");
	end
	else begin
		$display("Set if less than Unsigned Fail");
	end

	/************* Set if less than ****************/
	Funct_TB= 'b101010;
	#1;
	if(Out_TB == 'b0111)  begin // output should be 0111
		$display("Set if less than Success");
	end
	else begin
		$display("Set if less than Fail");
	end

	/************* illegal operation ****************/
	Funct_TB= 'b111111;
	#1;
	$display("illegal operation, Out =%b",Out_TB);
	
	/************* illegal operation ****************/
	Funct_TB= 'bxxxxxx;
	#1;
	$display("illegal operation, Out =%b",Out_TB);


	$finish();

end











////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////


ALU_Controller DUT(
    .Funct(Funct_TB),    
    .ctrl(ctrl_TB),      
    .Out(Out_TB)
);



endmodule