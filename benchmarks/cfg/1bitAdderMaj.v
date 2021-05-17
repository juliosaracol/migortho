// Benchmark "b1" written by ABC on Fri Mar  3 18:01:06 2017

module b1 ( 
    A, B, Cin,
    M3);
  input  A, B, Cin;
  output M3;
  wire M1, M2 ;
  assign M1 = (A & B) | (A & Cin) | (B & Cin);
  assign M2 = (~M1 & A) | (~M1 & B) | (A & B);
  assign M3 = (~Cin & M2) | (~Cin & M1) | (M2 & M1);
endmodule


