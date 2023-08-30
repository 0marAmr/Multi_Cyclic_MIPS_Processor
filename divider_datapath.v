module divider_datapath #(
    parameter DATA_WIDTH = 32,
    parameter COUNTER_WIDTH = 6

)(
    input wire RST,
    input wire CLK,
    input wire [DATA_WIDTH-1: 0] Operand1,
    input wire [DATA_WIDTH-1: 0] Operand2,
    input wire initialize,
    input wire load_divident,
    input wire sh_en,                        // enables shifting the divisor to the right
    output wire [DATA_WIDTH-1: 0] result,
    output wire divident_gt_divisor,
    output wire done
);

    reg [2*DATA_WIDTH-1: 0] divident, divisor;
    reg [DATA_WIDTH-1: 0] quotient;


    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            divident <= 'b0;
            divisor <= 'b0;
            quotient <= 'b0;
        end
        else if(initialize) begin
            divident <= Operand1;
            divisor[2*DATA_WIDTH-1: DATA_WIDTH] <= Operand2;
        end
        else if (load_divident) begin
            divident <= divident + ~divisor + 1;
            divisor <= {1'b0, divisor[2*DATA_WIDTH-1:1]};     // SHR the divisor by 1 bit pos
            quotient <= {quotient[DATA_WIDTH-2:0], 1'b1};    // SHL adding 1 to LSB
        end        
        else if (sh_en) begin
            divisor <= {1'b0, divisor[2*DATA_WIDTH-1:1]};     // SHR the divisor by 1 bit pos
            quotient <= {quotient[DATA_WIDTH-2:0], 1'b0};    // SHL adding 0 to LSB
        end
    end
    
    reg [COUNTER_WIDTH-1:0] count;
    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            count <= 'b0;
        end
        else if (sh_en || load_divident) begin
            count <= count + 'b1;
        end
        else if (done) begin
            count <= 'b0;
        end
    end

    assign done = (count == DATA_WIDTH);
    assign divident_gt_divisor = (divident >= divisor);
    assign result = quotient;
endmodule