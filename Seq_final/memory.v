`timescale 1ns/1ps

module memory_seq (
    input clk,
    input wire [3:0] icode,
    input wire [63:0] valA,
    input wire [63:0] valB,
    input wire [63:0] valP,
    input wire [63:0] valE,
    output reg [63:0] valM
);
    reg [63:0] memory [0:127];
    
    initial begin
        memory[1] = 64'b1;
    end

    always@(*)
    begin
        //memory[0] = 64'b2;
        if(icode == 4'b0101) // mrmovq
        begin
            valM = memory[valE];
        end
        else if(icode == 4'b1001) //ret
        begin
            valM = memory[valA];
        end
        else if(icode == 4'b1011) //popq
        begin
            valM = memory[valA];
        end
    end

    always@(posedge clk)
    begin
        if(icode == 4'b0100) // rmmovq
        begin
            memory[valE] = valA;
        end
        else if(icode == 4'b1000) //call
        begin
            memory[valE] = valP;
        end
        else if(icode == 4'b1010) //pushq
        begin
            memory[valE] = valA;
        end
    end
endmodule