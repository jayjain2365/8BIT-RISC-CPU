`timescale 1ns/1ps

// ================= ALU =================
module ALU (
    input  [7:0] A, B,
    input  [2:0] ALU_Sel,
    output reg [7:0] ALU_Out,
    output reg Zero_Flag
);

always @(*) begin
    case(ALU_Sel)
        3'b000: ALU_Out = A + B;
        3'b001: ALU_Out = A - B;
        3'b010: ALU_Out = A & B;
        3'b011: ALU_Out = A | B;
        3'b100: ALU_Out = A ^ B;
        default: ALU_Out = 8'd0;
    endcase

    Zero_Flag = (ALU_Out == 0);
end
endmodule


// ============== REGISTER FILE ==========
module RegisterFile (
    input clk, rst,
    input write_en,
    input [2:0] read_addr1, read_addr2, write_addr,
    input [7:0] write_data,
    output [7:0] read_data1, read_data2
);

reg [7:0] regs [7:0];
integer i;

assign read_data1 = regs[read_addr1];
assign read_data2 = regs[read_addr2];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize registers
        regs[0] <= 8'd1;
        regs[1] <= 8'd10;
        regs[2] <= 8'd5;
        regs[3] <= 8'd7;
        regs[4] <= 8'd12;
        regs[5] <= 8'd3;
        regs[6] <= 8'd0;
        regs[7] <= 8'd0;
    end 
    else if (write_en)
        regs[write_addr] <= write_data;
end
endmodule


// ============== PROGRAM COUNTER ==========
module ProgramCounter (
    input clk, rst,
    output reg [7:0] PC
);

always @(posedge clk or posedge rst) begin
    if (rst)
        PC <= 0;
    else
        PC <= PC + 1;
end
endmodule


// ============== INSTRUCTION MEMORY ==========
module InstructionMemory (
    input [7:0] addr,
    output reg [7:0] instruction
);

reg [7:0] mem [0:255];
integer i;

initial begin
    for (i = 0; i < 256; i = i + 1)
        mem[i] = 8'b000_00_000; // NOP

    mem[0] = 8'b000_01_010; // ADD R1, R2
    mem[1] = 8'b001_10_011; // SUB R2, R3
    mem[2] = 8'b010_11_100; // AND R3, R4
    mem[3] = 8'b011_00_101; // OR  R0, R5
end

always @(*) instruction = mem[addr];

endmodule


// ============== CONTROL UNIT ==========
module ControlUnit (
    input clk, rst,
    input [7:0] instruction,
    output reg [2:0] ALU_Sel,
    output reg [2:0] read_addr1, read_addr2, write_addr,
    output reg write_en
);

reg [1:0] state;
parameter FETCH=0, DECODE=1, EXECUTE=2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= FETCH;
        write_en <= 0;
    end
    else begin
        case(state)

        FETCH: state <= DECODE;

        DECODE: begin
            ALU_Sel    <= instruction[7:5];
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


// ============== CPU TOP ==========
module CPU_Top (
    input clk, rst,
    output [7:0] PC_out,
    output [7:0] ALU_out
);

wire [7:0] instruction;
wire [7:0] read_data1, read_data2;
wire [2:0] ALU_Sel, read_addr1, read_addr2, write_addr;
wire write_en;

// connections
ProgramCounter PC(clk, rst, PC_out);
InstructionMemory IM(PC_out, instruction);

ControlUnit CU(clk, rst, instruction,
               ALU_Sel, read_addr1, read_addr2, write_addr,
               write_en);

RegisterFile RF(clk, rst, write_en,
                read_addr1, read_addr2, write_addr,
                ALU_out, read_data1, read_data2);

ALU ALU1(read_data1, read_data2, ALU_Sel, ALU_out);

endmodule