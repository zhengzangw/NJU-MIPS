//***** COMMON MICRO *****
`define   RSTENABLE      1'b1
`define   RSTDISABLE     1'b0
`define   ZEROWORD       32'h00000000
`define   WRITEENALBE    1'b1
`define   WRITEDISABLE   1'b0
`define   READENABLE     1'b1
`define   READDISABLE    1'b0
`define   CHIPDISABLE    1'b0
`define   CHIPENABLE     1'b1
`define   TRUE_V         1'b1
`define   FALSE_V        1'b0
`define   INSTINVALID    1'b1
`define   INSTVALID      1'b0
`define   ALUOPBUS       7:0
`define   ALUSELBUS      2:0


//***** PC *****
`define   INSTADDRBUS    31:0
`define   INSTDATABUS    31:0
`define   INSTMEMNUM     131071
`define   INSTMEMNUMLOG2 17


//***** REGFILE *****
`define   REGADDRBUS     4:0
`define   REGDATABUS     31:0
`define   REGWIDTH       32
`define   DOUBLEREGWIDTH 64
`define   DOUBLEREGBUS   63:0
`define   REGNUM         32
`define   REGNUMLOG2     5
`define   NOPREGADDR     5'b00000

//***** INSTR *****
`define   EXE_ORI        6'b001101
`define   EXE_NOP        6'b000000

`define   EXE_OR_OP      8'b00100101
`define   EXE_NOP_OP     8'b00000000

`define   EXE_RES_LOGIC  3'b001 
`define   EXE_RES_NOP    3'b000
