module control_unit
#( parameter WIDTH = 32, 
   loadWord = 6'b10_0011,
   storeWord = 6'b10_1011,
   rType = 6'b00_0000,
   addImmediate = 6'b00_1000,
   branchIfEqual = 6'b00_0100,
   jump_inst = 6'b00_0010


)
 
 
( input wire [WIDTH-1:0]Instr,
  output wire MemtoReg,
  output wire Branch,
  output wire ALUSrc,
  output wire RegDst,
  output wire RegWrite,
  output wire Jump,
  output wire [2:0]ALUControl,
  output wire MemWrite
);
       wire [5:0]Opcode;
       wire [5:0]Funct;
assign Opcode = Instr[31:26];
assign Funct =  Instr[5:0];


   reg MemtoReg_temp;
   reg Branch_temp; 
   reg ALUSrc_temp;
   reg RegDst_temp;
   reg RegWrite_temp;
   reg Jump_temp; 
   reg [1:0]ALUOp_temp;
   reg [2:0]ALUControl_temp;
   reg MemWrite_temp;

always @(*) begin
    
case(Opcode)

loadWord:
        begin 
        Jump_temp = 0 ;
        ALUOp_temp = 2'b00;
        MemWrite_temp = 1'b0;
        RegWrite_temp = 1'b1;
        RegDst_temp  = 1'b0;
        ALUSrc_temp = 1'b1;
        MemtoReg_temp = 1'b1;
        Branch_temp = 1'b0;


        end 

storeWord:
        begin 
        Jump_temp = 0 ;
        ALUOp_temp = 2'b00;
        MemWrite_temp = 1'b1;
        RegWrite_temp = 1'b0;
        RegDst_temp  = 1'b0;
        ALUSrc_temp = 1'b1;
        MemtoReg_temp = 1'b1;
        Branch_temp = 1'b0;



        end 
rType: 
       begin 
        Jump_temp = 0 ;
        ALUOp_temp = 2'b10;
        MemWrite_temp = 1'b0;
        RegWrite_temp = 1'b1;
        RegDst_temp  = 1'b1;
        ALUSrc_temp = 1'b0;
        MemtoReg_temp = 1'b0;
        Branch_temp = 1'b0;
      

       end 


addImmediate:
        begin 
        Jump_temp = 0 ;
        ALUOp_temp = 2'b00;
        MemWrite_temp = 1'b0;
        RegWrite_temp = 1'b1;
        RegDst_temp  = 1'b0;
        ALUSrc_temp = 1'b1;
        MemtoReg_temp = 1'b0;
        Branch_temp = 1'b0;

        end 

branchIfEqual:
        begin 
            Jump_temp = 0 ;
        ALUOp_temp = 2'b01;
        MemWrite_temp = 1'b0;
        RegWrite_temp = 1'b0;
        RegDst_temp  = 1'b0;
        ALUSrc_temp = 1'b0;
        MemtoReg_temp = 1'b0;
        Branch_temp = 1'b1;
        end 

jump_inst: 
        begin 
         Jump_temp = 1 ;
        ALUOp_temp = 2'b00;
        MemWrite_temp = 1'b0;
        RegWrite_temp = 1'b0;
        RegDst_temp  = 1'b0;
        ALUSrc_temp = 1'b0;
        MemtoReg_temp = 1'b0;
        Branch_temp = 1'b0;


        end 
  default:
       begin 
        Jump_temp = 0 ;
        ALUOp_temp = 2'b00;
        MemWrite_temp = 1'b0;
        RegWrite_temp = 1'b0;
        RegDst_temp  = 1'b0;
        ALUSrc_temp = 1'b0;
        MemtoReg_temp = 1'b0;
        Branch_temp = 1'b0;

       end 


endcase 

end
      wire [1:0]ALUOp;
      assign      Jump    = Jump_temp ;
      assign     ALUOp  = ALUOp_temp ;
      assign    MemWrite = MemWrite_temp;
      assign     RegWrite   = RegWrite_temp ;
      assign    RegDst   = RegDst_temp ;
      assign    ALUSrc   = ALUSrc_temp ;
      assign    MemtoReg  = MemtoReg_temp  ;
      assign    Branch  = Branch_temp ;

always @(*) begin
    
   case(ALUOp)

   2'b00:
    begin
     ALUControl_temp = 3'b010;

    end 
   2'b01:
   begin 
    ALUControl_temp =  3'b100;

   end 

   2'b10:
   begin
    case(Funct)
     6'b100000: // add case 
        begin
          
    ALUControl_temp = 3'b010;

        end 

     6'b100010: // sub case 
        begin  
     ALUControl_temp = 3'b100;

        end 

     6'b101010: // slt case 
        begin 
        ALUControl_temp = 3'b110;
        end 
     6'b011100: // mul case
       begin 
        ALUControl_temp = 3'b101;

       end 



    endcase   
 



   end 

   default:

   begin

    ALUControl_temp =  3'b010;
   end 

   endcase  

end

assign ALUControl = ALUControl_temp;








endmodule 