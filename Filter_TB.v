// Testbench code for Filter & Decimator     64/44=16/11 //`time scale sets how long sim cycle lasts
module Filter_TB();
 
reg clk;
reg rst;
reg in;
reg [127:0] dataword;

wire [7:0]out;

Filter DUT(.CLK(clk),
          .RST(rst),
          .IN(in),
          .OUT(out));

initial
begin
   $dumpfile("dump.vcd");
        $dumpvars(1);
        clk<=0;
  rst=1;
  #10
  rst=0;
  #10
  rst=1;

// data upload 1    xxV0123456789ABC?
  dataword = 128'h02FF37abc326a7202381f0FF2a23f6be;
  #10
  dataword = 128'h3864292ae9600269F0FF73abc3b7a721;
  #10
  dataword = 128'h02395830aFF2a23FFbe3864792ae9603;
  #10
  dataword = 128'h312899abc02138698329aef923073785;
  #10
  dataword = 128'h0239830aFF2a23698329aef923073785;
  #10

  $finish;
end




always #5
begin
  clk <= ~clk;
end


always @(posedge clk)
begin
  in <= dataword[127];
  dataword <= { dataword[126:0],1'b0}; //left wise bit shifts
end



// module group2 group2_code(.clk (clk),
//                           .data (bitdata),
//                           .reset_n (reset_n),
//                           etc etc etc
//                                              )


endmodule

