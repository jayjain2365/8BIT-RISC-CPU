//=========================================================
// Testbench for 8-bit RISC CPU
//=========================================================
`timescale 1ns/1ps

module tb_RISC_CPU;

    // Clock & Reset
    reg clk;
    reg rst;

    // Wires to monitor CPU outputs
    wire [7:0] alu_out;
    wire [7:0] instr;
    wire [2:0] alu_sel;
    wire write_en;
    wire [2:0] read_addr1, read_addr2, write_addr;
    wire jmp_en;
    wire [7:0] jmp_addr;

    // Instantiate top-level CPU (connect your module name here)
    RISC_CPU uut (
        .clk(clk),
        .rst(rst),
        .alu_out(alu_out),
        .instruction(instr),
        .ALU_Sel(alu_sel),
        .write_en(write_en),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .jmp_en(jmp_en),
        .jmp_addr(jmp_addr)
    );

    // Clock generation: 10 ns period (100 MHz)
    always #5 clk = ~clk;

    // Initial block
    initial begin
        // Initialize
        clk = 0;
        rst = 1;

        // Hold reset for few cycles
        #20;
        rst = 0;

        // Run CPU for 200 ns (you can extend)
        #200;

        // Stop simulation
        $stop;
    end

    // Optional monitoring (for console output)
    initial begin
        $monitor("Time=%0t | Instr=%b | ALU_Sel=%b | ALU_Out=%b | W_En=%b | Read1=%b | Read2=%b | Write=%b", 
                 $time, instr, alu_sel, alu_out, write_en, read_addr1, read_addr2, write_addr);
    end

endmodule
