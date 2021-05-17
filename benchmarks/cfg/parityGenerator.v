module parityGenerator ( x, y, z, out);
input x, y, z;
output out;
wire A, B, C, D, E;

assign A =  x & ~y ;
assign B =  ~x & y ;
assign C =  A | B ;
assign D =  C & ~z ;
assign E =  ~C & z ;
assign out =  D | E ;

endmodule
