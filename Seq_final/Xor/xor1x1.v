`timescale 1ns / 1ps

module xor1x1(
  input signed a,
  input signed b,
  output signed out
  );

  xor g1(out,a,b);  

endmodule