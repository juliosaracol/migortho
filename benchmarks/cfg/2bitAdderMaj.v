module adder2bits(A, B, C, D, E, M3 , M6);
  input  A, B, C, D, E;
  output M3, M6;
  wire M1, M2, M4, M5;
  assign M1 = (A & B) | (A & C) | (B & C);
  assign M2 = (~C & A) | (~C & B) | (A & B);
  assign M3 = (~M1 & M2) | (~M1 & ~C) | (M2 & ~C);
  assign M4 = (D & E) | (D & ~M1) | (E & ~M1);
  assign M5 = (D & E) | (D & M1) | (E & M1);
  assign M6 = (~M4 & M1) | (~M4 & M5) | (M1 & M5);
endmodule
