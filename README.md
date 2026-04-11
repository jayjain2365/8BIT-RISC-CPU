# 8-bit RISC CPU Design (Verilog)
# Overview

This project implements a simple **8-bit RISC processor** using Verilog HDL.
It demonstrates fundamental CPU architecture concepts including datapath and control unit design.

## Features

* 8-bit ALU (ADD, SUB, AND, OR, XOR)
* 8×8 Register File
* Program Counter (PC)
* Instruction Memory (ROM)
* Control Unit (FSM: Fetch → Decode → Execute)
* Fully synthesizable design
* Simulated using Xilinx Vivado

## Instruction Format

| Bits  | Field                |
| ----- | -------------------- |
| [7:5] | Opcode               |
| [4:3] | Destination Register |
| [2:0] | Source Register      |

## Modules

* ALU
* Register File
* Program Counter
* Instruction Memory
* Control Unit
* CPU Top Module

## Simulation

* Testbench verifies instruction execution
* Waveforms observed using Vivado simulator

## How to Run

1. Add design file to **Design Sources**
2. Add testbench to **Simulation Sources**
3. Set testbench as top
4. Run Behavioral Simulation

## Future Improvements

* Branch instructions
* Immediate operations
* Pipeline implementation
* Hazard detection

## Author

Jay Jain
