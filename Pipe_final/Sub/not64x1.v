`timescale 1ns / 1ps

module not64x1(
  input signed [63:0]a,
  output signed [63:0]out
  );

  genvar i;

  generate for(i=0; i<64; i=i+1) 
  begin
    not1x1 gate1(a[i],out[i]);
  end
  endgenerate  
endmodule