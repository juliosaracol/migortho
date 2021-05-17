// Benchmark "b1" written by ABC on Fri Mar  3 18:01:06 2017

module xnor ( 
    A, B, XNOR
    );
  input  A, B;
  output XNOR;
  wire M1, M2, M3 ;
  assign M1 = A & ~B;
  assign M2 = ~A & B;
  assign M3 = M2 | M1;
  assign XNOR = ~M3;
endmodule


