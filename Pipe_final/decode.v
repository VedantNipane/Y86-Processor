module decode(   input clk,

    // Inputs from D register
    input [2:0] D_stat,
    input [3:0] D_icode,
    input [3:0] D_ifun,
    input [3:0] D_rA,
    input [3:0] D_rB,
    input [63:0] D_valC,
    input [63:0] D_valP,

    // Inputs forwarded from execute stage
    input [3:0] e_dstE,
    input [63:0] e_valE,

    // Inputs forwarded from M register and memory stage
    input [3:0] M_dstE,
    input [63:0] M_valE,
    input [3:0] M_dstM,
    input [63:0] m_valM,

    // Inputs forwarded from W register
    input [3:0] W_dstM,
    input [63:0] W_valM,
    input [3:0] W_dstE,
    input [63:0] W_valE,

    // Outputs
    output reg[63:0] reg_file0,
    output reg[63:0] reg_file1,
    output reg[63:0] reg_file2,
    output reg[63:0] reg_file3,
    output reg[63:0] reg_file4,
    output reg[63:0] reg_file5,
    output reg[63:0] reg_file6,
    output reg[63:0] reg_file7,
    output reg[63:0] reg_file8,
    output reg[63:0] reg_file9,
    output reg[63:0] reg_file10,
    output reg[63:0] reg_file11,
    output reg[63:0] reg_file12,
    output reg[63:0] reg_file13,
    output reg[63:0] reg_file14,

    output reg[2:0] d_stat,
    output reg[3:0] d_icode,
    output reg[3:0] d_ifun,
    output reg[63:0] d_valC,
    output reg[63:0] d_valA,
    output reg[63:0] d_valB,
    output reg[3:0] d_dstE,
    output reg[3:0] d_dstM,
    output reg[3:0] d_srcA,
    output reg[3:0] d_srcB
                );

    reg [63:0] d_valA_temp,d_valB_temp;
    reg [63:0] temp_memo[0:15];

initial begin
    temp_memo[0] = 64'd12;        //rax
    temp_memo[1] = 64'd10;        //rcx
    temp_memo[2] = 64'd101;       //rdx
    temp_memo[3] = 64'd3;         //rbx
    temp_memo[4] = 64'd254;       //rsp
    temp_memo[5] = 64'd50;        //rbp
    temp_memo[6] = -64'd143;      //rsi
    temp_memo[7] = 64'd10000;     //rdi
    temp_memo[8] = 64'd990000;    //r8
    temp_memo[9] = -64'd12345;    //r9
    temp_memo[10] = 64'd12345;    //r10
    temp_memo[11] = 64'd10112;    //r11
    temp_memo[12] = 64'd0;        //r12
    temp_memo[13] = 64'd1567;     //r13
    temp_memo[14] = 64'd8643;     //r14
    temp_memo[15] = 64'd0;        // random register
end

always @(*) begin
        
        d_stat <= D_stat;
        d_icode <= D_icode;
        d_ifun <= D_ifun;
        d_valC <= D_valC;
    end

     always @(posedge clk) begin
        
        temp_memo[W_dstM] <= W_valM;
        temp_memo[W_dstE] <= W_valE;

        reg_file0 = temp_memo[0];
        reg_file1 = temp_memo[1];
        reg_file2 = temp_memo[2];
        reg_file3 = temp_memo[3];
        reg_file4 = temp_memo[4];
        reg_file5 = temp_memo[5];
        reg_file6 = temp_memo[6];
        reg_file7 = temp_memo[7];
        reg_file8 = temp_memo[8];
        reg_file9 = temp_memo[9];
        reg_file10 = temp_memo[10];
        reg_file11 = temp_memo[11];
        reg_file12 = temp_memo[12];
        reg_file13 = temp_memo[13];
        reg_file14 = temp_memo[14];
    end

    always @(*) begin
       
    if (D_icode == 4'd1) begin //cmove
     d_srcA <= 15;
      d_srcB <= 15;
      d_dstE <= 15;
      d_dstM <= 15;

        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
    end    
    else if (D_icode == 4'd2) begin //cmove
         d_srcA <= D_rA;
      d_srcB <= 15;
       d_dstE <= D_rB;
       d_dstM <= 15;

        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
    end
    else if (D_icode == 4'd3) begin //irmove
    d_srcA <= 15;
      d_srcB <= 15;
       d_dstE <= D_rB;
       d_dstM <= 15;

        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
        //Nothing
    end
    else if (D_icode == 4'd4) begin //rmmove
       d_srcA <= D_rA;
       d_srcB <= D_rB;
d_dstE <= 15;
d_dstM <= 15;
        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
    end
    else if (D_icode == 4'd5) begin //mrmove
        d_srcA <= 15;
      d_srcB <= D_rB;
      d_dstE <= 15;
      d_dstM <= D_rA;
        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
    end
    else if (D_icode == 4'd6) begin //opeD_rAtion
     d_srcA <= D_rA;
       d_srcB <= D_rB;
        d_dstE <= D_rB;
        d_dstM <= 15;

        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
    end
    else if (D_icode == 4'd7) begin //jxx
        d_srcA <= 15;
        d_srcB <= 15;
        d_dstE <= 15;
        d_dstM <= 15;
        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
        //Nothing
    end
    else if (D_icode == 4'd8) begin //call Dest
       d_srcA <= 15;
        d_srcB <= 4;
        d_dstE <= 4;
        d_dstM <= 15;
        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
        
    end
    else if (D_icode == 4'd9) begin //ret
       d_srcA <= 4;
      d_srcB <= 4;
  d_dstE <= 4;
  d_dstM <= 15;
        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];

    end
    else if (D_icode == 4'd10) begin //push
        d_srcA <= 4;
      d_srcB <= 4;
  d_dstE <= 4;
  d_dstM <= 15;
        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];

    end
    else if (D_icode == 4'd11) begin //popq D_rA
     d_srcA <= 4;
      d_srcB <= 4;
  d_dstE <= 4;
  d_dstM <= D_rA;
        d_valA_temp = temp_memo[d_srcA];
        d_valB_temp = temp_memo[d_srcB];
    end  

    end


     // Sel+Fwd A Block
    always @(*) begin

        if (D_icode == 4'd7 || D_icode == 4'd8) begin

            d_valA = D_valP;
        end
        else if (d_srcA == e_dstE) begin

            d_valA = e_valE;
        end
        else if (d_srcA == M_dstM) begin

            d_valA = m_valM;
        end
        else if (d_srcA == M_dstE) begin

            d_valA = M_valE;
        end
        else if (d_srcA == W_dstM) begin

            d_valA = W_valM;
        end
        else if (d_srcA == W_dstE) begin

            d_valA = W_valE;
        end
        else begin
            
            d_valA = d_valA_temp;
        end
    end

    // Fwd B Block
    always @(*) begin

        if (d_srcB == e_dstE) begin

            d_valB <= e_valE;
        end
        else if (d_srcB == M_dstM) begin

            d_valB <= m_valM;
        end
        else if (d_srcB == M_dstE) begin

            d_valB <= M_valE;
        end
        else if (d_srcB == W_dstM) begin

            d_valB <= W_valM;
        end
        else if (d_srcB == W_dstE) begin

            d_valB <= W_valE;
        end
        else begin
            
            d_valB <= d_valB_temp;
        end
    end



endmodule

// module D(clk ,f_icode, f_iFun, f_stat, f_rA, f_rB , f_valC, f_valP, D_icode , D_iFun , D_stat , D_rA , D_rB , D_valC , D_valP);
// input clk;
// input[3:0] f_icode,f_iFun,f_rA,f_rB;
// input[2:0] f_stat;
// input[63:0] f_valC,f_valP;

// output reg[3:0] D_icode,D_iFun,D_rA,D_rB;
// output reg[2:0] D_stat;
// output reg[63:0] D_valC,D_valP;

// always @(posedge clk ) begin
//     D_icode <= f_icode;
//     D_iFun <= f_iFun;
//     D_stat <= f_stat;
//     D_rA <= f_rA;
//     D_rB <= f_rB;
//     D_valC <= f_valC;
//     D_valP <= f_valP; 

// end

// endmodul