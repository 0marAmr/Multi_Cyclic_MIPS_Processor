`timescale 1ns/1ps;
module Combinational_Block_TB();




/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////


reg		NF_OUT_TB,ZF_OUT_TB;
reg		PCWrite_BLTZ_TB,PCWrite_BGTZ_TB,PCWrite_BLEZ_TB,PCWrite_BNE_TB,PCWrite_BEQ_TB;
reg		PC_EN_TB;
wire	PC_LOAD_TB;
	
////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial begin
	
	/******************** TestCase 1 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==0) begin
		$display ("Test case 1 Sucess");
	end
	else begin
		$display ("Test case 1 Fail");
	end

	/******************** TestCase 2 ********************/
	NF_OUT_TB = 'b1;
	ZF_OUT_TB = 'b1;
	PCWrite_BLTZ_TB = 'b1;
	PCWrite_BGTZ_TB = 'b1;
	PCWrite_BLEZ_TB = 'b1;
	PCWrite_BNE_TB = 'b1;
	PCWrite_BEQ_TB = 'b1;
	PC_EN_TB = 'b1;
	#1;
	if(PC_LOAD_TB==1) begin
		$display ("Test case 2 Sucess");
	end
	else begin
		$display ("Test case 2 Fail");
	end


/******************** TestCase 3 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b1;
	PCWrite_BGTZ_TB = 'b1;
	PCWrite_BLEZ_TB = 'b1;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b1;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==1) begin
		$display ("Test case 3 Sucess");
	end
	else begin
		$display ("Test case 3 Fail");
	end

/******************** TestCase 4 ********************/
	NF_OUT_TB = 'b1;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b1;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==0) begin
		$display ("Test case 4 Sucess");
	end
	else begin
		$display ("Test case 4 Fail");
	end




/******************** TestCase 5 ********************/
	NF_OUT_TB = 'b1;
	ZF_OUT_TB = 'b1;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==0) begin
		$display ("Test case 5 Sucess");
	end
	else begin
		$display ("Test case 5 Fail");
	end




/******************** TestCase 6 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b1;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==1) begin
		$display ("Test case 6 Sucess");
	end
	else begin
		$display ("Test case 6 Fail");
	end




/******************** TestCase 7 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b1;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==0) begin
		$display ("Test case 7 Sucess");
	end
	else begin
		$display ("Test case 7 Fail");
	end




/******************** TestCase 8 ********************/
	NF_OUT_TB = 'b1;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b1;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==1) begin
		$display ("Test case 8 Sucess");
	end
	else begin
		$display ("Test case 8 Fail");
	end


/******************** TestCase 9 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b1;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b1;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==0) begin
		$display ("Test case 9 Sucess");
	end
	else begin
		$display ("Test case 9 Fail");
	end


/******************** TestCase 10 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b1;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==1) begin
		$display ("Test case 10 Sucess");
	end
	else begin
		$display ("Test case 10 Fail");
	end


/******************** TestCase 11 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b1;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b1;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==0) begin
		$display ("Test case 11 Sucess");
	end
	else begin
		$display ("Test case1 11 Fail");
	end



/******************** TestCase 12 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b1;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b1;
	PC_EN_TB = 'b0;
	#1;
	if(PC_LOAD_TB==1) begin
		$display ("Test case 12 Sucess");
	end
	else begin
		$display ("Test case 12 Fail");
	end


/******************** TestCase 13 ********************/
	NF_OUT_TB = 'b0;
	ZF_OUT_TB = 'b0;
	PCWrite_BLTZ_TB = 'b0;
	PCWrite_BGTZ_TB = 'b0;
	PCWrite_BLEZ_TB = 'b0;
	PCWrite_BNE_TB = 'b0;
	PCWrite_BEQ_TB = 'b0;
	PC_EN_TB = 'b1;
	#1;
	if(PC_LOAD_TB==1) begin
		$display ("Test case 13 Sucess");
	end
	else begin
		$display ("Test case 13 Fail");
	end














end


////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////


Combinational_Block  DUT (
	.NF_OUT(NF_OUT_TB),
	.ZF_OUT(ZF_OUT_TB),
	.PCWrite_BLTZ(PCWrite_BLTZ_TB),
	.PCWrite_BGTZ(PCWrite_BGTZ_TB),
	.PCWrite_BLEZ(PCWrite_BLEZ_TB),
	.PCWrite_BNE(PCWrite_BNE_TB),
	.PCWrite_BEQ(PCWrite_BEQ_TB),
	.PC_EN(PC_EN_TB),
	.PC_LOAD(PC_LOAD_TB)
);


endmodule