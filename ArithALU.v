//compiled with icarus iverilog v10.1 stable, downloaded from ubuntu apt-get
module Alu_add (input [15:0] a, b, output [31:0] res);
reg c = 0;
Full_Add c1(a[0],b[0],c,res[0],cx0);
Full_Add c2(a[1],b[1],cx0,res[1],cx1);
Full_Add c3(a[2],b[2],cx1,res[2],cx2);
Full_Add c4(a[3],b[3],cx2,res[3],cx3);
Full_Add c5(a[4],b[4],cx3,res[4],cx4);
Full_Add c6(a[5],b[5],cx4,res[5],cx5);
Full_Add c7(a[6],b[6],cx5,res[6],cx6);
Full_Add c8(a[7],b[7],cx6,res[7],cx7);
Full_Add c9(a[8],b[8],cx7,res[8],cx8);
Full_Add c10(a[9],b[9],cx8,res[9],cx9);
Full_Add c11(a[10],b[10],cx9,res[10],cx10);
Full_Add c12(a[11],b[11],cx10,res[11],cx11);
Full_Add c13(a[12],b[12],cx11,res[12],cx12);
Full_Add c14(a[13],b[13],cx12,res[13],cx13);
Full_Add c15(a[14],b[14],cx13,res[14],cx14);
Full_Add c16(a[15],b[15],cx14,res[15],o);     //overflow

// resolving twos complement
xnor (aXb, a[15], b[15]);
xor (axb, a[15], b[15]);
and (ab, a[15], b[15]);
and (a15, a[15], res[15]);
and (b15, b[15], res[15]);
and (aXbo, aXb, o);
and (axb15, axb, res[15]);

or (res[16], aXbo, axb15);
or (res[17], a15, b15, ab);
or (res[18], a15, b15, ab);
or (res[19], a15, b15, ab);
or (res[20], a15, b15, ab);
or (res[21], a15, b15, ab);
or (res[22], a15, b15, ab);
or (res[23], a15, b15, ab);
or (res[24], a15, b15, ab);
or (res[25], a15, b15, ab);
or (res[26], a15, b15, ab);
or (res[27], a15, b15, ab);
or (res[28], a15, b15, ab);
or (res[29], a15, b15, ab);
or (res[30], a15, b15, ab);
or (res[31], a15, b15, ab);

endmodule

module Full_Add(a,b,c,s,co);
input a,b;
input c;
output s,co;
wire out4;
wire out6;
and (out1,a,b);
xor (out2,a,b);
and (out3,out2,c);
or (out4,out3,out1);
assign co = out4;
xor (out5,a,b);
xor (out6,out5,c);
assign s = out6;
endmodule

module Alu_sub (input [15:0] a, b, output [31:0] res);
reg c = 0;
Full_Sub c1(a[0],b[0],c,res[0],cx0);
Full_Sub c2(a[1],b[1],cx0,res[1],cx1);
Full_Sub c3(a[2],b[2],cx1,res[2],cx2);
Full_Sub c4(a[3],b[3],cx2,res[3],cx3);
Full_Sub c5(a[4],b[4],cx3,res[4],cx4);
Full_Sub c6(a[5],b[5],cx4,res[5],cx5);
Full_Sub c7(a[6],b[6],cx5,res[6],cx6);
Full_Sub c8(a[7],b[7],cx6,res[7],cx7);
Full_Sub c9(a[8],b[8],cx7,res[8],cx8);
Full_Sub c10(a[9],b[9],cx8,res[9],cx9);
Full_Sub c11(a[10],b[10],cx9,res[10],cx10);
Full_Sub c12(a[11],b[11],cx10,res[11],cx11);
Full_Sub c13(a[12],b[12],cx11,res[12],cx12);
Full_Sub c14(a[13],b[13],cx12,res[13],cx13);
Full_Sub c15(a[14],b[14],cx13,res[14],cx14);
Full_Sub c16(a[15],b[15],cx14,res[15],O);     //overflow

//resolving twos complement
not(o, O);
not (B, b[15]);
xnor (aXb, a[15], b[15]);
xor (axb, a[15], b[15]);
and (aB, a[15], B);
and (a15, a[15], res[15]);
and (B15, B, res[15]);
and (axbo, axb, o);
and (aXb15, aXb, res[15]);

or (res[16], axbo, aXb15);
or (res[17], a15, B15, aB);
or (res[18], a15, B15, aB);
or (res[19], a15, B15, aB);
or (res[20], a15, B15, aB);
or (res[21], a15, B15, aB);
or (res[22], a15, B15, aB);
or (res[23], a15, B15, aB);
or (res[24], a15, B15, aB);
or (res[25], a15, B15, aB);
or (res[26], a15, B15, aB);
or (res[27], a15, B15, aB);
or (res[28], a15, B15, aB);
or (res[29], a15, B15, aB);
or (res[30], a15, B15, aB);
or (res[31], a15, B15, aB);
endmodule

module Full_Sub ( a ,b ,c ,s ,co );

output s ;
output co ;
input a ;
input b ;
input c ;
assign s = a ^ b ^ c;
assign co = ((~a) & b) | (b & c) | (c & (~a));
endmodule

module Alu_mult (input [15:0] a, b, output [31:0] multout);
// support two's complement multiplication
wire [31:0] a1;
wire [31:0] b1;
genvar i;
for (i = 0; i < 16; i = i + 1)
  begin
    assign a1[i] = a[i];
    assign b1[i] = b[i];
end
for (i = 16; i < 32; i = i + 1)
  begin
    assign a1[i] = a[15];
    assign b1[i] = b[15];
end

assign multout = a1*b1;
endmodule

module Alu_div (input [15:0] a, b, output [31:0] divout, output err);
    // divide by 0 error
    wire [16:0] e;
    assign e[0] = 0;
    genvar i;
    generate
    for (i=1; i<17; i=i+1)
    begin
        assign e[i] = b[i-1] | e[i-1];
    end
    endgenerate
    assign err = !e[16];

    // support negative division
    wire [15:0] a1 = a[15]? -a:a;
    wire [15:0] b1 = b[15]? -b:b;
    
    wire [31:0] temp = a1/b1;
    assign divout = a[15] ^ b[15] ? -temp:temp;
endmodule

module Alu_int (input [15:0] a, b, input [1:0] op, output reg [31:0] intout, output reg err);
  wire [31:0] addout;
  wire [31:0] subout;
  wire [31:0] multout;
  wire [31:0] divout;
  wire diverr;
  Alu_add M0(a,b,addout);
  Alu_sub M1(a,b,subout);
  Alu_mult M2(a,b,multout);
  Alu_div M3(a,b,divout,diverr);

  always @(*) begin
    case(op)
      0: assign intout = addout;
      1: assign intout = subout;
      2: assign intout = multout;
      3: assign intout = divout;
    endcase
    err = diverr && op[0] && op[1];
  end
endmodule

module Alu_not (input [15:0] a, output [31:0] notout);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    not G0(notout[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign notout[i] = 0;
  end
  endgenerate
endmodule

module Alu_xor (input [15:0] a, b, output [31:0] xorout);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    xor G0(xorout[i], b[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign xorout[i] = 0;
  end
  endgenerate
endmodule

module Alu_or (input [15:0] a, b, output [31:0] orout);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    or G0(orout[i], b[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign orout[i] = 0;
  end
  endgenerate
endmodule

module Alu_and (input [15:0] a, b, output [31:0] andout);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    and G0(andout[i], b[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign andout[i] = 0;
  end
  endgenerate
endmodule

module Alu_bool (input [15:0] a, b, input [1:0] op, output reg [31:0] boolout);
  wire [31:0] andout;
  wire [31:0] orout;
  wire [31:0] xorout;
  wire [31:0] notout;
  Alu_and M0(a,b,andout);
  Alu_or M1(a,b,orout);
  Alu_xor M2(a,b,xorout);
  Alu_not M3(a,notout);

  always @(*) begin
    case(op)
      0: assign boolout = andout;
      1: assign boolout = orout;
      2: assign boolout = xorout;
      3: assign boolout = notout;
    endcase
  end
endmodule

module Alu (input [15:0] a, b, input mode, input [1:0] op, output reg [31:0] res, output reg err);
  wire [31:0] boolout;
  wire [31:0] intout;
  wire interr;
  Alu_bool M0 (a, b, op, boolout);
  Alu_int  M1 (a, b, op, intout, interr);

  always @(*) begin
    if (mode == 0) begin
      res = boolout;
    end else begin
      res = intout;
    end
    err = mode && interr;
  end
endmodule

//----------------------------------------------------------------------

module testbench();
  reg signed [15:0] a;
  reg signed [15:0] b;
  reg mode;
  reg [40:0] modestr;
  reg [1:0] op;
  reg [32:0] opstr;
  wire signed [31:0] res;
  wire err;
  
  Alu run(a,b,mode,op,res,err);

  initial begin
    #60
    repeat (2) begin	
      $display ("             A            |             B            | Operation  |                    Result                      |Err|  Mode ");
      $display ("==========================+==========================+============+================================================+===+=======");
      #60
      
      repeat (4) begin
        repeat (10) begin
        #60
          if (mode == 0) begin
              modestr = "logic";
              case (op)
                  0 : opstr = " and";
                  1 : opstr = "  or";
                  2 : opstr = " xor";
                  default : opstr = " not";
              endcase
          end else begin
              modestr = " math";
              case (op)
                  0 : opstr = " add";
                  1 : opstr = " sub";
                  2 : opstr = "mult";
                  default : opstr = " div";
              endcase
          end
          $display (" %16b (%6d)| %16b (%6d)| %2b (%s) | %32b (%11d) | %d | %s ",a,a,b,b,op,opstr,res,res,err,modestr);
        end
        $display ();
      end
    end

    #10 //A time delay of 10 time units. Hashtag Delay
    $finish;//A command, not unlike System.exit(0) in Java.
  end  //End the code block of the main (initial)

  initial begin
    mode=0;
    #60
    repeat (2) begin
      op=0;
      #60
      repeat(4) begin
        a=32; b=27;
        #60
        a=81; b=-23; 
        #60
        a=-42; b=102; 
        #60
        a=-234; b=-56;
        #60
        a=16'b0111111111111111; b=16'b0111111111111111;
        #60
        a=16'b1000000000000000; b=16'b1000000000000000;
        #60
        a=16'b1010001001110011; b=16'b1001011100010110;
        #60
        a=16'b0111001111010001; b=16'b1101010000011001;
        #60
        a=16'b0000000000000000; b=16'b1101100011101100;
        #60
        a=16'b1100110000001111; b=16'b0000000000000000;
        #60
        op=op+1;
      end
      mode=mode+1;
    end
  end
  
endmodule //Close the testbench module








/*
25786
12984
-7152
-12202
-30076*/