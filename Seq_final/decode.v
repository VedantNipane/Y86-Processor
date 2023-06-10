module decode_seq(input clk, 
                input [3:0] icode, 
                input [3:0] rA, 
                input [3:0] rB, 
                output reg [63:0] valA, 
                output reg [63:0] valB, 
                input [63:0] reg_file0, 
                input [63:0] reg_file1, 
                input [63:0] reg_file2, 
                input [63:0] reg_file3, 
                input [63:0] reg_file4, 
                input [63:0] reg_file5, 
                input [63:0] reg_file6, 
                input [63:0] reg_file7, 
                input [63:0] reg_file8, 
                input [63:0] reg_file9, 
                input [63:0] reg_file10, 
                input [63:0] reg_file11, 
                input [63:0] reg_file12, 
                input [63:0] reg_file13, 
                input [63:0] reg_file14);

    reg [63:0] temp_memo[0:14];

    always @(*) begin
    
        temp_memo[0] = reg_file0;
        temp_memo[1] = reg_file1;
        temp_memo[2] = reg_file2;
        temp_memo[3] = reg_file3;
        temp_memo[4] = reg_file4;
        temp_memo[5] = reg_file5;
        temp_memo[6] = reg_file6;
        temp_memo[7] = reg_file7;
        temp_memo[8] = reg_file8;
        temp_memo[9] = reg_file9;
        temp_memo[10] = reg_file10;
        temp_memo[11] = reg_file11;
        temp_memo[12] = reg_file12;
        temp_memo[13] = reg_file13;
        temp_memo[14] = reg_file14;

    if (icode == 4'd2) begin //cmove
        valA = temp_memo[rA];
    end
    else if (icode == 4'd3) begin //irmove
        //Nothing
    end
    else if (icode == 4'd4) begin //rmmove
        valA = temp_memo[rA];
        valB = temp_memo[rB];
    end
    else if (icode == 4'd5) begin //mrmove
        valB = temp_memo[rB];
    end
    else if (icode == 4'd6) begin //operation
        valA = temp_memo[rA];
        valB = temp_memo[rB];
    end
    else if (icode == 4'd7) begin //jxx
        //Nothing
    end
    else if (icode == 4'd8) begin //call Dest
        valB = temp_memo[4'b0100];
    end
    else if (icode == 4'd9) begin //ret
        valA = temp_memo[4'b0100];
        valB = temp_memo[4'b0100];
    end
    else if (icode == 4'd10) begin //push
        valA = temp_memo[rA];
        valB = temp_memo[4'b0100];
    end
    else if (icode == 4'd11) begin //popq rA
        valA = temp_memo[4'b0100];
        valB = temp_memo[4'b0100];
    end    
end

endmodule