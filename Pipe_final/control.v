module control (
    input [3:0] D_icode,
    input [3:0] d_srcA,
    input [3:0] d_srcB,
    input [3:0] E_icode,
    input [3:0] E_dstM,
    input e_Cnd,
    input [3:0] M_icode,
    input [2:0] m_stat,
    input [2:0] W_stat,

    output reg W_stall,
    output reg M_bubble,
    output reg E_bubble,
    output reg D_bubble,
    output reg D_stall,
    output reg F_stall
);
    //Hazard Prediction
    wire Return,pred_miss,haz_L_U;
    //wire exp; No use

    // always @(negedge clk) begin
    //     Return = 0;
    //     pred_miss = 0;
    //     haz_L_U = 0;
    // end
    assign Return = (D_icode == 9 || E_icode == 9 || M_icode == 9) ? 1 : 0;
    assign haz_L_U = ((E_icode == 5 || E_icode == 11) && (E_dstM == d_srcA || E_dstM == d_srcB)) ? 1 : 0;
    assign pred_miss = (E_icode == 7 && e_Cnd == 0) ? 1 : 0;

    // Assigning F_stall according to the hazards
    always @(*) begin
        if ((Return== 1 && haz_L_U == 1) || (Return== 1 && pred_miss == 1) || (Return== 1) || (haz_L_U == 1)) begin
            F_stall <= 1;
        end
        else begin
            F_stall <= 0;
        end
    end

    // Assigning D_stall according to the hazards
    always @(*) begin
        if ((haz_L_U == 1 && Return== 1) || (haz_L_U == 1)) begin
            D_stall <= 1;
        end
        else begin
            D_stall <= 0;
        end
    end

    // Assigning D_bubble according to the hazards
    always @(*) begin
        if (D_stall == 0) begin
            if ((Return== 1 && pred_miss == 1) || (Return== 1) || (pred_miss == 1)) begin
                D_bubble <= 1;
            end
            else begin
                D_bubble <= 0;
            end
        end
        else begin
            D_bubble <= 0;
        end
    end

    // Assigning E_bubble according to the hazards
    always @(*) begin
        if ((haz_L_U == 1 && Return== 1) || (Return== 1 && pred_miss == 1) || (haz_L_U == 1) || (pred_miss == 1)) begin
            E_bubble <= 1;
        end
        else begin
            E_bubble <= 0;
        end
    end

    // Assigning M_bubble according to the hazards
    always @(*) begin
        if (m_stat == 2 || m_stat == 3 || m_stat == 4 || W_stat == 2 || W_stat == 3 || W_stat == 4) begin
            M_bubble <= 1;
        end
        else begin
            M_bubble <= 0;
        end
    end

    // Assigning W_stall according to the hazards
    always @(*) begin
        if (W_stat == 2 || W_stat == 3 || W_stat == 4) begin
            W_stall <= 1;
        end
        else begin
            W_stall <= 0;
        end
    end

endmodule