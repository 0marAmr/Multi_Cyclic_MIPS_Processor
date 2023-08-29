module ALU_Controller (
    input wire [5:0] Funct,     /*Connected to the function field of an R-type instruction (bits [5:0])*/
    input wire [2:0] ctrl,      /*Derived by ALU_OP from the sequence controller*/
    output reg [3:0] Out
);
    
    /*ALU Operation*/
    localparam      AND = 'b0000,
                    OR = 'b0001,
                    add = 'b0010,
                    XOR = 'b0011,
                    NOR= 'b0100,
                    Set_if_less_than_unsigned = 'b0101,
                    subtract = 'b0110,
                    Set_if_less_than = 'b0111,
                    Shift_left_logic = 'b1000,
                    Shift_left_logic_by_var = 'b1001,
                    Shift_right_logic = 'b1010,
                    Shift_right_logic_by_var = 'b1011,
                    Shift_right_arith = 'b1100,
                    Shift_right_arith_by_var = 'b1101,
					MULT = 'b1110,
					DIV = 'b1111;

    wire [8:0] sel;
    assign sel = {ctrl,Funct};
always@(*)  begin
    
    casex (sel)
        /*Load word - Load byte - Load byte unsigned - Load half word */
        'b000_xxxxxx: begin
            Out = add;
        end    
        'b001_xxxxxx: begin
            Out = subtract;
        end    
        'b011_xxxxxx : begin
            Out = Set_if_less_than;
        end
        'b100_xxxxxx : begin
            Out = AND;
        end    
        'b101_xxxxxx : begin
            Out = OR;
        end    
        'b110_xxxxxx : begin
            Out = XOR;
        end  
        'b111_xxxxxx : begin
            Out = MULT;
        end  		
        'b010_001000 : begin /*Jump register*/
            Out = 4'bxxxx;
        end           
        'b010_001001 : begin /*Jump and link reg*/
            Out = add;
        end              
        'b010_100000 : begin /*add*/
            Out = add;
        end              
        'b010_100001 : begin /*add unsigned*/
            Out = add;
        end                 
        'b010_100010 : begin /*subtract*/
            Out = subtract;
        end                 
        'b010_100011 : begin /*subtract unsigned*/
            Out = subtract;
        end                 
        'b010_100100 : begin /*Logical AND*/
            Out = AND;
        end                  
        'b010_100101 : begin /*Logical OR*/
            Out = OR;
        end                  
        'b010_100110 : begin /*Logical XOR*/
            Out = XOR;
        end                  
        'b010_100111 : begin /*Logical NOR*/
            Out = NOR;
        end                  
        'b010_000000 : begin /*Shift left logic*/
            Out = Shift_left_logic;
        end                  
        'b010_000100 : begin /*Shift left logic by variable*/
            Out = Shift_left_logic_by_var;
        end                  
        'b010_000010 : begin /*Shift right logic*/
            Out = Shift_right_logic;
        end                  
        'b010_000110 : begin /*Shift right logic by variable */
            Out = Shift_right_logic_by_var;
        end                 
        'b010_000011 : begin /*Shift right arithmetic*/
            Out = Shift_right_arith;
        end                   
        'b010_000111 : begin /*Shift right arithmetic by variable*/
            Out = Shift_right_arith_by_var;
        end                   
        'b010_101001 : begin /*Set-if-less-than unsigned*/
            Out = Set_if_less_than_unsigned;
        end                   
        'b010_101010 : begin /*Set-if-less-than*/
            Out = Set_if_less_than;
        end
        'b010_011000 : begin 
            Out = MULT;
        end
        'b010_011010 : begin 
            Out = DIV;
        end		
        default: 
            Out = 'bxxxx;
    endcase
end

endmodule