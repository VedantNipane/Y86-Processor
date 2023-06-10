`timescale 1ns/1ps

module adder64x1 (
    input signed [63:0]a, 
    input signed [63:0]b, 
    output signed [63:0]sum,
    output overflow
);
    wire [64:0]c_in;
    assign c_in[0] = 1'b0;

    genvar  i;

    generate for (i = 0; i < 64 ;i = i+1 ) 
        begin
            adder1x1 g1(a[i],b[i],c_in[i],sum[i],c_in[i+1]);
        end
    endgenerate

    xor g2(overflow,c_in[63],c_in[64]);
endmodule
