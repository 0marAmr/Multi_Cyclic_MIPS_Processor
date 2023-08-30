

///////////////////////////////////////////////////////////////
////// R-type | OP | Rs | Rt | Rd | shamt | Function /////////
//////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
////// I-type | OP | Rs | Rt |     Address/Constant   /////////
//////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////
////// J-type | OP |           Address               /////////
//////////////////////////////////////////////////////////////


class Random_Instruction;
    rand bit [ 5 : 0 ] Op_Code , Inst_function;
    rand bit [ 4 : 0 ] Source , Source2 , Dest, shamt;
    rand bit [ 15 :0 ] Address_IType;
    rand bit [ 25 :0 ] Address_JType;

    constraint Op_Code_Constraint { Op_Code inside { 6'b000_000 , 6'b010_000 ,
                                                     6'b000_001 , 6'b000_100 ,
                                                     6'b000_101 , 6'b000_110 ,
                                                     6'b000_111 , 6'b001_000 ,
                                                     6'b001_001 , 6'b001_011 ,
                                                     6'b001_010 , 6'b001_100 ,
                                                     6'b001_101 , 6'b001_110 ,
                                                     6'b100_011 , 6'b100_100 ,
                                                     6'b100_000 , 6'b100_101 ,
                                                     6'b100_001 , 6'b101_000 ,
                                                     6'b101_001 , 6'b101_011 ,
                                                     6'b000_010 , 6'b000_011};}

    constraint Inst_function_Constraint { Inst_function inside { 6'b000_000 , 6'b101_010 ,
                                                                 6'b101_001 , 6'b000_111 ,
                                                                 6'b000_011 , 6'b000_110 ,
                                                                 6'b000_010 , 6'b000_100 ,
                                                                 6'b100_111 , 6'b100_110 ,
                                                                 6'b100_101 , 6'b100_100 ,
                                                                 6'b100_011 , 6'b100_010 ,
                                                                 6'b100_001 , 6'b100_000 ,
                                                                 6'b001_000 , 6'b001_001};}

    constraint Source_Reg_Constraint  { Source inside { [5'd16 : 5'd23] }; }
    constraint Source2_Reg_Constraint { Source2 inside { [5'd16 : 5'd23] };}
    constraint Dest_Reg_Constraint    { Dest inside { [5'd16 : 5'd23] };   }

    function new; // Constructor
        randomize();
    endfunction 

    function bit [ 31 : 0 ] Instruction;
        if (Op_Code == 6'd0) begin                             /// R-type
            bit [ 5 : 0 ] result_OP      = Op_Code;
            bit [ 5 : 0 ] result_Func    = Inst_function; 
            bit [ 4 : 0 ] result_Source  = Source;
            bit [ 4 : 0 ] result_Source2 = Source2;
            bit [ 4 : 0 ] result_Dest    = Dest;
            bit [ 4 : 0 ] result_shamt   = shamt;

            if (result_Func == 6'd0 || result_Func == 6'd2 || result_Func == 6'd3 ) begin

                return { result_OP , result_Source , result_Source2 , result_Dest , result_shamt , result_Func };

            end
            else begin

                return { result_OP , result_Source , result_Source2 , result_Dest , 5'd0 , result_Func };   
            end
        end

        if (Op_Code == 6'd16) begin                             /// R-type
            bit [ 5 : 0 ] result_OP      = Op_Code;
            bit [ 5 : 0 ] result_Func    = Inst_function; 
            bit [ 4 : 0 ] result_Source  = Source;
            bit [ 4 : 0 ] result_Source2 = Source2;
            bit [ 4 : 0 ] result_Dest    = Dest;
            bit [ 4 : 0 ] result_shamt   = shamt;

            return { result_OP , result_Source , result_Source2 , result_Dest , 5'd0 , 6'd0 };   
        end



        else if (Op_Code == 6'd2 || Op_Code == 6'd3) begin      /// J-type
            bit [ 5  : 0 ] result_OP             = Op_Code;
            bit [ 25 : 0 ] result_Add_Jtype      = Address_JType;
            return { result_OP , result_Add_Jtype};
        end

        else begin                                              /// I-Type
            bit [ 5  : 0 ] result_OP           = Op_Code;
            bit [ 15 : 0 ] result_Add_Itype    = Address_IType; 
            bit [ 4  : 0 ] result_Source       = Source;
            bit [ 4  : 0 ] result_Source2      = Source2;
            return { result_OP , result_Source , result_Source2 , result_Add_Itype};
        end
        
    endfunction


    function Monitor();
        int file_handle;
        int file_handle2;
        string filename2 = "Inst_description.txt";
        string filename = "output.txt";
        bit [31:0] read_instruction;

        // Reopen the file for reading
        file_handle = $fopen(filename, "r");
        if (file_handle == 0) begin
            $display("Error opening file for reading");
            $finish;
        end

        //make new file

        // Open the file for writing
        file_handle2 = $fopen(filename2, "w");

        

        // Read and process each line
        while (!$feof(file_handle)) begin
            if ($fscanf(file_handle, "%h", read_instruction)) begin
                case(read_instruction[31:26])
                    6'b000011: $fwrite(file_handle2, " OPCode = Jump and link to Address %d \n",read_instruction[ 25 : 0 ]);
                    6'b000010: $fwrite(file_handle2, " OPCode = Jump to Address %d \n",read_instruction[ 25 : 0 ]);

                    6'b000000:begin
                        $fwrite(file_handle2,"\n the instrucion is R_type: ");

                        case(read_instruction[5:0])
                            6'b000000:$fwrite(file_handle2, "OPCode = SLL, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b000010:$fwrite(file_handle2, "OPCode = SRL, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b000011:$fwrite(file_handle2, "OPCode = SRA, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b000100:$fwrite(file_handle2, "OPCode = SLLV, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b000110:$fwrite(file_handle2, "OPCode = SRLV, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b000111:$fwrite(file_handle2, "OPCode = SRAV, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b001000:$fwrite(file_handle2, "OPCode = Jump Register, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b001001:$fwrite(file_handle2, "OPCode = Jump and Link Register, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b001100:$display("The instrucion is  system call \n");
                            6'b001101:$display("The instrucion is break \n");
                            6'b010000:$display("The instrucion is move from hi \n");
                            6'b010001:$display("The instrucion is move to hi \n ");
                            6'b010010:$display("The instrucion is move from lo \n");
                            6'b010011:$display("The instrucion is move to lo \n");
                            6'b011000:$display("The instrucion is multiply \n");
                            6'b011001:$display("The instrucion is multiply unsigned \n");
                            6'b011010:$display("The instrucion is  divide \n");
                            6'b011011:$display("The instrucion is  divide unsigned\n");
                            6'b100000:$fwrite(file_handle2, "OPCode = Add, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b100001:$fwrite(file_handle2, "OPCode = Add Unsigned, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b100010:$fwrite(file_handle2, "OPCode = Sub, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b100011:$fwrite(file_handle2, "OPCode = Sub Unsigned, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b100100:$fwrite(file_handle2, "OPCode = AND, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b100101:$fwrite(file_handle2, "OPCode = OR, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b100110:$fwrite(file_handle2, "OPCode = XOR, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b100111:$fwrite(file_handle2, "OPCode = NOR, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b101010:$fwrite(file_handle2, "OPCode = Set less than, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                            6'b101011:$fwrite(file_handle2, "OPCode = Set less than unsigned, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                        default: $display("undefined instruction\n ");

                        endcase
                    end       

                    6'b010000:$fwrite(file_handle2, "OPCode = MFC0, Rs = %d, Rt = %d, Rd= %d, Shamt=%d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:11],read_instruction[10:6]);
                    
                    6'b000001:$fwrite(file_handle2, "OPCode = BLTZ, Rs = %d, Rt = %d, Address/constant= %d\n ", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b000100:$fwrite(file_handle2, "OPCode = BEQ, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b000101:$fwrite(file_handle2, "OPCode = BNE, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b000110:$fwrite(file_handle2, "OPCode = BLEZ, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b000111:$fwrite(file_handle2, "OPCode = BGTZ, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b001000:$fwrite(file_handle2, "OPCode = ADDi, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b001001:$fwrite(file_handle2, "OPCode = ADDiu, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b001011:$fwrite(file_handle2, "OPCode = SLTiu, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b001010:$fwrite(file_handle2, "OPCode = SLTi, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b001100:$fwrite(file_handle2, "OPCode = ANDi, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b001101:$fwrite(file_handle2, "OPCode = ORi, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b001110:$fwrite(file_handle2, "OPCode = XORi, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b100011:$fwrite(file_handle2, "OPCode = LW, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b100100:$fwrite(file_handle2, "OPCode = LBU, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b100000:$fwrite(file_handle2, "OPCode = LB, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b100101:$fwrite(file_handle2, "OPCode = LHU, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b100001:$fwrite(file_handle2, "OPCode = LH, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b101000:$fwrite(file_handle2, "OPCode = SB, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b101001:$fwrite(file_handle2, "OPCode = SH, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);
                    6'b101011:$fwrite(file_handle2, "OPCode = SW, Rs = %d, Rt = %d, Address/constant= %d \n", read_instruction[25:21],read_instruction[20:16],read_instruction[15:0]);

                    default: $display("\n undefined instruction");

                    endcase
            end

        end
        // Close the file after reading
        $fclose(file_handle);
        $display("Description written to '%s'", filename2);
        $fclose(file_handle2);
    endfunction
endclass 



module testbench;
    initial begin
        Random_Instruction test_item;
        bit [ 31 : 0 ] Instruction;

        int file_handle;
        string filename = "output.txt";

        // Open the file for writing
        file_handle = $fopen(filename, "w");
        if (file_handle == 0) begin
            $display("Error opening file for writing");
            $finish;
        end

        for (int i = 0; i < 60; i++) begin
            test_item = new;
            test_item.randomize();
            Instruction = test_item.Instruction();
            $display("Random value: OpCode: %b  | Rs:  %b   
                                                | Rt:  %b   
                                                | Rd:  %b   
                                                | sh:  %b   
                                                | Func:%b  
                                                | Address16: %b 
                                                | Address26: %b ", test_item.Op_Code , test_item.Source,
                                                                   test_item.Source2 , test_item.Dest ,
                                                                   test_item.shamt   , test_item.Inst_function ,
                                                                   test_item.Address_IType , test_item.Address_JType);
            $display("\nInstruction : %b",Instruction);

            $fwrite(file_handle, " %h\n ", Instruction);
        end

        // Close the file
        $fclose(file_handle);

        $display("Data written to '%s'", filename);

        test_item.Monitor();


        $finish;
    end
endmodule

