module ALU (
    input  [7:0] A, B,       // Operands
    input  [2:0] ALU_Sel,    // ALU operation select
    output reg [7:0] ALU_Out,
    output reg Zero_Flag
);
always @(*) begin
    case (ALU_Sel)
        3'b000: ALU_Out = A + B;          // ADD
        3'b001: ALU_Out = A - B;          // SUB
        3'b010: ALU_Out = A & B;          // AND
        3'b011: ALU_Out = A | B;          // OR
        3'b100: ALU_Out = A ^ B;          // XOR
        3'b101: ALU_Out = B;              // MOV
        3'b110: ALU_Out = (A == B) ? 8'd1 : 8'd0; // CMP
        3'b111: ALU_Out = (A==~B)? 8'd1: 8'd0;  //CMP NEGATIVE OF B WITH A
        default: ALU_Out = 8'd0;
    endcase
    Zero_Flag = (ALU_Out == 8'd0);
end
endmodule

// 8x8 Register File
module RegisterFile (
    input clk, rst,
    input write_en,
    input [2:0] read_addr1, read_addr2, write_addr,
    input [7:0] write_data,
    output [7:0] read_data1, read_data2,
    output reg [7:0] regfile
);

reg [7:0] regs [7:0]; // 8 registers (R0-R7)
assign read_data1 = regs[read_addr1];
assign read_data2 = regs[read_addr2];
always @(posedge clk or posedge rst) begin
    if (rst)
        regs[0] <= 8'd0; // reset only R0 (optional)
    else if (write_en)
        regs[write_addr] <= write_data;
end
integer i;
always @(posedge rst) begin
    for (i = 0; i < 8; i = i + 1)
        regfile[i] <= 8'd0;
end

endmodule

// Program Counter
module ProgramCounter (
    input clk, rst,
    input jmp_en,
    input [7:0] jmp_addr,
    output reg [7:0] PC
);

always @(posedge clk or posedge rst) begin
    if (rst)
        PC <= 8'd0;
    else if (jmp_en)
        PC <= jmp_addr;
    else
        PC <= PC + 1;
end
endmodule
// Instruction Memory (ROM)
module InstructionMemory (
    input [7:0] addr,
    output reg [7:0] instruction
);

reg [7:0] memory [0:255];
initial begin
    memory[0] = 8'b000_001_010;  // ADD R1, R2
    memory[1] = 8'b001_010_011;  // SUB R2, R3
    memory[2] = 8'b010_011_100;  // AND R3, R4
    memory[3] = 8'b011_100_101;  // OR  R4, R5
    memory[4] = 8'b000_000_000;  // NOP
end

always @(*) 
    instruction = memory[addr];
endmodule
// Control Unit (Simple FSM)
module ControlUnit (
    input clk, rst,
    input [7:0] instruction,
    output reg [2:0] ALU_Sel,
    output reg [2:0] read_addr1, read_addr2, write_addr,
    output reg write_en,
    output reg jmp_en,
    output reg [7:0] jmp_addr
);

reg [1:0] state;
parameter FETCH=2'd0, DECODE=2'd1, EXECUTE=2'd2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= FETCH;
        write_en <= 0;
        jmp_en <= 0;
    end
    else begin
        case (state)
            FETCH: state <= DECODE;
            DECODE: begin
                ALU_Sel <= instruction[7:5];
                write_addr <= instruction[4:3];
                read_addr1 <= instruction[4:3];
                read_addr2 <= instruction[2:0];
                state <= EXECUTE;
            end
            EXECUTE: begin
                write_en <= 1;
                state <= FETCH;
            end
        endcase
    end
end

endmodule
module CPU_Top (
    input clk, rst
);

wire [7:0] instruction, PC_out;
wire [7:0] read_data1, read_data2, ALU_out;
wire [2:0] ALU_Sel, read_addr1, read_addr2, write_addr;
wire write_en, jmp_en;
wire [7:0] jmp_addr;
wire Zero_Flag;

// Instantiate modules
ProgramCounter PC(clk, rst, jmp_en, jmp_addr, PC_out);
InstructionMemory IM(PC_out, instruction);
ControlUnit CU(clk, rst, instruction, ALU_Sel, read_addr1, read_addr2, write_addr, write_en, jmp_en, jmp_addr);
RegisterFile RF(clk, rst, write_en, read_addr1, read_addr2, write_addr, ALU_out, read_data1, read_data2);
ALU ALU1(read_data1, read_data2, ALU_Sel, ALU_out, Zero_Flag);

endmodule
