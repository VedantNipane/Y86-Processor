`include "./ALU/alu.v"

module exec_seq(input clk,
                input [3:0] icode, 
                input [3:0] ifun, 
                input [63:0] valA, 
                input [63:0] valB, 
                input [63:0] valC, 
                output reg signed [63:0] valE, 
                output reg cnd, 
                output reg ZF, 
                output reg SF, 
                output reg OF);

wire signed [63:0] result;
wire overflow;
reg signed [63:0] inpA;
reg signed [63:0] inpB;
reg[1:0] select;
reg signed [63:0] ans;


alu alu_mod1(
    .control(select),
    .a(inpA),
    .b(inpB),
    .out(result),
    .overflow(overflow)
    );

reg cnd1,cnd2,xoro,ando,oro,noto,temp1;

always @(cnd1 or cnd2) begin
    begin
        ando = cnd1 & cnd2;
        oro = cnd1 | cnd2;
        xoro = cnd1 ^ cnd2 ;
        noto = ~cnd1;
    end
end

always @(*) 
begin
    ZF = (result == 1'b0); // Output of ALU is zero
    //SF = (result < 1'd0); // Output of the ALU is negative
    if (result[63] == 1'b1) begin
        SF = 1;
    end
    else 
    begin
        SF = 0;
    end
    OF = (inpA < 1'b0 == inpB < 1'b0) && (result < 64'b0 != inpA < 1'b0); // signed overflow flag     
end

always @(*) begin

    cnd = 0;
    if (icode == 4'd2) begin //cmove
        
            case (ifun)
                4'd0://rrmove
                begin
                    cnd = 1;
                end
                4'd1://cmovle
                begin
                    cnd1 = SF; cnd2= OF;
                    temp1 = xoro;
                    cnd1 = ZF;
                    cnd1 = noto;
                    cnd2 = temp1;
                    if(oro)begin
                        cnd = 1;
                    end  
            valE = result;

                end
                4'd2://cmovl
                begin
                    cnd1 = SF; cnd2= OF;
                    if(xoro)begin
                        cnd = 1;
                    end   
            valE = result;

                end
                4'd3://cmove
                begin
                    if(ZF)begin
                        cnd = 1;
                    end   
            valE = result;

                end
                4'd4://cmovne
                begin
                    cnd1 = ZF;
                    if(ZF)begin
                        cnd = 1;
                    end         
            valE = result;

                end
                4'd5://cmovge
                begin
                    cnd1= SF;
                    cnd2=OF;
                    temp1 = xoro;
                    cnd = temp1; 
                    if(noto)begin
                        cnd = 1;
                    end 
            valE = result;

                end
                4'd6://cmovg
                begin
                    cnd1 = SF; cnd2= OF;
                    temp1 = xoro;
                    cnd1 = temp1;
                    if(noto)begin
                        cnd = 1;
                    end   
            valE = result;

                end
            endcase
            inpA = valA;
            inpB = 64'd0;
            select = 2'd0;
            valE = result;
    end
    else if (icode == 4'd3) begin //irmove
        inpA = 64'b0;
        inpB = valC;
        select = 2'd0;
        valE = result;
    end
    else if (icode == 4'd4) begin //rmmove
        inpA = valB;
        inpB = valC;
        select = 2'd0;
        valE = result;
    end
    else if (icode == 4'd5) begin //mrmove
        inpA = valB;
        inpB = valC;
        select = 2'd0;
        valE = result;
    end
    else if (icode == 4'd6) begin //operation
        inpA = valA;
            inpB = valB;
            case (ifun)
                4'd0://addq
                begin
                    select = 2'd0;
                end
                4'd1://sub
                begin
                    select = 2'd1;
                end
                4'd2://and
                begin
                    select = 2'd2;
                end
                4'd3:
                begin
                    select = 2'd3;
                end
            endcase
            valE = result;
    end
    else if (icode == 4'd7) begin //jxx
        case (ifun)
            4'd0://jmp
            begin
                cnd = 1;
            end
            4'd1://jle
            begin
                cnd1 = SF;
                cnd2 = OF;
                temp1 = xoro;
                cnd1 = temp1;
                cnd2 = ZF;
                if(oro)begin
                    cnd = 1;
                end
            end
            4'd2://jl
            begin
                cnd1= SF;
                cnd2 =OF;
                if(xoro)
                begin
                    cnd = 1;
                end
            end
            4'd3://je
            begin
                if(ZF)
                begin
                    cnd = 1;
                end
            end
            4'd4://jne
            begin
                cnd1 = ZF;
                if(noto)begin
                    cnd = 1;
                end
            end
            4'd5://jge
            begin
                cnd1 = SF;
                cnd2 = OF;
                temp1 = xoro;
                cnd1 = temp1;
                if(noto)begin
                    cnd = 1;
                end
            end
            4'd6://jg
            begin
                cnd1 = SF;
                cnd2 = OF;
                temp1 = xoro;
                cnd1 = temp1;
                if(noto)begin
                    cnd = 1;
                end
            end
    endcase
    end
    else if (icode == 4'd8) begin //call Dest
        // valE = valB - 8
            inpA = -64'd8;
            inpB = valB;
            select = 2'b00; // to decrement the stack pointer by 8 on call
            valE = result;
    end
    else if (icode == 4'd9) begin //ret
        // valE = valB + 8
            inpA = 64'd8;
            inpB = valB;
            select = 2'b00; // to increment the stack pointer by 8 on ret
            valE = result;
    end
    else if (icode == 4'd10) begin //pushq rA
        // valE = valB - 8
            inpA = -64'd8;
            inpB = valB;
            select = 2'b00; // to decrement the stack pointer by 8 on pushq
            valE = result;
    end
    else if (icode == 4'd11) begin //popq rA
        // valE = valB + 8
            inpA = 64'd8;
            inpB = valB;
            select = 2'b00; // to increment the stack pointer by 8 on popq
            valE = result;
    end
end

endmodule
