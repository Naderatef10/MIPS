module data_path 

#(parameter WIDTH = 32)
(
input wire  clk,PCSrc,rst,
input wire  [2:0]ALUControl,
input wire  MemtoReg,ALUSrc,RegDst,RegWrite,
input wire  [WIDTH-1:0]ReadData,[WIDTH-1:0]Instr,
input wire  Jump,
output wire zero,
output wire [WIDTH-1:0]PC,[WIDTH-1:0]ALUOut,[WIDTH-1:0]WriteData
);


wire [WIDTH-1:0]PCBranch;
wire [WIDTH-1:0]PCPlus4;
wire [25:0]shift1_input;
wire [WIDTH-1:0]SrcA;
wire [WIDTH-1:0]SrcB;
wire [WIDTH-1:0]RD2;
wire [4:0]MUX_A3;
wire [WIDTH-1:0]MUX_WD3;
wire [WIDTH-1:0]Signlmm;
wire [25:0] output_shifter;
wire [WIDTH-1:0] MUX1_OUT;
wire [WIDTH-1:0] PCJump;
wire [WIDTH-1:0] PC_temp;
wire [WIDTH-1:0]PC_OUTPUT;
wire [WIDTH-1:0] input1;
assign PC_OUTPUT = PC ; 
assign PCJump = {PC[31:28],Instr[25:0],2'b00};
assign WriteData = RD2;

register_file inst1 (
.A1(Instr[25:21]),
.A2(Instr[20:16]),
.A3(MUX_A3),
.WD3(MUX_WD3),
.WE3(RegWrite),
.RD1(SrcA),
.RD2(RD2),
.clk(clk),
.rst(rst)
);


ALU A1(
.SrcA(SrcA),
.SrcB(SrcB),
.zero(zero),
.ALU_Control(ALUControl),
.ALUResult(ALUOut)
);

sign_extend inst3(
.Inst(Instr[15:0]),
.Signlmm(Signlmm)
);

MUX2x1 M4(
.In1(RD2),
.In2(Signlmm),
.MUX_out(SrcB),
.Select(ALUSrc)
);
MUX2x1 #(.WIDTH(5)) M3(

.In1(Instr[20:16]),
.In2(Instr[15:11]),
.MUX_out(MUX_A3),
.Select(RegDst)

);

MUX2x1 M5(

.In1(ALUOut),
.In2(ReadData),
.MUX_out(MUX_WD3),
.Select(MemtoReg)
);

MUX2x1 M1(
 .In1(PCPlus4),
 .In2(PCBranch),
 .MUX_out(MUX1_OUT),
 .Select(PCSrc)
    
);

MUX2x1 M2(
    .In1(MUX1_OUT),
    .In2(PCJump),
    .MUX_out(PC_temp),
    .Select(Jump)
    );

pc_counter p1(

.clk(clk),
.rst(rst),
.PC_bar(PC_temp),
.PC(PC)
);



shift_left_twice  #(.WIDTH(32)) shift_twice1(
.in(Signlmm),
.out(input1)

);

Adder32 Add1(
.A_in(input1),
.B_in(PCPlus4),
.C_out(PCBranch)

);

Adder32 Add2(
  .A_in(PC_OUTPUT),
  .B_in(32'b100),
  .C_out(PCPlus4) 
);


endmodule