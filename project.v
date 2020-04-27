 //Code your design here
 /**************************************************************************/
 /*  Stub for Project in EE382M - Dependable Computing
 */
 /*
 */
 /*  Do not change I/O names in main() module
 */
 /*
 */
 /**************************************************************************/

module main(A0,A1,A2,B0,B1,B2,PAR,C0,C1,C2,X0,X1,X2,XC,XE0,XE1,
             Y0,Y1,Y2,YC,YE0,YE1);

  input A0,A1,A2,B0,B1,B2,PAR,C0,C1,C2;
  output X0,X1,X2,XC,XE0,XE1,Y0,Y1,Y2,YC,YE0,YE1;
  
  /* add your design here */
  //Determine if input is a codeword or not
  wire       cw_e;
  wire       is_n_cw,is_n_cw_b;
  wire [1:0] w_cw; 
  
  assign w_cw[0] = A1^A2;
  assign is_n_cw = A0^w_cw[0];
  assign w_cw[1] = B1^B2;
  assign is_n_cw_b = B0^w_cw[1];
  
  assign cw_e = !(is_n_cw^is_n_cw_b^PAR);
  
  //Determine if the control signal is one-hot or not
  wire       ci_e;
  wire [2:0] w_ci; 
  
  assign w_ci[0] = (C0)|(C1)|(!C2);
  assign w_ci[1] = (C0)|(!C1)|(C2);
  assign w_ci[2] = (!C0)|(C1)|(C2);
  
  assign ci_e = w_ci[0]&w_ci[1]&w_ci[2];
  //Determine the operation tyep
  wire [2:0]post_a;
  wire [2:0]post_b;
  wire [2:0]comp_a;
  wire [2:0]comp_b;
  
  assign comp_a = {!A2,!A1,!A0} + 1;
  assign comp_b = {!B2,!B1,!B0} + 1;
  
  assign post_a = C2?comp_a:{A2,A1,A0};
  assign post_b = C1?comp_b:{B2,B1,B0};
  
  //Adder1
  wire [2:0] a_1; 
  wire [2:0] b_1;
  wire       cout_1; 
  wire [1:0] w_adder_1; 
  wire [2:0] pre_sum_1; 
  
  assign a_1[2:0] = post_a[2:0]; 
  assign b_1[2:0] = post_b[2:0]; 
  assign XC       = cout_1; 
  
  one_bit_adder
  adder_1_1(a_1[0],b_1[0],1'b0,pre_sum_1[0],w_adder_1[0]);
  one_bit_adder
  adder_1_2(a_1[1],b_1[1],w_adder_1[0],pre_sum_1[1],w_adder_1[1]);
  one_bit_adder
  adder_1_3(a_1[2],b_1[2],w_adder_1[1],pre_sum_1[2],cout_1);
  
  assign X0 = pre_sum_1[0];
  assign X1 = pre_sum_1[1];
  assign X2 = pre_sum_1[2];
  //Adder1 redundancy 
  wire [2:0] a_1_r; 
  wire [2:0] b_1_r;
  wire       cout_1_r; 
  wire [1:0] w_adder_1_r; 
  wire [2:0] pre_sum_1_r; 
  
  assign a_1_r[2:0] = post_a[2:0]; 
  assign b_1_r[2:0] = post_b[2:0]; 
  
  one_bit_adder adder_1_1_r(a_1_r[0],b_1_r[0],1'b0,pre_sum_1_r[0],w_adder_1_r[0]);
  one_bit_adder adder_1_2_r(a_1_r[1],b_1_r[1],w_adder_1_r[0],pre_sum_1_r[1],w_adder_1_r[1]);
  one_bit_adder adder_1_3_r(a_1_r[2],b_1_r[2],w_adder_1_r[1],pre_sum_1_r[2],cout_1_r);
  //Adder2
  wire [2:0] a_2; 
  wire [2:0] b_2;
  wire       cout_2; 
  wire [1:0] w_adder_2; 
  wire [2:0] pre_sum_2; 
  
  assign a_2[2:0] = post_a[2:0]; 
  assign b_2[2:0] = post_b[2:0]; 
  assign YC       = cout_2; 
  
  one_bit_adder
  adder_2_1(a_2[0],b_2[0],1'b0,pre_sum_2[0],w_adder_2[0]);
  one_bit_adder
  adder_2_2(a_2[1],b_2[1],w_adder_2[0],pre_sum_2[1],w_adder_2[1]);
  one_bit_adder
  adder_2_3(a_2[2],b_2[2],w_adder_2[1],pre_sum_2[2],cout_2);
  
  assign Y0 = pre_sum_2[0];
  assign Y1 = pre_sum_2[1];
  assign Y2 = pre_sum_2[2];
  
  //Adder2 redundancy 
  wire [2:0] a_2_r; 
  wire [2:0] b_2_r;
  wire       cout_2_r; 
  wire [1:0] w_adder_2_r; 
  wire [2:0] pre_sum_2_r; 
  
  assign a_2_r[2:0] = post_a[2:0]; 
  assign b_2_r[2:0] = post_b[2:0]; 
  
  one_bit_adder adder_2_1_r(a_2_r[0],b_2_r[0],1'b0,pre_sum_2_r[0],w_adder_2_r[0]);
  one_bit_adder adder_2_2_r(a_2_r[1],b_2_r[1],w_adder_2_r[0],pre_sum_2_r[1],w_adder_2_r[1]);
  one_bit_adder adder_2_3_r(a_2_r[2],b_2_r[2],w_adder_2_r[1],pre_sum_2_r[2],cout_2_r);
  //Error logic
  wire  pre_x0_e;
  wire  pre_x0_e_r;
  wire  pre_x1_e;
  wire  pre_x1_e_r;
  
  wire  pre_y0_e;
  wire  pre_y0_e_r;
  wire  pre_y1_e_r;
  
  
  //Error checking
  assign pre_x0_e = (pre_sum_1[0]^pre_sum_1_r[0]) | (pre_sum_1[1]^pre_sum_1_r[1]);
  assign pre_x0_e_r = (pre_sum_1[0]^pre_sum_1_r[0]) | (pre_sum_1[1]^pre_sum_1_r[1]);
  assign pre_x1_e = !((pre_sum_1[2]^pre_sum_1_r[2]) | (cout_1^cout_1_r));
  assign pre_x1_e_r = !((pre_sum_1[2]^pre_sum_1_r[2]) | (cout_1^cout_1_r));
  
  assign pre_y0_e = (pre_sum_2[0]^pre_sum_2_r[0]) | (pre_sum_2[1]^pre_sum_2_r[1]);
  assign pre_y0_e_r= (pre_sum_2[0]^pre_sum_2_r[0]) | (pre_sum_2[1]^pre_sum_2_r[1]);
  assign pre_y1_e = !((pre_sum_2[2]^pre_sum_2_r[2]) | (cout_2^cout_2_r));
  assign pre_y1_e_r = !((pre_sum_2[2]^pre_sum_2_r[2]) | (cout_2^cout_2_r));
  //Combine all error signal 
  
  assign XE0 = (ci_e|cw_e|(pre_x0_e != pre_x0_e_r))?1'b1:pre_x0_e;
  assign XE1 = (ci_e|cw_e|(pre_x1_e != pre_x1_e_r))?1'b1:pre_x1_e_r;
  
  assign YE0 = (ci_e|cw_e|(pre_y0_e != pre_y0_e_r))?1'b1:pre_y0_e_r;
  assign YE1 = (ci_e|cw_e|(pre_y1_e != pre_y1_e_r))?1'b1:pre_y1_e;
  endmodule
  
  module one_bit_adder(a0,b0,c0,s0,c1);
  
  /* three inputs which are 1 bit each */
  input a0;
  input b0;
  input c0;/* carry in */
  
  /* two outputs which are 1 bit each */
  output s0;/* sum */
  output c1;/* carry out */
  
  assign s0 = a0^b0^c0;
  assign c1 = (a0&b0)|(b0&c0)|(c0&a0);
  
  endmodule

