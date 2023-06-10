inst_memo[0] = 8'h10;
        inst_memo[1]  = 8'h10; //nop
// inst_memo[2] = 8'h10; //halt

inst_memo[2] = 8'h20; //rrmovq
inst_memo[3] = 8'h12;
// inst_memo[4]= 8'h00;

inst_memo[4] = 8'h30; //irmovq
inst_memo[5] = 8'hF2;
inst_memo[6] = 8'h00;
inst_memo[7] = 8'h00;
inst_memo[8] = 8'h00;
inst_memo[9] = 8'h00;
inst_memo[10] = 8'h00;
inst_memo[11] = 8'h00;
inst_memo[12] = 8'h00;
inst_memo[13] = 8'b00000010;
// inst_memo[14]=8'h00;

inst_memo[14] = 8'h40; //rmmovq
inst_memo[15] = 8'h24;
{inst_memo[16],inst_memo[17],inst_memo[18],inst_memo[19],inst_memo[20],inst_memo[21],inst_memo[22],inst_memo[23]} = 64'd1;
// inst_memo[24]=8'h00;

inst_memo[24] = 8'h40; //rmmovq
inst_memo[25] = 8'h53;
{inst_memo[26],inst_memo[27],inst_memo[28],inst_memo[29],inst_memo[30],inst_memo[31],inst_memo[32],inst_memo[33]} = 64'd0;
// inst_memo[34] = 8'h00;
inst_memo[34] = 8'h50; //mrmovq
inst_memo[35] = 8'h53;
{inst_memo[36],inst_memo[37],inst_memo[38],inst_memo[39],inst_memo[40],inst_memo[41],inst_memo[42],inst_memo[43]} = 64'd0;
// inst_memo[44]=8'h00;

inst_memo[44] = 8'h60; //opq
inst_memo[45] = 8'h9A;
        // inst_memo[46]  = 8'h10; //nop
// inst_memo[46] = 8'h00; //halt



inst_memo[46] = 8'h73; //jmp
// {inst_memo[47],inst_memo[48],inst_memo[49],inst_memo[50],inst_memo[51],inst_memo[52],inst_memo[53],inst_memo[54]} = 64'd56;
inst_memo[54]=8'd56;
{inst_memo[47],inst_memo[48],inst_memo[49],inst_memo[50],inst_memo[51],inst_memo[52],inst_memo[53]}=56'd0;

inst_memo[55] = 8'h00; //halt

inst_memo[56] = 8'hA0; // pushq
inst_memo[57] = 8'h9F;

inst_memo[58] = 8'hB0; //popq
inst_memo[59] = 8'h9F;

inst_memo[60] = 8'h80; //call
{inst_memo[61],inst_memo[62],inst_memo[63],inst_memo[64],inst_memo[65],inst_memo[66],inst_memo[67],inst_memo[68]} = 64'd80;

inst_memo[69] = 8'h60; //opq
inst_memo[70] = 8'h56;

// inst_memo[71] = 8'h00;
inst_memo[71] = 8'h72; //jmp
{inst_memo[72],inst_memo[73],inst_memo[74],inst_memo[75],inst_memo[76],inst_memo[77],inst_memo[78],inst_memo[79]} = 64'd46;

inst_memo[80]=8'h10;
inst_memo[81] = 8'h63; //opq
inst_memo[82] = 8'hDE;
// inst_memo[80] = 8'h10;

inst_memo[83]=8'h90;