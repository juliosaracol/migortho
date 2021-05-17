// Benchmark "source.pla" written by ABC on Fri Mar  3 18:01:06 2017

module \source.pla  ( 
    pi0, pi1, pi2, pi3, pi4, pi5, pi6, pi7,
    po0  );
  input  pi0, pi1, pi2, pi3, pi4, pi5, pi6, pi7;
  output po0;
  wire n11, n12, n13, n14, n15;
  assign n11 = pi6 & pi7;
  assign n12 = (~n11 & ~pi4) | (~n11 & ~pi5) | (~pi4 & ~pi5);
  assign n13 = n12 & pi3;
  assign n14 = pi1 & ~pi2;
  assign n15 = n14 & ~pi0;
  assign po0 = n13 | ~n15;
endmodule


