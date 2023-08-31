/*test bench is automatically generated*/
`timescale 1ps / 1ps

module Top_TB;

    // input signals
    reg CLK;
    reg RST;

    // instantiation
    Top DUT(
        .CLK(CLK),
        .RST(RST)
    	);

    // clock signal
    parameter PERIOD  = 10;

    initial begin
        CLK = 0;
        forever begin 
            #(PERIOD/2)  
            CLK=~CLK; 
        end
    end

    task rst;
    begin
        RST = 1;
        @(negedge CLK);
        RST = 0;
        @(negedge CLK);
        RST = 1;
    end
    endtask
    
    parameter START_ADDR = 32'h0040_0000;
    parameter END_ADDR = 32'h0052_0000;
    integer i;
    integer outfile;
    // test vector generator
    initial begin
        rst();
        repeat (500) @(negedge CLK);
        outfile = $fopen("memory_contents.txt","w");

        for (i = START_ADDR; i <= END_ADDR; i = i +1) begin
        $fdisplay(outfile,"address= 0x%h, data = %h,\t\t memory[%1d] = %d",i, DUT.U0_RAM.memory[i], i, DUT.U0_RAM.memory[i]);  //write as decimal
        end
         
        $finish; 
    end

endmodule