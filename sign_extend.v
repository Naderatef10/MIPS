module sign_extend 

( input wire [15:0]Inst,
  output reg  [31:0]Signlmm
);
wire [15:0] ones = 16'b 1111_1111_1111_1111 ;
wire [15:0] zeros = 16'b 0000_0000_0000_0000 ;
always @(*) begin
    if(Inst[15]==1)

        begin
        Signlmm = { ones , Inst[15:0]};
        end
        else
        begin
    
        Signlmm = {zeros , Inst[15:0]};

        end 




end











endmodule 