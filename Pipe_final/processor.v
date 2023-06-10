`timescale 1ns/1ps
`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "control.v"

module processor();
  
  reg clk;
  reg [2:0 ]status_code;
  
  //________________FETCH_____________________
  // F stage registers
  reg [63:0] F_predPC = 0;

  // Fetch Stage output
  wire [63:0] f_valC;
  wire [63:0] f_valP;
  wire [63:0] f_predPC;
  wire [2:0] f_stat;
  wire [3:0] f_icode;
  wire [3:0] f_ifun;
  wire [3:0] f_rA;
  wire [3:0] f_rB;
  //________________DECODE_____________________
  // D stage registers
  reg [3:0] D_icode = 1;
  reg [3:0] D_ifun = 0; 
  reg [2:0] D_stat = 1;
  reg [63:0] D_valC = 0;
  reg [63:0] D_valP = 0;
  reg [3:0] D_rA = 0;
  reg [3:0] D_rB = 0;

  // Decode Stage Output
  wire [2:0] d_stat;
  wire [3:0] d_icode;
  wire [3:0] d_ifun;
  wire [3:0] d_dstE;
  wire [3:0] d_srcB;
  wire [3:0] d_dstM;
  wire [3:0] d_srcA;
  wire [63:0] d_valC;
  wire [63:0] d_valA;
  wire [63:0] d_valB;


    wire signed[63:0] reg_file0;
    wire signed[63:0] reg_file1;
    wire signed[63:0] reg_file2;
    wire signed[63:0] reg_file3;
    wire signed[63:0] reg_file4;
    wire signed[63:0] reg_file5;
    wire signed[63:0] reg_file6;
    wire signed[63:0] reg_file7;
    wire signed[63:0] reg_file8;
    wire signed[63:0] reg_file9;
    wire signed[63:0] reg_file10;
    wire signed[63:0] reg_file11;
    wire signed[63:0] reg_file12;
    wire signed[63:0] reg_file13;
    wire signed[63:0] reg_file14;

  
  //________________EXECUTE_____________________
  //E stage registers
  reg [2:0] E_stat = 1;
  reg [3:0] E_icode = 1;
  reg [3:0] E_ifun = 0;
  reg [3:0] E_dstE = 0;
  reg [3:0] E_dstM = 0;
  reg [3:0] E_srcA = 0;
  reg [3:0] E_srcB = 0;
  reg [63:0] E_valC = 0;
  reg [63:0] E_valA = 0;
  reg [63:0] E_valB = 0;
  reg [63:0] E_valP = 0;


  // Execute stage output
  wire e_Cnd;
  wire [2:0] e_stat;
  wire [3:0] e_icode;
  wire [3:0] e_dstE;
  wire [3:0] e_dstM;
  wire [63:0] e_valE;
  wire [63:0] e_valA;
  wire [63:0] e_valC;

  wire ZF;
  wire SF;
  wire OF;
  //________________MEMORY_____________________
  //M stage register
  reg M_Cnd = 0;
  reg [2:0] M_stat = 1;
  reg [3:0] M_icode = 1;
  reg [3:0] M_dstE = 0;
  reg [3:0] M_dstM = 0;
  reg [63:0] M_valE = 0;
  reg [63:0] M_valA = 0;
  reg [63:0] M_valC = 0;


  // Memory stage output
  wire [2:0] m_stat;
  wire [3:0] m_icode;
  wire [63:0] m_valE;
  wire [63:0] m_valM;
  wire [3:0] m_dstE;
  wire [3:0] m_dstM;


  //________________WRITEBACK_____________________
  // W stage register
  reg [2:0] W_stat = 1;
  reg [3:0] W_icode = 1;
  reg [3:0] W_dstE = 0;
  reg [3:0] W_dstM = 0;
  reg [63:0] W_valE = 0;
  reg [63:0] W_valM = 0; 
  reg [63:0] W_valP = 0;

  
fetch fetch_stage(
    .F_predPC(F_predPC),

    .M_valA(M_valA),
    .M_icode(M_icode),
    .M_Cnd(M_Cnd),

    .W_icode(W_icode),
    .W_valM(W_valM),

    .f_stat(f_stat),
    .f_icode(f_icode),
    .f_ifun(f_ifun),
    .f_rA(f_rA),
    .f_rB(f_rB),
    .f_valC(f_valC),
    .f_valP(f_valP),
    .f_predPC(f_predPC)
);
  decode decode_stage(
    .clk(clk),
    .D_stat(D_stat),
    .D_icode(D_icode),
    .D_ifun(D_ifun),
    .D_rA(D_rA),
    .D_rB(D_rB),
    .D_valC(D_valC),
    .D_valP(D_valP),

    .e_dstE(e_dstE),
    .e_valE(e_valE),

    .M_dstE(M_dstE),
    .M_valE(M_valE),
    .M_dstM(M_dstM),
    .m_valM(m_valM),

    .W_dstM(W_dstM),
    .W_valM(W_valM),
    .W_dstE(W_dstE),
    .W_valE(W_valE),

    .d_valA(d_valA),
    .d_valB(d_valB),
    .d_dstE(d_dstE),
    .d_stat(d_stat),
    .d_icode(d_icode),
    .d_ifun(d_ifun),
    .d_valC(d_valC),
    .d_dstM(d_dstM),
    .d_srcA(d_srcA),
    .d_srcB(d_srcB),

    .reg_file0(reg_file0),
    .reg_file1(reg_file1),
    .reg_file2(reg_file2),
    .reg_file3(reg_file3),
    .reg_file4(reg_file4),
    .reg_file5(reg_file5),
    .reg_file6(reg_file6),
    .reg_file7(reg_file7),
    .reg_file8(reg_file8),
    .reg_file9(reg_file9),
    .reg_file10(reg_file10),
    .reg_file11(reg_file11),
    .reg_file12(reg_file12),
    .reg_file13(reg_file13),
    .reg_file14(reg_file14)
  );
  execute execute_stage(
    .clk(clk),

    .E_stat(E_stat),
    .E_icode(E_icode),
    .E_ifun(E_ifun),
    .E_valC(E_valC),
    .E_valA(E_valA),
    .E_valB(E_valB),
    .E_dstE(E_dstE),
    .E_dstM(E_dstM),
    .W_stat(W_stat),
    .m_stat(m_stat),

    .e_stat(e_stat),
    .e_icode(e_icode),
    .e_Cnd(e_Cnd),
    .e_valE(e_valE),
    .e_valA(e_valA),
    .e_dstE(e_dstE),
    .e_dstM(e_dstM),
    .ZF(ZF),
    .SF(SF),
    .OF(OF)
    );


  memory m(
    .clk(clk),

    .M_stat(M_stat),
    .M_icode(M_icode),
    .M_valE(M_valE),
    .M_valA(M_valA),
    .M_dstE(M_dstE),
    .M_dstM(M_dstM),

    .m_stat(m_stat),
    .m_icode(m_icode),
    .m_valE(m_valE),
    .m_valM(m_valM),
    .m_dstE(m_dstE),
    .m_dstM(m_dstM)
    );

wire W_stall,F_stall, M_bubble, E_bubble, D_bubble, D_stall; 

  control control_stage(
    // Inputs
    .D_icode(D_icode),
    .d_srcA(d_srcA),
    .d_srcB(d_srcB),
    .E_icode(E_icode),
    .E_dstM(E_dstM),
    .e_Cnd(e_Cnd),
    .M_icode(M_icode),//Wire or reg
    .m_stat(m_stat),
    .W_stat(W_stat),//Wire or reg

    // Outputs
    .W_stall(W_stall),
    .M_bubble(M_bubble),
    .E_bubble(E_bubble),
    .D_bubble(D_bubble),
    .D_stall(D_stall),
    .F_stall(F_stall)
    );

always @(posedge clk) begin      
  if (F_stall == 0) begin
    F_predPC <= f_predPC;
  end
end

always @(posedge clk) begin      
  if (D_stall == 0) begin
    if (D_bubble == 0) begin
      D_stat <= f_stat;
      D_icode <= f_icode;
      D_ifun <= f_ifun;
      D_rA <= f_rA;
      D_rB <= f_rB;
      D_valC <= f_valC;
      D_valP <= f_valP;
    end
    else begin
      D_stat <= 1;
      D_icode <= 1;
      D_ifun <= 0;
      D_rA <= 0;
      D_rB <= 0;
      D_valC <= 0;
      D_valP <= 0;
    end
  end
end


always @(posedge clk) begin      
    if (E_bubble == 0) begin
      E_stat <= d_stat;
      E_icode <= d_icode;
      E_ifun <= d_ifun;
      E_srcA <= d_srcA;
      E_srcB <= d_srcB;
      E_valC <= d_valC;
      E_valA <= d_valA;
      E_valB <= d_valB;
      E_dstE <= d_dstE;
      E_dstM <= d_dstM;
    end
    else begin
      E_stat <= 1;
      E_icode <= 1;
      E_ifun <= 0;
      E_srcA <= 0;
      E_srcB <= 0;
      E_valC <= 0;
      E_valA <= 0;
      E_valB <= 0;
      E_dstE <= 0;
      E_dstM <= 0;
    end

end

always @(posedge clk) begin      
    if (M_bubble == 0) begin
      M_stat <= e_stat;
      M_icode <= e_icode;
      M_Cnd <= e_Cnd;
      M_valC <= e_valC;
      M_valA <= e_valA;
      M_dstE <= e_dstE;
      M_dstM <= e_dstM;
      M_valE <= e_valE;
    end
    else begin
      M_stat <= 1;
      M_icode <= 1;
      M_Cnd <= 0;
      M_valE <= 0;
      M_valA <= 0;
      M_dstE <= 0;
      M_dstM <= 0;
    end

end

always @(posedge clk) begin
 status_code = W_stat;

    if (W_stall == 0) begin
        W_stat <= m_stat;
        W_icode <= m_icode;
        W_valE <= m_valE;
        W_valM <= m_valM;
        W_dstE <= m_dstE;
        W_dstM <= m_dstM;
    end
end

initial begin 
  $dumpfile("processor.vcd");
  $dumpvars(0,processor);
end
initial begin
    clk = 0;
  // F_predPC_true= 64'd0;

    // {status_code[3],status_code[2],status_code[1],status_code[0]}= 4'b0001;

    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;
    #100 clk=~clk;

end
always @(*) begin
  
  if(W_icode == 0)begin
    $finish; 
     end
 end
    always @(*) begin
      // $monitor("PC=%d icode=%d ifun=%d ,valC=%d,valP=%d\n",F_predPC,f_icode,f_ifun,f_valC,f_valP);
      $monitor("time=%0d, clk=%0d, f_pc=%0d, f_icode=%0d, f_ifun=%0d, f_rA=%0d, f_rB=%0d, f_valP=%0d, f_valC=%0d, D_icode=%0d, E_icode=%0d, M_icode=%0d, W_icode=%0d Stat=%d reg1=%d reg2=%d reg3=%d reg4=%d reg5=%d reg6=%d reg7=%d reg8=%d reg9=%d reg10=%d reg11=%d reg12=%d reg13=%d reg14=%d reg15=%d W_valM=%d M_valA=%d\n", 
            $time, clk, f_predPC, f_icode, f_ifun, f_rA, f_rB, f_valP, f_valC, D_icode, E_icode, M_icode, W_icode, status_code, reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14, W_valM, M_valA);
      // $monitor(" icode=%b ifun=%b ,reg0 = %d,reg1 = %d,reg2 = %d,reg3 = %d,reg4 = %d,reg5 = %d,reg6 = %d,reg7 = %d,reg8 = %d,reg9 = %d,reg10 = %d,reg11 = %d,reg12 = %d,reg13 = %d,reg14 = %d\n",f_icode,f_ifun,reg_file0,reg_file1,reg_file2,reg_file3,reg_file4,reg_file5,reg_file6,reg_file7,reg_file8,reg_file9,reg_file10,reg_file11,reg_file12,reg_file13,reg_file14);
    end
		
endmodule