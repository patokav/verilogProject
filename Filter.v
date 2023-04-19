module Filter(input CLK,
              input RST,
              input IN,
              output reg [7:0] OUT);
    
  reg [7:0] MEM [0:63];
  reg [7:0] VAL;
  reg [7:0] COUNT;
  reg [11:0] AVG;

  reg FLAG;

  reg V1;
  reg V2; //delayed by 1 clock
  reg V3; //delayed by 2 clocks

  integer i;

  //holds for calcs
  reg H2;

  //filter = x1-2x2+x3

  always @ (posedge CLK or negedge RST) begin
    if(RST == 0) begin
      FLAG <= 1'b0;
      VAL <= 0;
      V1 <= 0;
      V2 <= 0;
      V3 <= 0;
      H2 <= 0;
      COUNT <= 0;
      
      for (i = 0; i < 64; i=i+1) begin
        MEM[i] <= 0;
      end
    end
    else begin
      if(COUNT==63) begin
        V3 <= V2; // moving the values along the chain with 1 cycle delay
        V2 <= V1;
        V1 <= IN; // moving the values along the chain with 1 cycle delay
        FLAG <= 1'b1;
        COUNT <= 0;
      end
      else begin
        COUNT++;
      end
    end
  end

  always @ (V2) begin
    H2 <= (V2 << 1); //multiply by 2
  end

  always @ (V1 or H2 or V3) begin
    VAL <= (V1 - H2 + V3);
  end

  always @ (COUNT) begin
    i <= 0;
    MEM[COUNT] <= VAL; //using COUNT to iterate over array

    if (FLAG) begin
      AVG <= 0;
      for(i=0; i < 64; i = i + 1) begin
        AVG <= AVG + MEM[i];
      end

      OUT <= AVG >> 6;
    end
  end
endmodule