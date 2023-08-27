/*test bench is automatically generated*/
`timescale 1ns / 1ps

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
    
    // test vector generator
    initial begin
        rst();
        repeat (20) @(negedge CLK);
        $finish; 
    end

endmodule