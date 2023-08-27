`timescale 1ns/1ps;
module ALU_TB();




/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////


reg		[31:0]	 Operand1_TB,Operand2_TB;
reg		[3:0]	 Cntrl_TB;
reg		[4:0]	Shamt_TB;
wire 	[31:0]  ALU_OUT_TB;
wire			NF_OUT_TB,ZF_OUT_TB,OF_OUT_TB,BF_OUT_TB;

reg 	[31:0] check_result;

////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial begin
	/***************AND operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b0000 ,5'b00000 );
	#(1);
	check_result = Operand1_TB&Operand2_TB;

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("AND Operation Succeded \n ");
	end
	else begin
		$display ("AND Operation Failed \n ");
	end

	/***************OR operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b0001 ,5'b00000 );
	#(1);
	check_result = Operand1_TB|Operand2_TB;

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("OR Operation Succeded \n ");
	end
	else begin
		$display ("OR Operation Failed \n ");
	end


	/***************ADD operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b0010 ,5'b00000 );
	#(1);
	check_result = Operand1_TB + Operand2_TB;

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("ADD Operation Succeded \n ");
	end
	else begin
		$display ("ADD Operation Failed \n ");
	end

	/***************XOR operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b0011 ,5'b00000 );
	#(1);
	check_result = Operand1_TB ^ Operand2_TB;

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("XOR Operation Succeded \n ");
	end
	else begin
		$display ("XOR Operation Failed \n ");
	end

	/***************NOR operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b0100 ,5'b00000 );
	#(1);
	check_result = ~(Operand1_TB | Operand2_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("NOR Operation Succeded \n ");
	end
	else begin
		$display ("NOR Operation Failed \n ");
	end

	/***************SLTU operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b0101 ,5'b00000 );
	#(1);
	check_result = (Operand1_TB < Operand2_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SLTU Operation Succeded \n ");
	end
	else begin
		$display ("SLTU Operation Failed \n ");
	end

	/***************SUB operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b0110 ,5'b00000 );
	#(1);
	check_result = (Operand1_TB - Operand2_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SUB Operation Succeded \n ");
	end
	else begin
		$display ("SUB Operation Failed \n ");
	end

	/***************SLL operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b1000 ,5'b00011 );
	#(1);
	check_result = (Operand2_TB <<Shamt_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SLL Operation Succeded \n ");
	end
	else begin
		$display ("SLL Operation Failed \n ");
	end


	/***************SLLV operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b1001 ,5'b00111 );
	#(1);
	check_result = (Operand2_TB <<Operand1_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SLLV Operation Succeded \n ");
	end
	else begin
		$display ("SLLV Operation Failed \n ");
	end

	/***************SRL operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b1010 ,5'b01001 );
	#(1);
	check_result = (Operand2_TB >>Shamt_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SRL Operation Succeded \n ");
	end
	else begin
		$display ("SRL Operation Failed \n ");
	end

	/***************SRLV operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b1011 ,5'b10111 );
	#(1);
	check_result = (Operand2_TB >>Operand1_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SRLV Operation Succeded \n ");
	end
	else begin
		$display ("SRLV Operation Failed \n ");
	end

	/***************SRA operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b1100 ,5'b01010 );
	#(1);
	check_result = (Operand2_TB >>Shamt_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SRA Operation Succeded \n ");
	end
	else begin
		$display ("SRA Operation Failed \n ");
	end


	/***************SRAV operation*****************/
	test_operation('b10101010_10101010_10101010_10101010 ,'b01010101_01010101_01010101_01010101 ,4'b1101 ,5'b01010 );
	#(1);
	check_result = (Operand2_TB >>Operand1_TB);

	if( (ALU_OUT_TB == check_result ) && (NF_OUT_TB==ALU_OUT_TB[31]) && ( ZF_OUT_TB==~(|ALU_OUT_TB) ) ) begin
		$display ("SRAV Operation Succeded \n ");
	end
	else begin
		$display ("SRAV Operation Failed \n ");
	end

	/***************Test Invalid Code*****************/
	Cntrl_TB = 4'b1110;
	#1;
	if(BF_OUT_TB == 1) begin
		$display ("Invalid op code detected");
	end


	$finish();

end



////////////////////////////////////////////////////////
////////////////////////Tasks///////////////////////////
////////////////////////////////////////////////////////

// test_operation task
task test_operation;
	input [31:0]	 Op1,Op2;
	input [3:0]	 Cntrl_fun;
	input [4:0]	Shamt_fun;

begin
 	Operand1_TB = Op1;
 	Operand2_TB = Op2;
 	Cntrl_TB    = Cntrl_fun;
 	Shamt_TB    = Shamt_fun;
 	#(1);



 end 
endtask



////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////


Arithmatic_Logic_Unit DUT_ALU (
		.Operand1(Operand1_TB),
		.Operand2(Operand2_TB),
		.Cntrl(Cntrl_TB),
		.Shamt(Shamt_TB),
		.ALU_OUT(ALU_OUT_TB),
		.NF_OUT(NF_OUT_TB),
		.ZF_OUT(ZF_OUT_TB),
		.OF_OUT(OF_OUT_TB),
		.BF_OUT(BF_OUT_TB)
);



endmodule