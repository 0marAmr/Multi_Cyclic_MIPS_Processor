module divider #(
    parameter DATA_WIDTH = 6
) (
    input wire RST,
    input wire CLK,
    input wire start,
    input wire [DATA_WIDTH-1: 0] Operand1,
    input wire [DATA_WIDTH-1: 0] Operand2,
    output wire [DATA_WIDTH-1: 0] result,
    output wire done
);
    
    divider_datapath U0_div_dp (
        .RST(RST),
        .CLK(CLK),
        .Operand1(Operand1),
        .Operand2(Operand2),
        .initialize(initialize),
        .load_divident(load_divident),
        .sh_en(sh_en),
        .result(result),
        .divident_gt_divisor(divident_gt_divisor),
        .done(done)
    );

    divider_controller U0_div_ctrl (
        .RST(RST),
        .CLK(CLK),
        .divident_gt_divisor(divident_gt_divisor),
        .start(start),
        .done(done),
        .initialize(initialize),
        .load_divident(load_divident),
        .sh_en(sh_en)
    );
endmodule