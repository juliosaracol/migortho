// Benchmark "traffic_cl" written by ABC on Fri Mar  3 18:01:05 2017

module traffic_cl ( 
    pi0, pi1, pi2, pi3, pi4,
    po0  );
  input  pi0, pi1, pi2, pi3, pi4;
  output po0;
  wire n8, n9, n10, n11, n12;
  assign n8 = pi2 & pi4;
  assign n9 = n8 & pi1;
  assign n10 = ~n9 & ~pi0;
  assign n11 = (~pi2 & ~pi4) | (~pi2 & ~pi1) | (~pi4 & ~pi1);
  assign n12 = ~n10 & ~n11;
  assign po0 = n12 | pi3;
endmodule


