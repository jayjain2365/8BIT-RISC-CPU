# 8BIT-RISC-CPU
“Verilog-based 8-bit RISC processor with ALU, control unit, register file, and instruction memory. Designed and simulated in Xilinx Vivado.”
# 8-bit RISC Processor

## 🧠 Overview
This project implements an 8-bit RISC CPU using Verilog HDL.  
It includes a simple instruction set architecture (ISA) and key components like:
- Arithmetic Logic Unit (ALU)
- Register File
- Control Unit (FSM-based)
- Program Counter & Instruction Memory

## ⚙️ Tools Used
- Xilinx Vivado (RTL Design & Simulation)
- ModelSim (Testbench Verification)
- GitHub for Version Control

## 📂 Project Structure
8bit-RISC-CPU/
│
├── src/                     
│   ├── ALU.v
│   ├── ControlUnit.v
│   ├── RegisterFile.v
│   ├── InstructionMemory.v
│   ├── RISC_CPU.v
│
├── tb/
│   └── tb_RISC_CPU.v
│
├── docs/                    
│   ├── block_diagram.png
│   ├── schematic.png
│   ├── waveform.png
│   └── project_report.pdf    
│
├── simulation/             
│   └── output_waveform.vcd
│
├── vivado_project/         
│   ├── 8bit_RISC_CPU.xpr
│   └── other Vivado files (.runs, .srcs, etc.)
│
├── README.md                
├── LICENSE                   
└── .gitignore                
