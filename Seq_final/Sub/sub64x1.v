`timescale 1ns/1ps

module sub64x1 (
    input signed [63:0]a, 
    input signed [63:0]b, 
    output signed [63:0]out,
    output overflow 
);
    wire [63:0] bnot;// B not
    not64x1 gate1(b,bnot);

    wire [63:0] temp;
    assign temp = 64'b1; // temp is 1 for adding to obtain complement of b

    wire [63:0] bcomp; // For storing complement of b
    adder64x1 gate2(bnot,temp,bcomp,overflow_1);

    adder64x1 gate3(a,bcomp,out,overflow); // Final output of subtraction
endmodule
