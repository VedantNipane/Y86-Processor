`include "./ALU/alu.v"

module execute(
      input clk,
    
    // Inputs
    input [2:0] E_stat,
    input [3:0] E_icode,
    input [3:0] E_ifun,
    input [63:0] E_valC,
    input [63:0] E_valA,
    input [63:0] E_valB,
    input [3:0] E_dstE,
    input [3:0] E_dstM,
    input [2:0] W_stat,
    input [2:0] m_stat,

    // Outputs
    output reg[2:0] e_stat,
    output reg[3:0] e_icode,
    output reg e_Cnd,
    output reg [63:0] e_valE,
    output reg[63:0] e_valA,
    output reg[3:0] e_dstE,
    output reg[3:0] e_dstM,
    output reg ZF,
    output reg SF,
    output reg OF
    );

wire signed [63:0] result;
wire overflow;
reg signed [63:0] inpA;
reg signed [63:0] inpB;
reg[1:0] select;
reg signed [63:0] ans;

    always @(*) begin
        
        e_stat <= E_stat;
        e_icode <= E_icode;
        e_valA <= E_valA;
        e_dstM <= E_dstM;
    end

alu alu_mod1(
    .control(select),
    .a(inpA),
    .b(inpB),
    .out(result),
    .overflow(overflow)
        // if (d_srcB == e_dstE) begin

        //     d_valB <= e_valE;
        // end
    );
// reg ZF = 0;
// reg SF = 0;
// reg OF = 0;

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

    e_Cnd = 1'b0;
    if (E_icode == 4'd2) begin //cmove
        
            case (E_ifun)
                4'd0://rrmove
                begin
                    e_Cnd = 1'b1;
                end
                4'd1://cmovle
                begin
                    cnd1 = SF; cnd2= OF;
                    temp1 = xoro;
                    cnd1 = ZF;
                    cnd1 = noto;
                    cnd2 = temp1;
                    if(oro)begin
                        e_Cnd = 1'b1;
                    end  
            e_valE= result;

                end
                4'd2://cmovl
                begin
                    cnd1 = SF; cnd2= OF;
                    if(xoro)begin
                        e_Cnd = 1'b1;
                    end   
            e_valE= result;

                end
                4'd3://cmove
                begin
                    if(ZF)begin
                        e_Cnd = 1'b1;
                    end   
            e_valE= result;

                end
                4'd4://cmovne
                begin
                    cnd1 = ZF;
                    if(ZF)begin
                        e_Cnd = 1'b1;
                    end         
            e_valE= result;

                end
                4'd5://cmovge
                begin
                    cnd1= SF;
                    cnd2=OF;
                    temp1 = xoro;
                    e_Cnd = temp1; 
                    if(noto)begin
                        e_Cnd = 1'b1;
                    end 
            e_valE= result;

                end
                4'd6://cmovg
                begin
                    cnd1 = SF; cnd2= OF;
                    temp1 = xoro;
                    cnd1 = temp1;
                    if(noto)begin
                        e_Cnd = 1'b1;
                    end   
            e_valE= result;

                end
            endcase
            inpA = E_valA;
            inpB = 64'd0;
            select = 2'd0;
            e_valE= result;
    end
    else if (E_icode == 4'd3) begin //irmove
        inpA = 64'b0;
        inpB = E_valC;
        select = 2'd0;
        e_valE= result;
    end
    else if (E_icode == 4'd4) begin //rmmove
        inpA = E_valB;
        inpB = E_valC;
        select = 2'd0;
        e_valE= result;
    end
    else if (E_icode == 4'd5) begin //mrmove
        inpA = E_valB;
        inpB = E_valC;
        select = 2'd0;
        e_valE= result;
    end
    else if (E_icode == 4'd6) begin //operation
        inpA = E_valA;
            inpB = E_valB;
            case (E_ifun)
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
            e_valE= result;
    end
    else if (E_icode == 4'd7) begin //jxx
        case (E_ifun)
        
            4'd0://jmp
            begin
                e_Cnd = 1'b1;
            end
            4'd1://jle
            begin
                cnd1 = SF;
                cnd2 = OF;
                temp1 = xoro;
                cnd1 = temp1;
                cnd2 = ZF;
                if(oro)begin
                    e_Cnd = 1'b1;
                end
                else begin
                    e_Cnd = 1'b0;
                end
            end
            4'd2://jl
            begin
                cnd1= SF;
                cnd2 =OF;
                if(xoro)
                begin
                    e_Cnd = 1'b1;
                end
                else begin
                    e_Cnd = 1'b0;
                end
            end
            4'd3://je
            begin
                if(ZF)
                begin
                    e_Cnd = 1'b1;
                end
                else begin
                    e_Cnd = 1'b0;
                end
            end
            4'd4://jne
            begin
                cnd1 = ZF;
                if(noto)begin
                    e_Cnd = 1'b1;
                end
                else begin
                    e_Cnd = 1'b0;
                end
            end
            4'd5://jge
            begin
                cnd1 = SF;
                cnd2 = OF;
                temp1 = xoro;
                cnd1 = temp1;
                if(noto)begin
                    e_Cnd = 1'b1;
                end
                else begin
                    e_Cnd = 1'b0;
                end
            end
            4'd6://jg
            begin
                cnd1 = SF;
                cnd2 = OF;
                temp1 = xoro;
                cnd1 = temp1;
                if(noto)begin
                    e_Cnd = 1'b1;
                end
                else begin
                    e_Cnd = 1'b0;
                end
            end
    endcase
    end
    else if (E_icode == 4'd8) begin //call Dest
        // e_valE= E_valB - 8
            inpA = -64'd8;
            inpB = E_valB;
            select = 2'b00; // to decrement the stack pointer by 8 on call
            e_valE= result;
    end
    else if (E_icode == 4'd9) begin //ret
        // e_valE= E_valB + 8
            inpA = 64'd8;
            inpB = E_valB;
            select = 2'b00; // to increment the stack pointer by 8 on ret
            e_valE= result;
    end
    else if (E_icode == 4'd10) begin //pushq rA
        // e_valE= E_valB - 8
            inpA = -64'd8;
            inpB = E_valB;
            select = 2'b00; // to decrement the stack pointer by 8 on pushq
            e_valE= result;
    end
    else if (E_icode == 4'd11) begin //popq rA
        // e_valE= E_valB + 8
            inpA = 64'd8;
            inpB = E_valB;
            select = 2'b00; // to increment the stack pointer by 8 on popq
            e_valE= result;
    end
end

 always @(*) begin

        if (E_icode == 4'b0010 && e_Cnd == 4'b0000) begin
            
            e_dstE = 15;
        end
        else begin
            e_dstE = E_dstE;
        end
        e_valA <= E_valA;
    end
endmodule


///////////////////////////////////////////////////////////////////////////////////////////////

// module E(
//                         clk,D_stat,D_E_icode,D_E_ifun,D_valP,D_valC,d_valA,d_valB,d_rA,d_rB,
//                         E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_rA,E_rB,E_valP
//                         );
//         input clk;
//         input [2:0] D_stat;
//         input [3:0]  D_E_icode;
//         input [3:0] D_E_ifun;
//         input [63:0] D_valC,D_valP;
//         input [63:0] d_valA;
//         input [63:0] d_valB;
//         input [3:0] d_rA;
//         input [3:0] d_rB;

//         output reg[2:0] E_stat;
//         output reg[3:0]  E_icode;
//         output reg[3:0] E_ifun;
//         output reg[63:0] E_valC,E_valP;
//         output reg[63:0] E_valA;
//         output reg[63:0] E_valB;
//         output reg[3:0] E_rA;
//         output reg[3:0] E_rB;

//         always @(posedge clk)
//             begin
//                 E_stat=D_stat;
//                 E_icode=D_E_icode;
//                 E_ifun=D_E_ifun;
//                 E_valC=D_valC;
//                 E_valA=d_valA;
//                 E_valB=d_valB;
//                 E_rB=d_rB;
//                 E_rA=d_rA;
//                 E_valP=D_valP;
//             end
// endmodule            


        
        