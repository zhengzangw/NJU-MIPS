# Introduction
NJU_MIPS is course project for Experimemts in Digital Logit Circuits. It is a MIPS32 system.

# About NJU_MIPS
Big endian, CPU frequency 12.5MHz, Memory 128KB, instruction ROM 512B.

# Function
Logic, arithmetic, load, store, jmp, branch, move instructions are all implemented except for ll and sc instructions.

# Simulation
Files relating simulation is in DEBUG. **NOTE THAT** in module inst\_rom.v, initial file was an absolute path which you need to change.
### Modelsim Altera
  To simulate with Modelsim Altera, wave.do is provided.
### Icuras Verilog with scansion
  For mac user, this lite tools is introduced. However, array variables cannot be seen.

# GNU tool chains
In file GNUmipschain, some tools are given for mips compilation in Linux.
