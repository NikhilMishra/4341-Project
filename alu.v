//compiled with icarus iverilog v10.1 stable, downloaded from ubuntu apt-get

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
  
  for(mode=0; mode<1; mode=mode+1)
  begin
    for(op=0; op<4; op=op+1)
    begin
      for (a = 0; a < 16; a = a + 1) 
      begin
        #5
        for (b = 0; b < 16; b = b + 1) 
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
