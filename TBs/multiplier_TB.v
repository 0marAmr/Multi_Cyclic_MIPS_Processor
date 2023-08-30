`timescale 1ns/1ps
module multiplier_TB;
    
    parameter DATA_WIDTH = 5;
    
    reg CLK;
    reg RST;
    reg start;
    reg [DATA_WIDTH-1:0] Operand1;
    reg [DATA_WIDTH-1:0] Operand2;
    wire [2*DATA_WIDTH-1:0] result;
    wire valid;


    booth_multiplier DUT (
        .CLK (CLK),
        .RST(RST),
        .Operand1(Operand1),
        .Operand2(Operand2),
        .start(start),
        .result(result),
        .valid(valid)
    );

    localparam  CLK_PERIOD =10 ;
    initial begin
        CLK = 0;
        forever begin
            #(CLK_PERIOD/2)
            CLK = ~CLK;
        end
    end

    task initialize;
    begin
        Operand1 = 0;
        Operand2 = 0;
        start = 0;
    end
    endtask

    task reset; 
    begin
        RST = 1;
        @(negedge CLK)
        RST = 0;
        @(negedge CLK)
        RST = 1;
    end
    endtask

    task multiply (
        input [DATA_WIDTH-1: 0] X, Y
    );
    begin
        Operand1 = X;
        Operand2 = Y;
        start = 1;
        @(negedge CLK)
        start = 0;
    end
    endtask
    initial begin
        initialize();
        reset();
        multiply('b01011,'b01110);
        repeat (10) @(negedge CLK);
        $finish;
    end

endmodule