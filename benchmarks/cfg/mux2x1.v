// Benchmark "C17.iscas" written by ABC on Fri Mar  3 18:01:07 2017

module mux2x1  ( 
    A, B, SELECT,
    MUX2X1  );
  input  A, B, SELECT;
  output MUX2X1;
  wire G1, G2;
  assign G1 = A & SELECT;
  assign G2 = B & ~SELECT;
  assign MUX2X1 = G1 | G2;
endmodule


