`timescale 1ns/1ps
`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "writeback.v"
`include "pc_update.v"
module processor();

//wire    
  reg clk;
  reg [63:0] PC;
//Output
  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB;
  wire signed [63:0] valC;
  wire [63:0] valP;

  reg signed [63:0] reg_file0;
  reg signed  [63:0] reg_file1;
  reg signed  [63:0] reg_file2;
  reg signed  [63:0] reg_file3;
  reg signed  [63:0] reg_file4;
  reg signed  [63:0] reg_file5;
  reg signed  [63:0] reg_file6;
  reg signed  [63:0] reg_file7;
  reg signed  [63:0] reg_file8;
  reg signed  [63:0] reg_file9;
  reg signed  [63:0] reg_file10;
  reg signed  [63:0] reg_file11;
  reg signed  [63:0] reg_file12;
  reg signed  [63:0] reg_file13;
  reg signed  [63:0] reg_file14;


  wire memory_error;
  wire halt;
  wire invalid_instr;

  wire signed [63:0] valA;
  wire signed [63:0] valB;

  wire ZF, SF, OF, cnd;
  wire signed [63:0] valE;
  reg status_code[3:0];
fetch uut(
    .clk(clk),
    .PC(PC),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .valC(valC),
    .valP(valP),
    .memory_error(memory_error),
    .halt(halt),
    .invalid_instr(invalid_instr)
);

decode_seq uut1(
    .clk(clk),
    .icode(icode),
    .rA(rA),
    .rB(rB),
    .valA(valA),
    .valB(valB),
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

exec_seq uut2 (
  .clk(clk),
  .icode(icode),
  .ifun(ifun),
  .valA(valA),
  .valB(valB),
  .valC(valC),
  .valE(valE),
  .cnd(cnd),
  .ZF(ZF),
  .SF(SF),
  .OF(OF)
);

wire [63:0] valM;
memory_seq uut3 (
  .clk(clk),
  .icode(icode),
  .valA(valA),
  .valB(valB),
  .valP(valP),
  .valE(valE),
  .valM(valM)
);

    wire [63:0] reg_file_wb0;
    wire [63:0] reg_file_wb1;
    wire [63:0] reg_file_wb2 ;
    wire [63:0] reg_file_wb3 ;
    wire [63:0] reg_file_wb4 ;
    wire [63:0] reg_file_wb5 ;
    wire [63:0] reg_file_wb6 ;
    wire [63:0] reg_file_wb7 ;
    wire [63:0] reg_file_wb8 ;
    wire [63:0] reg_file_wb9 ;
    wire [63:0] reg_file_wb10;
    wire [63:0] reg_file_wb11;
    wire [63:0] reg_file_wb12;
    wire [63:0] reg_file_wb13;
    wire [63:0] reg_file_wb14;


wb_seq uut4 (
  .clk(clk),
  .icode(icode),
  .rA(rA),
  .rB(rB),
  .valE(valE),
  .valM(valM),
  .reg_file0(reg_file_wb0),
  .reg_file1(reg_file_wb1),
  .reg_file2(reg_file_wb2),
  .reg_file3(reg_file_wb3),
  .reg_file4(reg_file_wb4),
  .reg_file5(reg_file_wb5),
  .reg_file6(reg_file_wb6),
  .reg_file7(reg_file_wb7),
  .reg_file8(reg_file_wb8),
  .reg_file9(reg_file_wb9),
  .reg_file10(reg_file_wb10),
  .reg_file11(reg_file_wb11),
  .reg_file12(reg_file_wb12),
  .reg_file13(reg_file_wb13),
  .reg_file14(reg_file_wb14)
);

wire [63:0] PC_updated;

pc_update uut5 (
  .clk(clk),
  .cnd(cnd),
  .icode(icode),
  .valC(valC),
  .valM(valM),
  .valP(valP),
  .PC_updated(PC_updated)
);

always @(reg_file_wb0 or reg_file_wb1 or reg_file_wb2 or reg_file_wb3 or reg_file_wb4 or reg_file_wb5 or reg_file_wb6 or reg_file_wb7 or reg_file_wb8 or reg_file_wb9 or reg_file_wb10 or reg_file_wb11 or reg_file_wb12 or reg_file_wb13 or reg_file_wb14) begin
    reg_file0 = reg_file_wb0;
    reg_file1 = reg_file_wb1;
    reg_file2 = reg_file_wb2;
    reg_file3 = reg_file_wb3;
    reg_file4 = reg_file_wb4;
    reg_file5 = reg_file_wb5;
    reg_file6 = reg_file_wb6;
    reg_file7 = reg_file_wb7;
    reg_file8 = reg_file_wb8;
    reg_file9 = reg_file_wb9;
    reg_file10 = reg_file_wb10;
    reg_file11 = reg_file_wb11;
    reg_file12 = reg_file_wb12;
    reg_file13 = reg_file_wb13;
    reg_file14 = reg_file_wb14;
end

initial begin
    clk = 0;
    PC = 64'd0;

    {status_code[3],status_code[2],status_code[1],status_code[0]}= 4'b0001;

    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;
    #10 clk=~clk;

end

always @(posedge clk) begin
  PC = PC_updated;
end

always @(*) begin
  if(halt==1)begin
    {status_code[3],status_code[2],status_code[1],status_code[0]} = 4'b0010;
    $finish;
  end

   if(memory_error==1)begin
    {status_code[3],status_code[2],status_code[1],status_code[0]} = 4'b0100;
    $finish;
  end
   if(invalid_instr==1)begin
    {status_code[3],status_code[2],status_code[1],status_code[0]}= 4'b1000;
    $finish;
  end
  
end

    always @(*) begin
     $monitor("PC=%d icode=%b ifun=%b ,valC=%d,valP=%d,valA=%d,valB=%d,ra=%d,rb=%d, valE=%d, valM=%d,PC_new = %d \n",PC,icode,ifun,valC,valP,valA,valB,rA,rB,valE,valM,PC_updated);
      // $monitor("PC=%d icode=%b ifun=%b ,reg0 = %d,reg1 = %d,reg2 = %d,reg3 = %d,reg4 = %d,reg5 = %d,reg6 = %d,reg7 = %d,reg8 = %d,reg9 = %d,reg10 = %d,reg11 = %d,reg12 = %d,reg13 = %d,reg14 = %d\n",PC,icode,ifun,reg_file0,reg_file1,reg_file2,reg_file3,reg_file4,reg_file5,reg_file6,reg_file7,reg_file8,reg_file9,reg_file10,reg_file11,reg_file12,reg_file13,reg_file14);
    end
		
endmodule

