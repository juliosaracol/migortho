// Benchmark "C17.iscas" written by ABC on Fri Mar  3 18:01:07 2017

module xor ( 
    x, y, A, B, XOR  );
  input  x, y;
  output XOR;
  wire A, B;
  assign A = ~x & y;
  assign B = x & ~y;
  assign XOR = A | B;
endmodule


