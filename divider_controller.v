module divider_controller (
    input wire RST,
    input wire CLK,
    input wire divident_gt_divisor,
    input wire start,
    input wire done,
    output reg initialize,
    output reg load_divident,
    output reg sh_en
);
    

    localparam [1:0]    IDLE = 'b00,
                        INIT = 'b01,
                        OPER = 'b10;

    reg present_state, next_state;

    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            present_state <= IDLE;
        end
        else begin
            present_state <=next_state;
        end
    end

    always @(*) begin
        initialize = 'b0;
        load_divident = 'b0;
        sh_en = 'b0;
        case (present_state)
            IDLE: begin
                /*next state*/
                if (start) begin
                    next_state = INIT;
                end
                else begin
                    next_state = IDLE;
                end

            end 
            INIT : begin
                next_state = OPER;
                initialize = 'b1; 
            end
            OPER: begin
                /*next state*/
                if (done) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = OPER;
                end
                /*output*/
                if (divident_gt_divisor) begin
                    load_divident = 'b1;
                end
                else begin
                    sh_en = 'b1;
                end
            end
            default : next_state = IDLE;
        endcase    
    end

endmodule