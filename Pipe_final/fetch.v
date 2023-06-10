module fetch(
       input [63:0] F_predPC,
    input [3:0] M_icode,
    input M_Cnd,
    input [63:0] M_valA,
    input [3:0] W_icode,
    input [63:0] W_valM,

    // Outputs
    output [2:0] f_stat,
    output reg[3:0] f_icode,
    output reg[3:0] f_ifun,
    output reg[3:0] f_rA,
    output reg[3:0] f_rB,
    output reg[63:0] f_valC,
    output reg[63:0] f_valP,
    output [63:0] f_predPC
);

reg [7:0] inst_memo[0:127];
reg [0:7] temp;
reg invalid_instr, memory_error, halt;

initial begin
    halt = 0;
//     inst_memo[0]  = 8'b00010000; // nop instruction f_PC = f_PC +1 = 1
//     inst_memo[1]  = 8'b01100000; // Opq add
//     inst_memo[2]  = 8'b00100001; // f_rA = 0, f_rB = 1; f_PC = f_PC + 2 = 3

//     inst_memo[3]  = 8'b00110000; // irmovq instruction f_PC = f_PC + 10 = 13
//     inst_memo[4]  = 8'b11110010; // F, f_rB = 2;
//     inst_memo[5]  = 8'b00000000; // 1st byte of V = 5, rest all bytes will be zero
//     inst_memo[6]  = 8'b00000000; // 2nd byte
//     inst_memo[7]  = 8'b00000000; // 3rd byte
//     inst_memo[8]  = 8'b00000000; // 4th byte
//     inst_memo[9]  = 8'b00000000; // 5th byte
//     inst_memo[10] = 8'b00000000; // 6th byte
//     inst_memo[11] = 8'b00000000; // 7th byte
//     inst_memo[12] = 8'b00000101; // 8th byte (This completes irmovq)

//     inst_memo[13] = 8'b00110000; // mrmovq instruction f_PC = f_PC + 10 = 23
//     inst_memo[14] = 8'b11110011; // F, f_rB = 3;
//     inst_memo[22] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
//     inst_memo[16] = 8'b00000000; // 2nd byte
//     inst_memo[17] = 8'b00000000; // 3rd byte
//     inst_memo[18] = 8'b00000000; // 4th byte
//     inst_memo[19] = 8'b00000000; // 5th byte
//     inst_memo[20] = 8'b00000000; // 6th byte
//     inst_memo[21] = 8'b00000000; // 7th byte
//     inst_memo[15] = 8'b00000000; // 8th byte (This completes irmovq)

//     inst_memo[23] = 8'b00110000; // irmovq instruction f_PC = f_PC + 10 = 33
//     inst_memo[24] = 8'b11111100; // F, f_rB = 12;
//     inst_memo[32] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
//     inst_memo[26] = 8'b00000000; // 2nd byte
//     inst_memo[27] = 8'b00000000; // 3rd byte
//     inst_memo[28] = 8'b00000000; // 4th byte
//     inst_memo[29] = 8'b00000000; // 5th byte
//     inst_memo[30] = 8'b00000000; // 6th byte
//     inst_memo[31] = 8'b00000000; // 7th byte
//     inst_memo[25] = 8'b00000000; // 8th byte (This completes irmovq)

//     inst_memo[33] = 8'b01100000; // Opq add // f_PC = f_PC + 2 = 37
//     inst_memo[34] = 8'b00111100; // f_rA = 3 and f_rB = 12, final value in f_rB(4) = 10;

  

//     inst_memo[37] = 8'b00100000; // rrmovq // f_PC = f_PC + 2 = 35
//     inst_memo[38] = 8'b11000110; // f_rA = 12; f_rB = 5; 

//     inst_memo[35] = 8'b00100101; // cmovge // f_PC = f_PC + 2 = 39
//     inst_memo[36] = 8'b01100011; // f_rA = 5; f_rB = 6;
    
//   inst_memo[39] = 8'b01100001; // Opq subq // f_PC = f_PC + 2 = 41
//     inst_memo[40] = 8'b11000110; // f_rA = 3, f_rB = 5; both are equal
   

//     inst_memo[41] = 8'b01110011; //je // f_PC = f_PC + 9 = 50
//     inst_memo[49] = 8'b00110110; // Dest = 53; 1st byte
//     inst_memo[43] = 8'b00000000; // 2nd byte
//     inst_memo[44] = 8'b00000000; // 3rd byte
//     inst_memo[45] = 8'b00000000; // 4th byte
//     inst_memo[46] = 8'b00000000; // 5th byte
//     inst_memo[47] = 8'b00000000; // 6th byte
//     inst_memo[48] = 8'b00000000; // 7th byte
//     inst_memo[42] = 8'b00000000; // 8th byte

//     inst_memo[50] = 8'b00010000; // nop 

//     // inst_memo[51] = 8'b01100001; // Opq add
//     // inst_memo[52] = 8'b00110101; // f_rA = 3; f_rB = 5;
//     inst_memo[53] = 8'b00010000;
//      // nop
//     inst_memo[54] = 8'b10000000; //je // f_PC = f_PC + 9 = 50
//     inst_memo[62] = 8'b01000110; // Dest = 53; 1st byte
//     inst_memo[56] = 8'b00000000; // 2nd byte
//     inst_memo[57] = 8'b00000000; // 3rd byte
//     inst_memo[58] = 8'b00000000; // 4th byte
//     inst_memo[59] = 8'b00000000; // 5th byte
//     inst_memo[60] = 8'b00000000; // 6th byte
//     inst_memo[61] = 8'b00000000; // 7th byte
//     inst_memo[55] = 8'b00000000; 

//     inst_memo[69] = 8'b00010000; 


//      inst_memo[70] = 8'b00110000; // irmovq instruction f_PC = f_PC + 10 = 33
//     inst_memo[71] = 8'b11111010; // F, f_rB = 10;
//     inst_memo[79] = 8'b01100101; // 1st byte of V = 101, rest all bytes will be zero
//     inst_memo[73] = 8'b00000000; // 2nd byte
//     inst_memo[74] = 8'b00000000; // 3rd byte
//     inst_memo[75] = 8'b00000000; // 4th byte
//     inst_memo[76] = 8'b00000000; // 5th byte
//     inst_memo[77] = 8'b00000000; // 6th byte
//     inst_memo[78] = 8'b00000000; // 7th byte
//     inst_memo[72] = 8'b00000000; 

//     inst_memo[80] = 8'b01000000; // rmmovq instruction f_PC = f_PC + 10 = 33
//     inst_memo[81] = 8'b10100111; // 10, f_rB = 7;
//     inst_memo[82] = 8'b00000000; // 1st byte of V = 5, rest all bytes will be zero
//     inst_memo[83] = 8'b00000000; // 2nd byte
//     inst_memo[84] = 8'b00000000; // 3rd byte
//     inst_memo[85] = 8'b00000000; // 4th byte
//     inst_memo[86] = 8'b00000000; // 5th byte
//     inst_memo[87] = 8'b00000000; // 6th byte
//     inst_memo[88] = 8'b00000000; // 7th byte
//     inst_memo[89] = 8'b00000000; 

//  inst_memo[90] = 8'b00110000; // irmovq instruction f_PC = f_PC + 10 = 33
//     inst_memo[91] = 8'b11110010; // F, f_rB = 10;
//     inst_memo[99] = 8'b00000000; // 1st byte of V = 100, rest all bytes will be zero
//     inst_memo[93] = 8'b00000000; // 2nd byte
//     inst_memo[94] = 8'b00000000; // 3rd byte
//     inst_memo[95] = 8'b00000000; // 4th byte
//     inst_memo[96] = 8'b00000000; // 5th byte
//     inst_memo[97] = 8'b00000000; // 6th byte
//     inst_memo[98] = 8'b00000000; // 7th byte
//     inst_memo[92] = 8'b00000000; 


    // inst_memo[100] = 8'b10010000; //ret
    // inst_memo[101] = 8'b00010000; // nop
    // inst_memo[102] = 8'b00000000; // halt


inst_memo[0] = 8'h10;
        inst_memo[1]  = 8'h10; //nop
// inst_memo[2] = 8'h10; //halt

inst_memo[2] = 8'h20; //rrmovq
inst_memo[3] = 8'h12;
// inst_memo[4]= 8'h00;

inst_memo[4] = 8'h30; //irmovq
inst_memo[5] = 8'hF2;
inst_memo[6] = 8'h00;
inst_memo[7] = 8'h00;
inst_memo[8] = 8'h00;
inst_memo[9] = 8'h00;
inst_memo[10] = 8'h00;
inst_memo[11] = 8'h00;
inst_memo[12] = 8'h00;
inst_memo[13] = 8'b00000010;
// inst_memo[14]=8'h00;

inst_memo[14] = 8'h40; //rmmovq
inst_memo[15] = 8'h24;
{inst_memo[16],inst_memo[17],inst_memo[18],inst_memo[19],inst_memo[20],inst_memo[21],inst_memo[22],inst_memo[23]} = 64'd1;
// inst_memo[24]=8'h00;

inst_memo[24] = 8'h40; //rmmovq
inst_memo[25] = 8'h53;
{inst_memo[26],inst_memo[27],inst_memo[28],inst_memo[29],inst_memo[30],inst_memo[31],inst_memo[32],inst_memo[33]} = 64'd0;
// inst_memo[34] = 8'h00;
inst_memo[34] = 8'h50; //mrmovq
inst_memo[35] = 8'h53;
{inst_memo[36],inst_memo[37],inst_memo[38],inst_memo[39],inst_memo[40],inst_memo[41],inst_memo[42],inst_memo[43]} = 64'd0;
// inst_memo[44]=8'h00;

inst_memo[44] = 8'h60; //opq
inst_memo[45] = 8'h9A;
        // inst_memo[46]  = 8'h10; //nop
// inst_memo[46] = 8'h00; //halt



inst_memo[46] = 8'h73; //jmp
// {inst_memo[47],inst_memo[48],inst_memo[49],inst_memo[50],inst_memo[51],inst_memo[52],inst_memo[53],inst_memo[54]} = 64'd56;
inst_memo[54]=8'd56;
{inst_memo[47],inst_memo[48],inst_memo[49],inst_memo[50],inst_memo[51],inst_memo[52],inst_memo[53]}=56'd0;

inst_memo[55] = 8'h00; //halt

inst_memo[56] = 8'hA0; // pushq
inst_memo[57] = 8'h9F;

inst_memo[58] = 8'hB0; //popq
inst_memo[59] = 8'h9F;

inst_memo[60] = 8'h80; //call
{inst_memo[61],inst_memo[62],inst_memo[63],inst_memo[64],inst_memo[65],inst_memo[66],inst_memo[67],inst_memo[68]} = 64'd80;

inst_memo[69] = 8'h60; //opq
inst_memo[70] = 8'h56;

// inst_memo[71] = 8'h00;
inst_memo[71] = 8'h72; //jmp
{inst_memo[72],inst_memo[73],inst_memo[74],inst_memo[75],inst_memo[76],inst_memo[77],inst_memo[78],inst_memo[79]} = 64'd46;

inst_memo[80]=8'h10;
inst_memo[81] = 8'h63; //opq
inst_memo[82] = 8'hDE;
// inst_memo[80] = 8'h10;

inst_memo[83]=8'h90;
end

wire [63:0] f_PC;

select pc_obt(
       .F_predPC(F_predPC),
        .M_icode(M_icode),
        .M_Cnd(M_Cnd),
        .M_valA(M_valA),    
        .W_icode(W_icode),
        .W_valM(W_valM),

        // Outputs
    .f_PC(f_PC)
);

wire [63:0] f_predPC;

pred pc_pred(
    .f_icode(f_icode),
    .f_valC(f_valC),
    .f_valP(f_valP),
    .f_predPC(f_predPC)
);   

Stat stat_mod(
    // Inputs
    .invalid_instr(invalid_instr),
    .memory_error(memory_error),
    .f_icode(f_icode),
    .f_stat(f_stat)
);


// always @(*) begin
//     f_pred = f_predPC;
// end
always @(*) begin
    if(f_icode >= 4'b0000 && f_icode <4'b1100)
    begin
        invalid_instr = 0;
    end
    else begin
        invalid_instr = 1;
    end
    memory_error = 0;
    if(f_PC >102)
    begin
        memory_error = 1;
    end
end

            always @(*) begin
                //memory_error = 0;
                if(f_PC >102)
                begin
                    //memory_error = 1;
                end

                f_icode = inst_memo[f_PC][7:4];
                f_ifun = inst_memo[f_PC][3:0];

                if(f_icode >= 4'b0000 && f_icode <4'b1100)
                begin

                   // invalid_instr = 0;

                    case (f_icode)

                    4'b0000: //halt
                    begin
                        f_rA = 15;
                        f_rB = 15;
                        halt = 1;
                    end

                    4'b0001://nop
                    begin
                        f_rA = 15;
                        f_rB = 15;
                        f_valC = 0;
                        f_valP = f_PC + 64'd1;
                    end

                    4'b0011://irmove
                    begin
                        temp = {inst_memo[f_PC+1]}; 
                        f_rA = temp[0:3];
                        f_rB = temp[4:7];
                        f_valC = { inst_memo[f_PC+2],
                        inst_memo[f_PC+3],inst_memo[f_PC+4],
                        inst_memo[f_PC+5],inst_memo[f_PC+6],
                        inst_memo[f_PC+7],inst_memo[f_PC+8],
                        inst_memo[f_PC+9]
                        };
                         
                         f_valP = f_PC + 64'd10;
                    end

                    4'b0101://mrmove
                    begin
                           temp = {inst_memo[f_PC+1]};
                        f_rA = temp[0:3]; 
                        f_rB = temp[4:7];
                        f_valC = { inst_memo[f_PC+2],
                        inst_memo[f_PC+3],inst_memo[f_PC+4],
                        inst_memo[f_PC+5],inst_memo[f_PC+6],
                        inst_memo[f_PC+7],inst_memo[f_PC+8],
                        inst_memo[f_PC+9]
                        };
                         
                         f_valP = f_PC + 64'd10;
                    end

                    4'b0100://rmmove
                    begin
                          temp = {inst_memo[f_PC+1]}; 
                        f_rA = temp[0:3];
                        f_rB = temp[4:7];
                         f_valC = { inst_memo[f_PC+2],
                        inst_memo[f_PC+3],inst_memo[f_PC+4],
                        inst_memo[f_PC+5],inst_memo[f_PC+6],
                        inst_memo[f_PC+7],inst_memo[f_PC+8],
                        inst_memo[f_PC+9]
                        };
                         
                         f_valP = f_PC + 64'd10;
                    end
                    
                    4'b0010://cmove
                    begin
                          temp = {inst_memo[f_PC+1]}; 
                        f_rA = temp[0:3];
                        f_rB = temp[4:7];
                        f_valC = 0;
                         f_valP = f_PC + 64'd2;
                    end

                     4'b0110://opq
                    begin
                          temp = {inst_memo[f_PC+1]}; 
                        f_rA = temp[0:3];
                        f_rB = temp[4:7];
                        f_valC = 0;
                         f_valP = f_PC + 64'd2;
                    end

                     4'b1010://push
                    begin
                          temp = {inst_memo[f_PC+1]}; 
                        f_rA = temp[0:3];
                        f_rB = temp[4:7];

                         f_valP = f_PC + 64'd2;
                    end 4'b1011://pop
                    begin
                           temp = {inst_memo[f_PC+1]}; 
                        f_rA = temp[0:3];
                        f_rB = temp[4:7];
                        f_valC = 0;

                         f_valP = f_PC + 64'd2;
                    end

                     4'b0111://jxx
                    begin
                        f_rA = 15;
                        f_rB = 15;
                        f_valC = { inst_memo[f_PC+1],
                        inst_memo[f_PC+2],inst_memo[f_PC+3],
                        inst_memo[f_PC+4],inst_memo[f_PC+5],
                        inst_memo[f_PC+6],inst_memo[f_PC+7],
                        inst_memo[f_PC+8]
                        };
                         
                         f_valP = f_PC + 64'd9;
                    end
                     4'b1000://call
                    begin
                        f_rA = 15;
                        f_rB = 15;
                        f_valC = { inst_memo[f_PC+1],
                        inst_memo[f_PC+2],inst_memo[f_PC+3],
                        inst_memo[f_PC+4],inst_memo[f_PC+5],
                        inst_memo[f_PC+6],inst_memo[f_PC+7],
                        inst_memo[f_PC+8]
                        };
                         f_valP = f_PC + 64'd9;
                    end
                     4'b1001://ret
                    begin
                        f_rA = 15;
                        f_rB = 15;
                        f_valC = 0;
                        f_valP= f_PC + 64'd1;                         
                    end
                    
                    endcase
                end
                else 
                begin
                    //invalid_instr = 1;
                end
            end 
endmodule


// module F(clk , pred_f_PC , F_predf_PC);
// input clk;
// input [63:0] pred_f_PC;
// output reg[63:0] F_predf_PC;

// initial begin
//     F_predf_PC = 64'b0;
// end

// always@(posedge clk)
// begin
//     F_predf_PC <= pred_f_PC;

// end

// endmodule

/////////////////////////////////////
//To predict next PC value
module pred (   
  input [3:0] f_icode,
    input [63:0] f_valC,
    input [63:0] f_valP,

    // Outputs
    output reg[63:0] f_predPC

);

     always @(*) begin 

        if (f_icode == 4'b0111 || f_icode == 4'b1000 ) begin

            f_predPC <= f_valC;
        end
        else begin

            f_predPC <= f_valP;
        end
    end
    
    // always @(*) begin
    //     if
    // end
endmodule

//
module select (
    // Inputs
      input [63:0] F_predPC,
    input [3:0] M_icode,
    input M_Cnd,
    input [63:0] M_valA,
    input [3:0] W_icode,
    input [63:0] W_valM,

    // Outputs
    output reg[63:0] f_PC
);

 always @(*) begin
        
        if (M_icode == 4'b0111 && M_Cnd == 0) begin
            f_PC <= M_valA;
        end
        else if (W_icode == 9) begin
            
            f_PC <= W_valM;
        end
        else begin

            f_PC <= F_predPC;
        end
    end
endmodule

module Stat(
    // Inputs
    input invalid_instr,
    input memory_error,
    input [3:0] f_icode,

    // Outputs
    output reg[2:0] f_stat
);

    always @(*) begin

        if (memory_error == 1) begin

            f_stat <= 3;
        end 
        else if (invalid_instr == 1) begin
            f_stat <= 4;
        end
        else if (f_icode == 0) begin

            f_stat <= 2;
        end
        else begin

            f_stat <= 1;
        end

    end
endmodule