//filter and decimator
module Filter(input CLK,
              input RST,
              input IN,
              output reg [7:0] OUT);
 
  // Declaring the filter parameters
  parameter a0 = 1;
  parameter a1 = -2;
  parameter a2 = 1;
 
  // Declaring the circular averaging buffer
  parameter BUF_SIZE = 64;
  reg [7:0] buffer [0:BUF_SIZE-1];
  reg [6:0] buf_counter;
 
  // Downsampling counter
  reg [6:0] ds_counter;
 
  // Filter state variables
  reg [7:0] x;
  reg [7:0] y1;
  reg [7:0] y2;

  // Integer used for loops
  integer i;

  reg signed [9:0] sum;
  reg [7:0] avg;
 
  always @ (posedge CLK or negedge RST) begin
    if(RST == 0) begin
      // Reset output to 0
      OUT <= 0;
     
      // Reset the filter state variables
      y1 <= 0;
      y2 <= 0;
     
      // Reset the averaging buffer
      buf_counter <= 0;
      for (i = 0; i < BUF_SIZE; i=i+1) begin
        buffer[i] = 0;
      end
     
      // Reset the downsample counter
      ds_counter <= 0;
     
    end
    else begin
      // Filter the input sample and add it to the buffer
      x <= IN;
      buffer[buf_counter] = (IN + y2 > 2 * y1) ? IN - 2*y1 + y2 : 0;
      //OUT = buffer[buf_counter];
      // Update the filter state variables
      y2 <= y1;
      y1 <= x;
     
      // Increase the counter and reset to 0 if it gets to 64
      buf_counter <= (buf_counter == BUF_SIZE - 1) ? 0 : buf_counter + 1;
      
      // Compute the running average of the buffer
      sum = 0;
      for (i = 0; i < BUF_SIZE; i = i + 1) begin
        sum = sum + buffer[i];
      end
      // avg <= ((sum*10) / BUF_SIZE);
      if(((sum*10) / BUF_SIZE)<5) //avoids flooring when getting avg
        avg <= (sum*) / BUF_SIZE;
      else
        avg <= 1;
     
      // Downsample output by selecting one in every 64 samples
      ds_counter <= ds_counter + 1;
      if (ds_counter == 64) begin
        OUT <= avg;
        ds_counter <= 0;
      end else begin
        OUT <= 0;
      end
      
    end
  end
endmodule