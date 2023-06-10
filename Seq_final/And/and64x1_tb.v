`timescale 1ns / 1ps
`include "and1x1.v"
`include "and64x1.v"

module and_tb;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]out;

  and64x1 uut(
    .a(a),
    .b(b),
    .out(out)
  );

  initial begin
		$dumpfile("and_test.vcd");
    $dumpvars(0,and_tb);
		a = 64'b0;
		b = 64'b0;

		#10;
    #10 a = 64'd1092835; b = -64'd1020;
    #10 a = 64'd7890678653; b = 64'd4238598110567;
	  #10 a=64'b1011;b=64'b0100;
    #10 a=64'b1011;b=64'b1100;
    #10 a=-64'b1011;b=64'b1100;
    #10 a=64'b1001;b=64'b1001;
    #10 a = 64'd1134; b = 64'd8238;
    #10 a = -64'd7478; b = -64'd46474;
    #10 a=-64'd2;b=64'd13;
    #10 a=-64'd2;b=-64'd13;
    #10 a=64'b1001;b=64'b1001;
    #10 a = 64'b1111111111111111111111111111111111111111111111111111111111111111;
        b = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    
	end
	
  initial 
		$monitor("a=%d b=%d out=%d\n",a,b,out);
endmodule
