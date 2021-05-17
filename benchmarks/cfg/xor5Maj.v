module top( x, y, z, p, q);
input x, y, z, p, q;
output M6;
wire M1, M2, M3, M4, M5;

assign M1 = (~x & ~y) | (~x & ~z) | (~y & ~z);
assign M2 = (~x & y) | (~x & z) | (y & z);
assign M3 = (x & M1) | (x & M2) | (M1 & M2);
assign M4 = (~q & ~M3) | (~q & ~p) | (~M3 & ~p);
assign M5 = (p & q) | (p & ~M3) | (q & ~M3);
assign M6 = (M3 & M4) | (M3 & M5) | (M4 & M5);
endmodule
