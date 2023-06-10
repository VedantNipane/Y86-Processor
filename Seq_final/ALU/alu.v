`timescale 1ns / 1ps


`include "./Adder/adder1x1.v"
`include "./Adder/adder64x1.v"
`include "./And/and64x1.v"
`include "./And/and1x1.v"
`include "./Sub/sub64x1.v"
`include "./Sub/not64x1.v"
`include "./Sub/not1x1.v"
`include "./Xor/xor64x1.v"
`include "./Xor/xor1x1.v"

module alu (
    input [1:0] control,
    input signed [63:0] a,
    input signed [63:0] b,
    output signed [63:0] out,
    output overflow
);
    wire signed [63:0] out1;//Output of add operation
    wire signed [63:0] out2;//Output of sub operation
    wire signed [63:0] out3;//Output of and operation
    wire signed [63:0] out4;//Output of xor operation
    wire overflow_add;
    wire overflow_sub;
    reg signed [63:0] out_final;//To store final output that we will return
    reg overflow_final;

    adder64x1 m1(a,b,out1,overflow_add);
    sub64x1 m2(a,b,out2,overflow_sub);
    and64x1 m3(a,b,out3);
    xor64x1 m4(a,b,out4);

    always @(*) begin
        case (control)
            2'b00:begin
                out_final = out1;
                overflow_final = overflow_add;
            end
            2'b01:begin
                out_final = out2;
                overflow_final = overflow_sub;
            end
            2'b10:begin
                out_final = out3;
                overflow_final = 1'b0;
            end
            2'b11:begin
                out_final = out4;
                overflow_final = 1'b0;
            end
        endcase
    end

    assign out = out_final;
    assign overflow = overflow_final;
endmodule
