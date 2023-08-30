module multiplier #(
    DATA_WIDTH = 5
)(
    input wire CLK, RST,
    input wire start,
    input wire [DATA_WIDTH-1:0] Operand1,
    input wire [DATA_WIDTH-1:0] Operand2,
    output wire [2*DATA_WIDTH-1:0] result,
    output wire valid
);

    wire [1:0] status;
    multiplier_datapath U0_mult_dp (
        .CLK(CLK),
        .RST(RST),
        .initialize(initialize),
        .accum_load(accum_load),
        .sh_en(sh_en),
        .comp(comp),
        .Operand1(Operand1),
        .Operand2(Operand2),
        .status(status),
        .done(done),
        .result(result)
    );

    multiplier_controller U0_mult_ctrl (
        .RST(RST),
        .CLK(CLK),
        .status(status),
        .start(start),
        .done(done),
        .initialize(initialize),
        .accum_load(accum_load),
        .sh_en(sh_en),
        .comp(comp),
        .valid(valid)
    );
endmodule