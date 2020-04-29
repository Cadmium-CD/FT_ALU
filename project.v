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
  wire [2:0] cw_e_tmr;
  wire       cw_e;

  codeword_check codeword_checker_1(A0,A1,A2,B0,B1,B2,PAR,cw_e_tmr[0]);
  codeword_check codeword_checker_2(A0,A1,A2,B0,B1,B2,PAR,cw_e_tmr[1]);
  codeword_check codeword_checker_3(A0,A1,A2,B0,B1,B2,PAR,cw_e_tmr[2]);
  tmr_voter      tmr_voter_cw(cw_e_tmr[0],cw_e_tmr[1],cw_e_tmr[2],cw_e);
  

  
  //Determine if the control signal is one-hot or not
  wire [2:0] ci_e_tmr;
  wire       ci_e;
  control_check ctl_checker_1(C0,C1,C2,ci_e_tmr[0]);
  control_check ctl_checker_2(C0,C1,C2,ci_e_tmr[1]);
  control_check ctl_checker_3(C0,C1,C2,ci_e_tmr[2]);
  tmr_voter     tmr_voter_ci(ci_e_tmr[0],ci_e_tmr[1],ci_e_tmr[2],ci_e);

  //Determine the operation type and encode 
  wire [2:0]post_a;
  wire [2:0]post_b;
  wire [2:0]post_a_r;
  wire [2:0]post_b_r;
  wire [2:0]comp_a;
  wire [2:0]comp_b;
  wire [2:0]comp_a_r;
  wire [2:0]comp_b_r;

  assign comp_a = {!A2,!A1,!A0} + 1;//TODO
  assign comp_b = {!B2,!B1,!B0} + 1;
  assign comp_a_r = {!A2,!A1,!A0} + 1;
  assign comp_b_r = {!B2,!B1,!B0} + 1;
  
  assign post_a = C2?comp_a:{A2,A1,A0};
  assign post_b = C1?comp_b:{B2,B1,B0};
  assign post_a_r = C2?comp_a:{A2,A1,A0};
  assign post_b_r = C1?comp_b:{B2,B1,B0};
  
  //Decode data using hamming code
  wire [2:0]hm_code_a;
  wire [2:0]hm_code_b;
  wire [2:0]hm_code_carry;
  wire [2:0]hm_code_a_r;
  wire [2:0]hm_code_b_r;
  wire [2:0]hm_code_carry_r;

  hm_encode hm_encode_1_a(post_a,hm_code_a);
  hm_encode hm_encode_1_b(post_b,hm_code_b);
  hm_encode hm_encode_1_carry({w_adder_1[1],w_adder_1[0],1'b0},hm_code_carry);

  hm_encode hm_encode_1_a_r(post_a_r,hm_code_a_r);
  hm_encode hm_encode_1_b_r(post_b_r,hm_code_b_r);
  hm_encode hm_encode_1_carry_r({w_adder_1_r[1],w_adder_1_r[0],1'b0},hm_code_carry_r);

  //Correct error using hamming code
  wire [2:0]post_sum_1;
  wire [2:0]post_sum_1_r;
  wire [2:0]hm_code_carry;
  wire [2:0]hm_code_carry_r;

  hm_err_cor hm_err_cor_1(pre_sum_1,hm_code_a,hm_code_b,hm_code_carry,post_sum_1);
  hm_err_cor hm_err_cor_1_r(pre_sum_1_r,hm_code_a_r,hm_code_b_r,hm_code_carry_r,post_sum_1_r);

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
  
  assign X0 = post_sum_1[0];
  assign X1 = post_sum_1[1];
  assign X2 = post_sum_1[2];
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
  wire  pre_y1_e;
  wire  pre_y1_e_r;
  
  
  //Parity checking
  //FIXME assign pre_x0_e = (pre_sum_1[0]^pre_sum_1_r[0]) | (pre_sum_1[1]^pre_sum_1_r[1]);
  assign pre_x0_e = (post_sum_1[0]^post_sum_1_r[0]) | (post_sum_1[1]^post_sum_1_r[1]);
  assign pre_x0_e_r = (post_sum_1[0]^post_sum_1_r[0]) | (post_sum_1[1]^post_sum_1_r[1]);
  assign pre_x1_e = !((post_sum_1[2]^post_sum_1_r[2]) | (cout_1^cout_1_r));
  assign pre_x1_e_r = !((post_sum_1[2]^post_sum_1_r[2]) | (cout_1^cout_1_r));
  
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
  


module hm_encode(message,code);
input  [2:0] message;
output [2:0] code;

wire p1,p2,p4;

assign p1 = message[0]^message[1];
assign p2 = message[0]^message[2];
assign p4 = message[1]^message[2];
assign code = {p4,p2,p1};
endmodule

module hm_err_cor(message,a_p,b_p,carry_p,r_message);
input  [2:0] message;
input  [2:0] a_p;
input  [2:0] b_p;
input  [2:0] carry_p;
output [2:0] r_message;

wire p1_exp,p2_exp,p4_exp;
wire p1_act,p2_act,p4_act;
wire p1_e,p2_e,p4_e; 

assign p1_exp = a_p[0]^b_p[0]^carry_p[0];
assign p2_exp = a_p[1]^b_p[1]^carry_p[1];
assign p4_exp = a_p[2]^b_p[2]^carry_p[2];

assign p1_act = message[0]^message[1];
assign p2_act = message[0]^message[2];
assign p4_act = message[1]^message[2];

assign p1_e =p1_exp^p1_act;
assign p2_e =p2_exp^p2_act;
assign p4_e =p4_exp^p4_act;

assign r_message = {(p1_e&p2_e&p4_e)^message[2],(p1_e&p4_e)^message[1],(p1_e&p2_e)^message[0]};//need a seperate alu for adding parity bit
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

  module codeword_check(a0,a1,a2,b0,b1,b2,par,er);
    input a0,a1,a2,b0,b1,b2,par;
    output er;
    wire       is_n_cw,is_n_cw_b;
    wire [1:0] w_cw; 
  
    assign w_cw[0] = a1^a2;
    assign is_n_cw = a0^w_cw[0];
    assign w_cw[1] = b1^b2;
    assign is_n_cw_b = b0^w_cw[1];
  
    assign er = !(is_n_cw^is_n_cw_b^par);
  endmodule

  module tmr_voter(a,b,c,v);
    input a,b,c;
    output v;
    wire s;

    assign s = a^b;
    assign v = s?c:b;

  endmodule 

  module control_check(c0,c1,c2,er);
    input c0,c1,c2;
    output er;
    wire [2:0] w_ci; 

    assign w_ci[0] = (c0)|(c1)|(!c2);
    assign w_ci[1] = (c0)|(!c1)|(c2);
    assign w_ci[2] = (!c0)|(c1)|(c2);
    
    assign er = w_ci[0]&w_ci[1]&w_ci[2];
  endmodule
