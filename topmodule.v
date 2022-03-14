module topmodule

( input  clk, rst,
  output  [15:0] test_value 
);

wire [31:0] PC, ALUOut , WriteData, ReadData, Instr ;
wire MemtoReg, ALUSrc, RegDst, RegWrite, MemWrite, Branch, Jump , PCSrc, zero ;
wire [2:0]  ALUControl;


assign PCSrc  = zero & Branch ;

 data_path D1 (

.clk(clk),
.rst(rst),
.PCSrc(PCSrc),
.ALUControl(ALUControl),
.MemtoReg(MemtoReg),
.ALUSrc(ALUSrc),
.RegDst(RegDst),
.RegWrite(RegWrite),
.ReadData(ReadData),
.Instr(Instr),
.Jump(Jump),
.zero(zero),
.PC(PC),
.ALUOut(ALUOut),
.WriteData(WriteData)

);



 control_unit C1(

.Instr(Instr),
.MemtoReg(MemtoReg),
.Branch(Branch),
.ALUSrc(ALUSrc),
.RegDst(RegDst),
.RegWrite(RegWrite),
.Jump(Jump),
.ALUControl(ALUControl),
.MemWrite(MemWrite)


);

 RAM R1(
.clk(clk),
.rst(rst),
.WE(MemWrite),
.WD(WriteData),
.A(ALUOut),
.test_value(test_value),
.RD(ReadData)

);

 Instruction_memory I1 (

.PC(PC),
.Inst(Instr)

);







endmodule