
# Small Instruction Processor

This project implements a small instruction processor using Verilog and SystemVerilog. The processor is designed to execute a set of basic instructions and is intended for educational purposes to understand the fundamentals of processor design.

# Diagram ----------------------------------

https://github.com/user-attachments/assets/f44816a1-0d43-4adf-9f38-a6cf97a528f5


## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Overview

The small instruction processor is a simplified version of a CPU that can execute a limited set of instructions. It is designed to demonstrate the basic concepts of instruction fetching, decoding, and execution.

## Features

- **Instruction Set**: Supports a small set of instructions including MOV, MOVESGPR ,ADD, SUB, MUL, STORE, and JUMP,XOR,NAND,NOT,XNOR,NOR,JNZ,JZ,JC,JNC etc.
- **Pipelining**: Basic pipelining is implemented to improve performance.
- **Testbenches**: Includes testbenches to verify the functionality of the processor.

## Getting Started

### Prerequisites

- **Verilog/SystemVerilog Simulator**: You will need a Verilog/SystemVerilog simulator such as ModelSim, Vivado, or Icarus Verilog.
- **Git**: To clone the repository.

### Installation

1. Clone the repository:
   ```bash
   [git clone https://github.com/Aftabrahaman/small-instruction-processor.git
## Project Structure 
small-instruction-processor/
-** README.md**
-** processor.v**              # Main processor module
-**processor_tb.v**            # Testbench for the processor
-** alu.v**                   # Arithmetic Logic Unit
-** control_unit.v**           # Control Unit
