// Benchmark "PARITYFDS" written by ABC on Fri Mar  3 18:01:09 2017

module PARITYFDS ( 
    pi00, pi01, pi02, pi03, pi04, pi05, pi06, pi07, pi08, pi09, pi10, pi11,
    pi12, pi13, pi14, pi15,
    po0  );
  input  pi00, pi01, pi02, pi03, pi04, pi05, pi06, pi07, pi08, pi09,
    pi10, pi11, pi12, pi13, pi14, pi15;
  output po0;
  wire n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
    n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46,
    n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
    n61, n62;
  assign n19 = pi14 & ~pi15;
  assign n20 = ~pi14 & pi15;
  assign n21 = ~n19 & ~n20;
  assign n22 = pi12 & ~pi13;
  assign n23 = ~pi12 & pi13;
  assign n24 = ~n22 & ~n23;
  assign n25 = n21 & ~n24;
  assign n26 = ~n21 & n24;
  assign n27 = ~n25 & ~n26;
  assign n28 = pi10 & ~pi11;
  assign n29 = ~pi10 & pi11;
  assign n30 = ~n28 & ~n29;
  assign n31 = pi08 & ~pi09;
  assign n32 = ~pi08 & pi09;
  assign n33 = ~n31 & ~n32;
  assign n34 = n30 & ~n33;
  assign n35 = ~n30 & n33;
  assign n36 = ~n34 & ~n35;
  assign n37 = n27 & ~n36;
  assign n38 = ~n27 & n36;
  assign n39 = ~n37 & ~n38;
  assign n40 = pi06 & ~pi07;
  assign n41 = ~pi06 & pi07;
  assign n42 = ~n40 & ~n41;
  assign n43 = pi04 & ~pi05;
  assign n44 = ~pi04 & pi05;
  assign n45 = ~n43 & ~n44;
  assign n46 = n42 & ~n45;
  assign n47 = ~n42 & n45;
  assign n48 = ~n46 & ~n47;
  assign n49 = pi02 & ~pi03;
  assign n50 = ~pi02 & pi03;
  assign n51 = ~n49 & ~n50;
  assign n52 = pi00 & ~pi01;
  assign n53 = ~pi00 & pi01;
  assign n54 = ~n52 & ~n53;
  assign n55 = n51 & ~n54;
  assign n56 = ~n51 & n54;
  assign n57 = ~n55 & ~n56;
  assign n58 = n48 & ~n57;
  assign n59 = ~n48 & n57;
  assign n60 = ~n58 & ~n59;
  assign n61 = n39 & ~n60;
  assign n62 = ~n39 & n60;
  assign po0 = n61 | n62;
endmodule


