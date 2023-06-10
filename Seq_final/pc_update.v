`timescale 1ns/1ps

module pc_update (
    input clk,
    input cnd,
    input [3:0] icode,
    input [63:0] valC,
    input [63:0] valM,
    input [63:0] valP,
    output reg [63:0] PC_updated
);
    always@(*)
    begin
        if(icode == 4'b0111) // jxx or jumps
        begin
            if(cnd == 1'b1)
            begin
                PC_updated = valC;
            end
            else
            begin
                PC_updated = valP;
            end
        end

        else if(icode == 4'b1000) // call
        begin
            PC_updated = valC;
        end

        else if(icode == 4'b1001) // ret
        begin
            PC_updated = valM;
        end

        else // default case
        begin
            PC_updated = valP;
        end
    end
endmodule