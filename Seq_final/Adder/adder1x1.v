`timescale 1ns/1ps

module adder1x1 (
    input a, 
    input b,
    input c_in,
    output sum,
    output cout
);
//Basic 1 bit full adder
    wire x1,x2,x3;
    xor inst1(x1,a,b);
    xor inst2(sum,x1,c_in);
    and inst3(x2,a,b);
    and inst4(x3,x1,c_in);
    or inst5(cout,x2,x3);
endmodule
