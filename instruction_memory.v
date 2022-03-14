module Instruction_memory (
    input wire [31:0]PC,
    output wire [31:0]Inst
    );
    
reg[31:0]Instruction_memory[31:0]; // 100 32 bit registers
reg [31:0]Instr;


        always @(*) begin
            
            Instr = Instruction_memory[PC>>2];
        end

        initial 
    
        begin

        $readmemh ("Program2_Machine_Code.txt", Instruction_memory);
        
        end
           
        
assign Inst = Instr;



endmodule