
# Shambhaditya Tarafdar (st496) & Ankit Raj (ar791)

# Simple Processor - Project Checkpoint 5

## Overview

Checkpoint 5 extends our simple, single-cycle 32-bit processor to support J-type instructions in addition to the R-type and I-type instructions implemented in Checkpoint 4. The processor now supports jumps, conditional branches, and exception handling through a range of J-type instructions, enhancing its control flow capabilities.

### Supported Instructions
- **R-type**: `add`, `sub`, `and`, `or`, `sll`, `sra`
- **I-type**: `addi`, `sw`, `lw`, `bne`, `blt`
- **JI and JII type**: `j`, `jal`, `jr`, `bex`, `setx`

## Project Structure

### Main Files

- **`alu.v`**  
  Implements the Arithmetic Logic Unit (ALU), which performs core operations like addition, subtraction, bitwise AND, OR, shift left logical (sll), and shift right arithmetic (sra). Operates based on control signals. It also integrates other arithmetic modules like multiplexers (MUXes) and Carry Select Adders (CSA).

- **`clk_div.v` and `clk_div_by2.v`**  
  Clock divider modules remain same as project checkpoint 4

- **`control_unit.v`**  
  Generates control signals for various modules based on the instruction type and opcode, including memory access, ALU operations, register writes, and J-type jumps and branches. This module is responsible for recognizing J-type instructions (`j`, `jal`, `jr`, `bex`, `bne`, `blt` , `setx`) and setting the appropriate control signals to manage program counter updates and register writes.

- **`processor.v`**  
  The main processor module that integrates the ALU, control unit, instruction memory, data memory, and register file. This module orchestrates the execution of instructions by coordinating data flow and control signals among all submodules, now including the execution of J-type instructions for improved control flow.

- **`skeleton.v`**  
  The top-level wrapper module that integrates all other modules. Set as the main entry point for simulation and synthesis in Quartus. It includes input for the 50 MHz clock and generates output clocks for other modules. This module now handles additional signals for jump and branch control, supporting J-type instructions as specified in the ISA.

- **`regfile.v`**  
  The register file with 32 general-purpose registers, with special handling for `$r0` (always zero), `$r31` (return address for `jal`), and `$r30` (status register for exceptions). The `regfile.v` now supports storing the return address in `$r31` for `jal` and updating `$rstatus` for `setx`.

### Special Registers

- **`$r0`** - Constantly holds zero.
- **`$r30`** - Status register (`$rstatus`), which indicates overflow conditions or exception flags.
- **`$r31`** - Return address register (`$ra`), used during jump-and-link (`jal`) instructions.

## Design Features

- **Modularity**: Each core functionality is encapsulated in its own module, promoting reusability and clarity.
- **Clock Management**: Custom clock dividers ensure that different parts of the processor operate at the correct frequencies derived from the primary 50 MHz clock.
- **Exception Handling**: Overflow detection and status updates in `$r30` enable handling exceptions during arithmetic operations. The `setx` and `bex` instructions enhance exception handling and control flow based on `$rstatus`.

## Project Setup
1. **Clock**: Ensure the design operates at a 50 MHz clock, with clock dividers as needed.
2. **Reset Behavior**: All registers should reset to zero, and the PC starts at address 0.
3. **Submission**: Include all Verilog files in a `.zip` file along with this README.

## Conclusion
This project successfully integrates a variety of instructions and control flows in a modular processor design. Checkpoint 5 adds the functionality for J-type instructions, completing the necessary control logic and datapath elements to support complex program execution with jumps and branches.
"""
