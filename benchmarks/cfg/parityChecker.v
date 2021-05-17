// Benchmark "b1" written by ABC on Fri Sep  1 08:34:31 2017

module parityChecker ( 
	x, y, z, w, out    
	);
  input  x, y, z, w;
  output out;
  wire A, B, C, D, E, F, G, H;
  assign A = x & ~y;
  assign B = ~x & y;
  assign C = z & ~w;
  assign D = ~z & w;
  assign E = A | B;
  assign F = C | D;
  assign G = E & ~F;
  assign H = ~E & F;
  assign out = G | H;
endmodule


