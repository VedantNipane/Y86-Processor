`timescale 1ns / 1ps
`include "adder1x1.v"
`include "adder64x1.v"

module add_test;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]sum;
  wire overflow;

  adder64x1 uut(
    .a(a),
    .b(b),
    .sum(sum),
    .overflow(overflow)
  );

  initial begin
		$dumpfile("adder64x1_test.vcd");
    $dumpvars(0,add_test);
		a = 64'b0;
		b = 64'b0;

		#20;

		// #20 a=64'd2147483647;b=64'd1;
    // #20 a=-64'd2147483648;b=-64'd1;
    // #20 a=64'd23;b=-64'd0;
    // #20 a=64'b1001;b=64'b1001;
    // #20 a=64'b1001;b=-64'b1001;
    // #20 a=-64'd2;b=64'd13;
    // #20 a=-64'd2;b=-64'd13;
    #20 a=64'd2;b=-64'd13;
    #20 a=64'd0;b=64'd0;
    #20
    a = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    b = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    #20 a = 64'd1134; b = 64'd8238;
    #20 a = -64'd7478; b = -64'd46474;
    #20 a = 64'd1092835; b = -64'd1020;
    #20 a = 64'd7890678653; b = 64'd4238598110567;
	end
	
  initial 
		$monitor("a=%d  b=%d  sum=%d  overflow=%d\n",a,b,sum,overflow);
endmodule