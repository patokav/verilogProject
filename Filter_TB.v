// Testbench code for Filter & Decimator     
module Filter_TB();
 
  reg clk;
  reg rst;
  reg in;
  reg [127:0] dataword;

  wire [7:0]out;

  Filter DUT(
    .CLK(clk),
    .RST(rst),
    .IN(in),
    .OUT(out)
  );

  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(2);
    $monitor("%d", out);
    
  	clk = 1'b0;
    in = 1'b0;
    dataword = 0;
    
    //reset at start to set values
    rst = 1'b1;
    #100
    rst <= 1'b0;
    #100
    rst <= 1'b1;

    // data upload 1    xxV0123456789ABC?
    dataword = 128'h00000000000000000000000000000000; 
    #6425 //edge case ^
    dataword = 128'h02FF37abc326a7202381f0FF2a23f6be;
    #6425
    dataword = 128'h3864292ae9600269F0FF73abc3b7a721;
    #6425
    dataword = 128'h02395830aFF2a23FFbe3864792ae9603;
    #6425
    dataword = 128'h312899abc02138698329aef923073785;
    #6425
    dataword = 128'h0239830aFF2a23698329aef923073785;
    #6425 
    dataword = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    #6425 //edge case ^

   $finish;
  end

  always #25
  begin
    clk <= ~clk;
  end
  
  // always #50
  // $display ("%d", in);

  always @(posedge clk) begin
    in <= dataword[127];
    dataword <= { dataword[126:0], 1'b0 }; //left wise bit shifts
    //$display ("in = %b", in);
  end
endmodule