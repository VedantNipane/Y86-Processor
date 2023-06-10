module fetch(clk, PC, icode, ifun, rA, rB, valC, valP,
             memory_error, halt, invalid_instr);

            input clk;
            input [63:0]PC ;
            reg [0:7] temp;

            output reg [3:0] icode, ifun, rA,rB;
            output reg [63:0] valC,valP;
            output reg halt,invalid_instr,memory_error;

            reg [7:0] inst_memo[0:127];


initial begin
    halt = 0;
    inst_memo[0]  = 8'b00010000; // nop instruction PC = PC +1 = 1
    inst_memo[1]  = 8'b01100000; // Opq add
    inst_memo[2]  = 8'b00100001; // rA = 0, rB = 1; PC = PC + 2 = 3

    inst_memo[3]  = 8'b00110000; // irmovq instruction PC = PC + 10 = 13
    inst_memo[4]  = 8'b11110010; // F, rB = 2;
    inst_memo[5]  = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    inst_memo[6]  = 8'b00000000; // 2nd byte
    inst_memo[7]  = 8'b00000000; // 3rd byte
    inst_memo[8]  = 8'b00000000; // 4th byte
    inst_memo[9]  = 8'b00000000; // 5th byte
    inst_memo[10] = 8'b00000000; // 6th byte
    inst_memo[11] = 8'b00000000; // 7th byte
    inst_memo[12] = 8'b00000000; // 8th byte (This completes irmovq)

    inst_memo[13] = 8'b00110000; // mrmovq instruction PC = PC + 10 = 23
    inst_memo[14] = 8'b11110011; // F, rB = 3;
    inst_memo[15] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    inst_memo[16] = 8'b00000000; // 2nd byte
    inst_memo[17] = 8'b00000000; // 3rd byte
    inst_memo[18] = 8'b00000000; // 4th byte
    inst_memo[19] = 8'b00000000; // 5th byte
    inst_memo[20] = 8'b00000000; // 6th byte
    inst_memo[21] = 8'b00000000; // 7th byte
    inst_memo[22] = 8'b00000000; // 8th byte (This completes irmovq)

    inst_memo[23] = 8'b00110000; // irmovq instruction PC = PC + 10 = 33
    inst_memo[24] = 8'b11111100; // F, rB = 12;
    inst_memo[25] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    inst_memo[26] = 8'b00000000; // 2nd byte
    inst_memo[27] = 8'b00000000; // 3rd byte
    inst_memo[28] = 8'b00000000; // 4th byte
    inst_memo[29] = 8'b00000000; // 5th byte
    inst_memo[30] = 8'b00000000; // 6th byte
    inst_memo[31] = 8'b00000000; // 7th byte
    inst_memo[32] = 8'b00000000; // 8th byte (This completes irmovq)

    inst_memo[33] = 8'b01100000; // Opq add // PC = PC + 2 = 37
    inst_memo[34] = 8'b00111100; // rA = 3 and rB = 12, final value in rB(4) = 10;

  

    inst_memo[37] = 8'b00100000; // rrmovq // PC = PC + 2 = 35
    inst_memo[38] = 8'b11000110; // rA = 12; rB = 5; 

    inst_memo[35] = 8'b00100101; // cmovge // PC = PC + 2 = 39
    inst_memo[36] = 8'b01100011; // rA = 5; rB = 6;
    
  inst_memo[39] = 8'b01100001; // Opq subq // PC = PC + 2 = 41
    inst_memo[40] = 8'b11000110; // rA = 3, rB = 5; both are equal
   

    inst_memo[41] = 8'b01110011; //je // PC = PC + 9 = 50
    inst_memo[42] = 8'b00110101; // Dest = 53; 1st byte
    inst_memo[43] = 8'b00000000; // 2nd byte
    inst_memo[44] = 8'b00000000; // 3rd byte
    inst_memo[45] = 8'b00000000; // 4th byte
    inst_memo[46] = 8'b00000000; // 5th byte
    inst_memo[47] = 8'b00000000; // 6th byte
    inst_memo[48] = 8'b00000000; // 7th byte
    inst_memo[49] = 8'b00000000; // 8th byte

    inst_memo[50] = 8'b00010000; // nop 

    // inst_memo[51] = 8'b01100001; // Opq add
    // inst_memo[52] = 8'b00110101; // rA = 3; rB = 5;
    inst_memo[53] = 8'b00010000; // nop
    inst_memo[54] = 8'b10000000; //je // PC = PC + 9 = 50
    inst_memo[55] = 8'b01000101; // Dest = 53; 1st byte
    inst_memo[56] = 8'b00000000; // 2nd byte
    inst_memo[57] = 8'b00000000; // 3rd byte
    inst_memo[58] = 8'b00000000; // 4th byte
    inst_memo[59] = 8'b00000000; // 5th byte
    inst_memo[60] = 8'b00000000; // 6th byte
    inst_memo[61] = 8'b00000000; // 7th byte
    inst_memo[62] = 8'b00000000; 

    inst_memo[69] = 8'b00010000; 


     inst_memo[70] = 8'b00110000; // irmovq instruction PC = PC + 10 = 33
    inst_memo[71] = 8'b11111010; // F, rB = 10;
    inst_memo[72] = 8'b01100101; // 1st byte of V = 101, rest all bytes will be zero
    inst_memo[73] = 8'b00000000; // 2nd byte
    inst_memo[74] = 8'b00000000; // 3rd byte
    inst_memo[75] = 8'b00000000; // 4th byte
    inst_memo[76] = 8'b00000000; // 5th byte
    inst_memo[77] = 8'b00000000; // 6th byte
    inst_memo[78] = 8'b00000000; // 7th byte
    inst_memo[79] = 8'b00000000; 

    inst_memo[80] = 8'b01000000; // rmmovq instruction PC = PC + 10 = 33
    inst_memo[81] = 8'b10100111; // 10, rB = 7;
    inst_memo[82] = 8'b00000000; // 1st byte of V = 5, rest all bytes will be zero
    inst_memo[83] = 8'b00000000; // 2nd byte
    inst_memo[84] = 8'b00000000; // 3rd byte
    inst_memo[85] = 8'b00000000; // 4th byte
    inst_memo[86] = 8'b00000000; // 5th byte
    inst_memo[87] = 8'b00000000; // 6th byte
    inst_memo[88] = 8'b00000000; // 7th byte
    inst_memo[89] = 8'b00000000; 

 inst_memo[90] = 8'b00110000; // irmovq instruction PC = PC + 10 = 33
    inst_memo[91] = 8'b11110100; // F, rB = 10;
    inst_memo[92] = 8'b00000000; // 1st byte of V = 100, rest all bytes will be zero
    inst_memo[93] = 8'b00000000; // 2nd byte
    inst_memo[94] = 8'b00000000; // 3rd byte
    inst_memo[95] = 8'b00000000; // 4th byte
    inst_memo[96] = 8'b00000000; // 5th byte
    inst_memo[97] = 8'b00000000; // 6th byte
    inst_memo[98] = 8'b00000000; // 7th byte
    inst_memo[99] = 8'b00000000; 


    inst_memo[100] = 8'b10010000; //ret

    




    inst_memo[101] = 8'b00010000; // nop
    inst_memo[102] = 8'b00000000; // halt
end

            



            always @(*) begin
                memory_error = 0;
                if(PC >102)
                begin
                    memory_error = 1;
                end

                icode = inst_memo[PC][7:4];
                ifun = inst_memo[PC][3:0];

                if(icode >= 4'b0000 && icode <4'b1100)
                begin

                    invalid_instr = 0;

                    case (icode)

                    4'b0000: //halt
                    begin
                        halt = 1;
                    end

                    4'b0001://nop
                    begin
                        valP = PC + 64'd1;
                    end

                    4'b0011://irmove
                    begin
                        temp = {inst_memo[PC+1]}; 
                        rA = temp[0:3];
                        rB = temp[4:7];
                        valC = { inst_memo[PC+9],
                        inst_memo[PC+8],inst_memo[PC+7],
                        inst_memo[PC+6],inst_memo[PC+5],
                        inst_memo[PC+4],inst_memo[PC+3],
                        inst_memo[PC+2]
                        };
                         
                         valP = PC + 64'd10;
                    end

                    4'b0101://mrmove
                    begin
                           temp = {inst_memo[PC+1]};
                        rA = temp[0:3]; 
                        rB = temp[4:7];
                        valC = { inst_memo[PC+9],
                        inst_memo[PC+8],inst_memo[PC+7],
                        inst_memo[PC+6],inst_memo[PC+5],
                        inst_memo[PC+4],inst_memo[PC+3],
                        inst_memo[PC+2]
                        };
                         
                         valP = PC + 64'd10;
                    end

                    4'b0100://rmmove
                    begin
                          temp = {inst_memo[PC+1]}; 
                        rA = temp[0:3];
                        rB = temp[4:7];
                        valC = { inst_memo[PC+9],
                        inst_memo[PC+8],inst_memo[PC+7],
                        inst_memo[PC+6],inst_memo[PC+5],
                        inst_memo[PC+4],inst_memo[PC+3],
                        inst_memo[PC+2]
                        };
                         
                         valP = PC + 64'd10;
                    end
                    
                    4'b0010://cmove
                    begin
                          temp = {inst_memo[PC+1]}; 
                        rA = temp[0:3];
                        rB = temp[4:7];

                         valP = PC + 64'd2;
                    end

                     4'b0110://opq
                    begin
                          temp = {inst_memo[PC+1]}; 
                        rA = temp[0:3];
                        rB = temp[4:7];

                         valP = PC + 64'd2;
                    end

                     4'b1010://push
                    begin
                          temp = {inst_memo[PC+1]}; 
                        rA = temp[0:3];
                        rB = temp[4:7];

                         valP = PC + 64'd2;
                    end 4'b1011://pop
                    begin
                           temp = {inst_memo[PC+1]}; 
                        rA = temp[0:3];
                        rB = temp[4:7];

                         valP = PC + 64'd2;
                    end

                     4'b0111://jxx
                    begin
                        valC = { inst_memo[PC+8],
                        inst_memo[PC+7],inst_memo[PC+6],
                        inst_memo[PC+5],inst_memo[PC+4],
                        inst_memo[PC+3],inst_memo[PC+2],
                        inst_memo[PC+1]
                        };
                         
                         valP = PC + 64'd9;
                    end
                     4'b1000://call
                    begin
                        valC = { inst_memo[PC+8],
                        inst_memo[PC+7],inst_memo[PC+6],
                        inst_memo[PC+5],inst_memo[PC+4],
                        inst_memo[PC+3],inst_memo[PC+2],
                        inst_memo[PC+1]
                        };
                         
                         valP = PC + 64'd9;
                    end
                     4'b1001://ret
                    begin
                        valC = PC + 64'd1;                         
                    end
                    
                    endcase
                end
                else 
                begin
                    invalid_instr = 1;
                end
            end 
endmodule
