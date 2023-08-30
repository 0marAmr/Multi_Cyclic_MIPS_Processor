module multiplier_datapath #(
    DATA_WIDTH = 5,
    COUNTER_WIDTH =3
)(
    input wire RST,
    input wire CLK,
    input wire initialize,
    input wire sh_en,
    input wire accum_load,
    input wire comp,
    input wire [DATA_WIDTH-1:0] Operand1,
    input wire [DATA_WIDTH-1:0] Operand2,
    output wire [1:0] status,
    output wire done,
    output wire [2*DATA_WIDTH-1:0] result
);
    
    reg [DATA_WIDTH-1:0] accum, Q;
    reg SHR_LSB;
    reg [COUNTER_WIDTH-1:0] count;

    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            accum <='b0;
            Q <='b0;
            SHR_LSB <= 'b0;
        end
        else if(initialize) begin   /*registers initialization*/
            accum <= 'b0;
            Q <= Operand2;
            SHR_LSB <= 'b0;
        end
        else if(accum_load) begin        /*operation starts*/
                if (comp) 
                    accum <= accum + ~Operand1 + 1;
                else
                    accum <= accum + Operand1;
        end
        else if (sh_en) begin
            {accum, Q, SHR_LSB} <= {accum[DATA_WIDTH-1], accum, Q}; // Arithmatic shift right
        end
    end

    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            count <= 'b0;
        end
        else if (initialize) begin
            count <= 'b0;
        end
        else if (sh_en) begin
            count <= count + 1;
        end
        else if(done) begin
            count <= 'b0;
        end
    end
    
    assign status = {Q[0], SHR_LSB};
    assign done = (count == (DATA_WIDTH));
    assign result = {accum, Q};
endmodule
