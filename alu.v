//compiled with icarus iverilog v10.1 stable, downloaded from ubuntu apt-get
module Alu_add (input [15:0] a, b, output [31:0] res);
endmodule

module Alu_sub (input [15:0] a, b, output [31:0] res);
endmodule

module Alu_mult (input [15:0] a, b, output [31:0] res);
endmodule

module Alu_div (input [15:0] a, b, output [31:0] res, output err);
endmodule

module Alu_int (input [15:0] a, b, input [1:0] op, output reg [31:0] res, output reg err);
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
      0: assign res = addout;
      1: assign res = subout;
      2: assign res = multout;
      3: assign res = divout;
    endcase
    if (op == 3) begin
      err = diverr;
    end else begin
      err = 0;
    end
  end
endmodule

module Alu_not (input [15:0] a, output [31:0] res);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    not G0(res[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign res[i] = 0;
  end
  endgenerate
endmodule

module Alu_xor (input [15:0] a, b, output [31:0] res);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    xor G0(res[i], b[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign res[i] = 0;
  end
  endgenerate
endmodule

module Alu_or (input [15:0] a, b, output [31:0] res);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    or G0(res[i], b[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign res[i] = 0;
  end
  endgenerate
endmodule

module Alu_and (input [15:0] a, b, output [31:0] res);
  generate
  genvar i;
  for (i=0; i<16; i=i+1)
  begin
    and G0(res[i], b[i], a[i]);
  end
  for (i=16; i<32; i=i+1)
  begin
    assign res[i] = 0;
  end
  endgenerate
endmodule

module Alu_bool (input [15:0] a, b, input [1:0] op, output reg [31:0] res);
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
      0: assign res = andout;
      1: assign res = orout;
      2: assign res = xorout;
      3: assign res = notout;
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
      err = 0;
    end else begin
      res = intout;
      err = interr;
    end
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
    #5
    for(op=0; op<4; op=op+1)
    begin
      #5
      for (a = 0; a < 2; a = a + 1) 
      begin
        #5
        for (b = 0; b < 2; b = b + 1) 
        begin
          #50
          $display ("%16d|%16d|%d|%2d|%32d|%d",a,b,mode,op,res,err);
        end 
      end
    end
	end//End of the for loop code block
 
	#10 //A time delay of 10 time units. Hashtag Delay
	$finish;//A command, not unlike System.exit(0) in Java.
  end  //End the code block of the main (initial)
  
endmodule //Close the testbench module
