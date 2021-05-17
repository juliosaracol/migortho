// Benchmark "traffic_cl" written by ABC on Fri Sep  1 08:31:25 2017

module traffic_cl ( 
    pi0, pi1, pi2, pi3, pi4,
    po0  );
  input  pi0, pi1, pi2, pi3, pi4;
  output po0;
  wire n7, n8, n9, n10, n11, n12, n13;
  assign n7 = pi1 & pi2;
  assign n8 = ~pi4 & ~n7;
  assign n9 = ~pi1 & ~pi2;
  assign n10 = pi0 & ~n9;
  assign n11 = ~n8 & n10;
  assign n12 = pi4 & n7;
  assign n13 = ~pi3 & ~n12;
  assign po0 = n11 | ~n13;
endmodule


