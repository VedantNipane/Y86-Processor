`timescale 1ns / 1ps
`include "xor1x1.v"
`include "xor64x1.v"

module xor_tb;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]out;

  xor64x1 uut(
    .a(a),
    .b(b),
    .out(out)
  );

  initial begin
	$dumpfile("xor_test.vcd");
        $dumpvars(0,xor_tb);
		a = 64'b0;
		b = 64'b0;

		#100;

		#20 a=64'b1011;b=64'b0100;
    #20 a=64'b1011;b=64'b1100;
    #20 a=-64'b1011;b=64'b1100;
    #20 a=64'b1001;b=64'b1001;
    #20 a=-64'd2;b=64'd13;
    #20 a=-64'd2;b=-64'd13;
    #20 a=64'b1001;b=64'b1001;
	end
	
  initial 
		$monitor("a=%d b=%d out=%d\n",a,b,out);
endmodule
