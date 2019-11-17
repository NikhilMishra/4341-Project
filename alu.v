//compiled with icarus iverilog v10.1 stable, downloaded from ubuntu apt-get

module FA(a,b,c,s,co);
input [7:0]a,b;
output [8:0]s;
output co;
input c;
Carry c1(a[0],b[0],c,s[0],cx0);
Carry c2(a[1],b[1],cx0,s[1],cx1);
Carry c3(a[2],b[2],cx1,s[2],cx2);
Carry c4(a[3],b[3],cx2,s[3],cx3);
Carry c5(a[4],b[4],cx3,s[4],cx4);
Carry c6(a[5],b[5],cx4,s[5],cx5);
Carry c7(a[6],b[6],cx5,s[6],cx6);
Carry c8(a[7],b[7],cx6,s[7],s[8]);
assign co = s[8];
endmodule


module Carry(a,b,c,s,co);
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

module Alu_int (input [15:0] a, b, input [1:0] op, output [31:0] res, output err);
endmodule

module Alu_not (input [15:0] a, output [31:0] res);
endmodule

module Alu_xor (input [15:0] a, b, output [31:0] res);
endmodule

module Alu_or (input [15:0] a, b, output [31:0] res);
endmodule

module Alu_and (input [15:0] a, b, output [31:0] res);
  always @ (posedge Clock)
  begin
    wire [5:0] i;
    for (i=0; i<16; i=i+1)
    begin
      //delay?
      and G0(a[i], b[i], res[i]);
    end
    for (i=16; i<32; i=i+1)
    begin
      //delay?
      assign res[i] = 0;
    end
  end
endmodule

module Alu_bool (input [15:0] a, b, input [1:0] op, output [31:0] res);
  always @ (posedge Clock)
  begin
    if (op == 0)
      Alu_and M0(a, b, res);
    if (op == 1)
      Alu_or  M1(a, b, res);
    if (op == 2)
      Alu_xor M2(a, b, res);
    if (op == 3)
      Alu_not M3(a, res);
  end
endmodule

module Alu (input [15:0] a, b, input mode, input [1:0] op, output [31:0] res, output err);
  always @ (posedge Clock)
  begin
    if (mode == 0)
      assign err = 0;
      Alu_bool M0(a, b, op, res);
    if (mode == 1)
      Alu_int  M1(a, b, op, res, err);
  end
endmodule

//----------------------------------------------------------------------

module testbench();
  reg [16:0] a;
  reg [16:0] b;
  reg [1:0] mode;
  reg [2:0] op;
   
  wire [31:0] res;
  wire err;
  
  Alu run(a,b,mode,op,res,err);

  initial begin
   	
  $display ("A               |B               |M|Op|Result                          |E");
  $display ("================+================+=+==+================================+=");
  
  for(mode=0; mode<2; mode=mode+1)
  begin
    for(op=0; op<4; op=op+1)
    begin
      for (a = 0; a < 65536; a = a + 1) 
      begin
        #5
        for (b = 0; b < 65536; b = b + 1) 
        begin
          #5
          $display ("%16d|%16d|%d|%2d|%32d|%d",a,b,mode,op,res,err);
        end 
      end
    end
	end//End of the for loop code block
 
	#10 //A time delay of 10 time units. Hashtag Delay
	$finish;//A command, not unlike System.exit(0) in Java.
  end  //End the code block of the main (initial)
  
endmodule //Close the testbench module
