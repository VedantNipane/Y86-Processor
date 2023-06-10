`timescale 1ns / 1ps

`include "../Adder/adder1x1.v"
`include "../Adder/adder64x1.v"
`include "not1x1.v"
`include "not64x1.v"
`include "sub64x1.v"

module sub_test;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]out;
  wire overflow;

  sub64x1 uut(
    .a(a),
    .b(b),
    .out(out),
    .overflow(overflow)
  );

  initial begin
		$dumpfile("sub64x1_test.vcd");
        $dumpvars(0,sub_test);
		a = 64'b0;
		b = 64'b0;

		#10;

    #20 a=64'd2147483647;b=-64'd1;
    #20 a=-64'd2147483648;b=64'd1;
    #20 a=64'd23;b=-64'd0;
    #20 a=64'b1001;b=64'b1001;
    #20 a=64'b1001;b=-64'b1001;
    #20 a=-64'd2;b=64'd13;
    #20 a=-64'd2;b=-64'd13;
    #20 a=64'd2;b=-64'd13;
    #20 a=64'd0;b=64'd0;
    #20 a=-64'b111111111111111111111111111111111111111111111111111111111111111 ; b = 64'b111111111111111111111111111111111111111111111111111111111111111;
	end
	
  initial 
		$monitor("a=%d b=%d out=%d overflow=%b\n",a,b,out,overflow);
endmodule
