/*test bench is automatically generated*/
`timescale 1ns / 1ps

module RAM_TB;

	parameter 	ADDRESS_WIDTH = 32;
	parameter	INSTR_DATA_WIDTH = 32;
	parameter	MEMORY_DEPTH = 2**32;
	parameter	PROGRAM = "program.txt";

    localparam INSTR_SEG_START_ADDR = 0;
	localparam INSTR_SEG_END_ADDR 	= 64;

    // input signals
    reg CLK;
    reg [INSTR_DATA_WIDTH-1:0] Data;
    reg [ADDRESS_WIDTH-1:0] Addr;
    reg W_EN;
    reg [1:0] sel;

    // output signals
    wire [31:0] Output_Data;

    // instantiation
    RAM DUT(
    	.CLK(CLK),
    	.Data(Data),
    	.Addr(Addr),
    	.W_EN(W_EN),
    	.sel(sel),
    	.Output_Data(Output_Data)
    	);

    // clock signal
    parameter PERIOD  = 20;

    initial begin
        CLK = 0;
        forever begin
            #(PERIOD/2)  
            CLK=~CLK;
        end 
    end

    task initialize; 
    begin
        CLK = 0;
    	Data = 0;
    	Addr = 0;
    	W_EN = 0;
    	sel = 0;
    end
    endtask

    task disp_instr(
        input [ADDRESS_WIDTH-1:0] address
    );
    begin
        Addr = address;
        #10 $display("Instruction at address 0x%x is 0x%x", address, Output_Data);
    end
    endtask

    // Load test program into memory
    initial begin
        $readmemh(PROGRAM, DUT.memory, INSTR_SEG_START_ADDR, INSTR_SEG_END_ADDR);
    end

    // test vector generator
    initial begin
        initialize;
        disp_instr(0);
        disp_instr(4);
        disp_instr(8);
        $finish; 
    end

endmodule