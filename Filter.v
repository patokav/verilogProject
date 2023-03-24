module Filter ();
    
input DATA;
input CLK;
input RST;
input [127:0] DATAWORD;

output reg [7:0]OUT;

reg [7:0] COUNT;

reg [7:0] AVG [64];

reg [127:0] V1;
reg [127:0] V2; //delayed by 1 clock
reg [127:0] V3; //delayed by 2 clocks

//holds for calcs
reg [127:0] H2;

//filter = x1-2x2+x3

always @(posedge CLK or negedge RST)
begin
    if(COUNT==63)
    begin
        V3<= V2; ///moving the values along the chain with 1 cycle delay
        V2<= V1;
        V1<= DATA; ///moving the values along the chain with 1 cycle delay
    end
    else
    begin
        COUNT++;
    end
    if(RST==0)
    begin
        OUT<=0;
        V1<=0;
        V2<=0;
        V3<=0;
        COUNT<=0;
    end
    else

end

always@(V1 or V2 or V3)
begin
    H2<= (V2<<1);
end

always@(V1 or H2 or V3)
begin
    HOLD<=(V1-H2+V3);
end





endmodule