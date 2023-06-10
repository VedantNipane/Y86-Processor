`timescale 1ns/1ps

module memory (
    input clk,
     input [2:0] M_stat,
    input [3:0] M_icode,
    input [63:0] M_valE,
    input [63:0] M_valA,
    input [3:0] M_dstE,
    input [3:0] M_dstM,

    // Outputs
    output reg[2:0] m_stat,
    output reg[3:0] m_icode,
    output reg[63:0] m_valE,
    output reg[63:0] m_valM,
    output reg[3:0] m_dstE,
    output reg[3:0] m_dstM
);
    reg [63:0] memory [0:255];
    reg mem_error;
    integer i ;
    initial begin
        for(i=0;i<255;i = i+1 )begin
            memory[i]=0;
        end
    end
    always @(*) begin
        if (m_dstM > 255 ) begin
            mem_error = 1;
        end
        else begin
            mem_error = 0;
        end
    end

       always @(*) begin
        m_icode <= M_icode;
        m_valE <= M_valE;
        m_dstE <= M_dstE;
        m_dstM <= M_dstM;
    end

    always@(*)
    begin
        //memory[0] = 64'b2;
        if(M_icode == 4'b0101) // mrmovq
        begin
            m_valM = memory[M_valE];
        end
        else if(M_icode == 4'b1001) //ret
        begin
            m_valM = memory[M_valA];
        end
        else if(M_icode == 4'b1011) //popq
        begin
            m_valM = memory[M_valA];
        end
    end

    always@(posedge clk)
    begin
        if(M_icode == 4'b0100) // rmmovq
        begin
            memory[M_valE] = M_valA;
        end
        else if(M_icode == 4'b1000) //call
        begin
            memory[M_valE] = M_valA;
        end
        else if(M_icode == 4'b1010) //pushq
        begin
            memory[M_valE] = M_valA;
        end
    end



     always @(*) begin
        
        if (mem_error == 1) begin

            m_stat <= 3;
        end 
        else begin

            m_stat <= M_stat;
        end
    end
    
endmodule

// module M(
//     clk,E_stat,E_icode,E_ifun,e_Cnd,e_valE,E_valP,E_valA,E_valB,E_rA,E_rB,E_valC,
//     M_stat,M_ifun,M_icode,M_Cnd,M_valE,M_valA,M_rB,M_rA,M_valP,M_valC,M_valB);
    
//     input clk;
//     input [2:0] E_stat;
//     input [3:0] E_icode;
//     input [3:0] E_ifun;
//     input  e_Cnd;
//     input [63:0] e_valE,E_valP,E_valB,E_valC;
//     input [63:0] E_valA;
//     input [3:0] E_rA;
//     input [3:0] E_rB;
    
//     output reg [2:0] M_stat;
//     output reg [3:0] M_icode;
//     output reg [3:0] M_ifun;
//     output reg  M_Cnd;
//     output reg [63:0] M_valE;
//     output reg [63:0] M_valA,M_valP,M_valC,M_valB;
//     output reg [3:0] M_rA;
//     output reg [3:0] M_rB;

//     always @(posedge clk)
//         begin
//             M_stat=E_stat;
//             M_icode=E_icode;
//             M_ifun=E_ifun;
//             M_Cnd=e_Cnd;
//             M_valE=e_valE;
//             M_valA=E_valA;
//             M_rB=E_rB;
//             M_rA=E_rA;    
//             M_valB=E_valB;
//             M_valC=E_valC;
//             M_valP=E_valP;                  
//         end
// endmodule        






    