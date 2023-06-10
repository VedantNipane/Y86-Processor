module wb_seq(clk, icode, rA, rB, valE, valM, reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14);
    input clk;
    input [3:0] icode;
    input [3:0] rA;
    input [3:0] rB;
    input [63:0] valE,valM ;

    output reg signed [63:0] reg_file0;
    output reg signed [63:0] reg_file1;
    output reg signed [63:0] reg_file2;
    output reg signed [63:0] reg_file3;
    output reg signed [63:0] reg_file4;
    output reg signed [63:0] reg_file5;
    output reg signed [63:0] reg_file6;
    output reg signed [63:0] reg_file7;
    output reg signed [63:0] reg_file8;
    output reg signed [63:0] reg_file9;
    output reg signed [63:0] reg_file10;
    output reg signed [63:0] reg_file11;
    output reg signed [63:0] reg_file12;
    output reg signed [63:0] reg_file13;
    output reg signed [63:0] reg_file14;

    reg [63:0] temp_memo[0:14];
    
    initial begin
        temp_memo[0] = 0;
        temp_memo[1] = 0;
        temp_memo[2] = 0;
        temp_memo[3] = 0;
        temp_memo[4] = 0;
        temp_memo[5] = 0;
        temp_memo[6] = 0;
        temp_memo[7] = 0;
        temp_memo[8] = 0;
        temp_memo[9] = 0;
        temp_memo[10] =0;
        temp_memo[11] =0;
        temp_memo[12] =0;
        temp_memo[13] =0;
        temp_memo[14] =0;
         
    end

    always @(*) begin
        reg_file0 = temp_memo[0];
        reg_file1 = temp_memo[1];
        reg_file2 = temp_memo[2];
        reg_file3 = temp_memo[3];
        reg_file4 = temp_memo[4];
        reg_file5 = temp_memo[5];
        reg_file6 = temp_memo[6];
        reg_file7 = temp_memo[7];
        reg_file8 = temp_memo[8];
        reg_file9 = temp_memo[9];
        reg_file10 = temp_memo[10];
        reg_file11 = temp_memo[11];
        reg_file12 = temp_memo[12];
        reg_file13 = temp_memo[13];
        reg_file14 = temp_memo[14];    
            
        end

    always @(posedge clk) begin
    

                    case (icode)

                    4'b0000: //halt
                    begin
                       
                    end

                    4'b0001://nop
                    begin
                    end

                    4'b0011://irmove
                    begin
                      temp_memo[rB] = valE;
                    end

                    4'b0101://mrmove
                    begin
                          temp_memo[rA] = valE;
                    end

                    4'b0100://rmmove
                    begin
                    end
                    
                    4'b0010://cmove
                    begin
                        temp_memo[rB] = valE;
                    end

                     4'b0110://opq
                    begin
                      temp_memo[rB] = valE;
                    end

                     4'b1010://push
                    begin
                        temp_memo[4'b0100] = valE;
                    end 
                    4'b1011://pop
                    begin
                        temp_memo[4'b0100] = valE;
                        temp_memo[rA] = valM;
                    end

                     4'b0111://jxx
                    begin
                       
                    end
                     4'b1000://call
                    begin
                       temp_memo[4'b0100] = valE;
                    end
                     4'b1001://ret
                    begin
                        temp_memo[4'b0100] = valE;                      
                    end
                    
                    endcase        
    end
endmodule




                    