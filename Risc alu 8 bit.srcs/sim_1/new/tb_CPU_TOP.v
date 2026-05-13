`timescale 1ns/1ps

module CPU_Top_TB;

reg clk;
reg rst;

wire [7:0] PC_out;
wire [7:0] ALU_out;

// DUT
CPU_Top DUT (
    .clk(clk),
    .rst(rst),
    .PC_out(PC_out),
    .ALU_out(ALU_out)
);

// clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    #20 rst = 0;

    #200;

    $finish;
end

endmodule