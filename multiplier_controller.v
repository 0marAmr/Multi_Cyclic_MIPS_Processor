module multiplier_controller (
    input wire RST,
    input wire CLK,
    input wire [1:0] status,
    input wire start,           // starts the multiplication
    input wire done,
    output reg initialize,
    output reg accum_load,
    output reg sh_en,
    output reg comp,
    output reg valid
);
    localparam [1:0]    IDLE        = 'b00,
                        SHIFT       = 'b01,
                        ADD         = 'b10,
                        FORCE_SHIFT      = 'b11;
    
    reg [1:0] present_state, next_state;

    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            present_state <= IDLE;
        end
        else begin
            present_state <=next_state;
        end
    end

    always @(*) begin
        initialize = 0;
        accum_load = 0;
        sh_en = 0;
        comp = 0;
        valid = 0;
        case (present_state)
            IDLE: begin
                /*next state*/
                if (start) begin
                    if(status[1])
                        next_state = ADD;
                    else
                        next_state = SHIFT;
                end
                else begin
                    next_state = IDLE;
                end

                /*output*/
                if (start) begin
                    initialize = 'b1;
                end
            end
            ADD: begin
                /*next state*/
                if (done) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = FORCE_SHIFT;
                end

                /*output*/
                accum_load = 'b1;
                if (status[0]) // 01 -> no complement
                    comp = 'b0;
                else
                    comp = 'b1;
            end
            SHIFT: begin
                /*next state*/
                if (done) begin
                    next_state = IDLE;
                end
                else if ((status == 'b00)||( status == 'b11)) begin
                    next_state = SHIFT;
                end
                else begin
                    next_state = ADD;
                end

                /*output*/
                if ((status == 'b00||status == 'b11)&& ~done) begin
                    sh_en = 'b1;
                end
            end
            FORCE_SHIFT: begin
                next_state = SHIFT;
                sh_en = 'b1;

            end

                            // next_state = IDLE;
                // valid = 1'b1;
        endcase
    end

endmodule
