// Benchmark "CM82" written by ABC on Fri Mar  3 17:59:50 2017

module CM82 ( 
    pi0, pi1, pi2, pi3, pi4,
    po0, po1, po2  );
  input  pi0, pi1, pi2, pi3, pi4;
  output po0, po1, po2;
  wire n10, n11, n12, n14, n15, n16, n17, n18,n19,n20,n21;
  assign n10 = pi1 & ~pi2;
  assign n11 = ~n10 & ~pi2;
  assign n12 = n11 & pi0;
  assign n14 = (~pi0 & ~pi2)|(~pi0 & ~pi1)|(~pi2 & ~pi1);
  assign n15 = pi3 & ~pi4;
  assign n22 = pi3 | ~pi4; 
  assign n16= ~n15 & n22;
  assign n17 = n16 & ~n14;
  assign n18 = ~n10 & pi1;
  assign n19 = ~n18 | n11;
  assign n20 = ~n11 & ~pi0;
  assign n21 = ~n16 & n14;  
  assign po0 = n12 | n20;
  assign po1 = n21 | n17;
  assign po2 = (~n14 & pi3)|(~n14 & pi4)|(pi3 & pi4);
endmodule


