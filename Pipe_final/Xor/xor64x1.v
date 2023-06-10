`timescale 1ns / 1ps

module xor64x1(
  input signed [63:0]a,
  input signed [63:0]b,
  output signed [63:0]out
  );

  genvar i;

  generate for(i=0; i<64; i=i+1) 
  begin
    xor1x1 gate1(a[i],b[i],out[i]);
  end
  endgenerate  
endmodule