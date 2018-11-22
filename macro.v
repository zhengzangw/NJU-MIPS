//***** COMMON MICRO *****
`define   RSTENABLE      1'b1
`define   RSTDISABLE     1'b0
`define   ZEROWORD       32'h00000000
`define   WRITEENABLE    1'b1
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
`define   INSTBUS    31:0
`define   INSTMEMNUM     640
`define   INSTMEMNUMLOG2 17


//***** REGFILE *****
`define   REGADDRBUS     4:0
`define   REGBUS         31:0
`define   REGWIDTH       32
`define   DOUBLEREGWIDTH 64
`define   DOUBLEREGBUS   63:0
`define   REGNUM         32
`define   REGNUMLOG2     5
`define   NOPREGADDR     5'b00000

//***** INSTR *****
`define   EXE_ORI        6'b001101
`define   EXE_NOP        6'b000000
`define   EXE_AND        6'b100100
`define   EXE_OR         6'b100101
`define   EXE_XOR			 6'b100110
`define   EXE_NOR  		 6'b100111
`define   EXE_ANDI		 6'b001100
`define   EXE_ORI			 6'b001101
`define   EXE_XORI		 6'b001110
`define   EXE_LUI			 6'b001111

`define   EXE_SLL			 6'b000000
`define	 EXE_SLLV		 6'b000100
`define	 EXE_SRL			 6'b000010
`define	 EXE_SRLV	 	 6'b000110
`define	 EXE_SRA			 6'b000011
`define	 EXE_SRAV		 6'b000111

`define 	 EXE_SYNC	    6'b001111
`define	 EXE_PREF		 6'b110011

`define	 EXE_SPECIAL	 6'b000000
`define	 EXE_SPECIAL2   6'b011100
`define	 EXE_REGIMM		 6'b000001

`define   EXE_MOVZ		 6'b001010
`define   EXE_MOVN		 6'b001011
`define   EXE_MFHI		 6'b010000
`define   EXE_MTHI		 6'b010001
`define	 EXE_MFLO		 6'b010010
`define   EXE_MTLO		 6'b010011

`define   EXE_SLT    	 6'b101010
`define   EXE_SLTU		 6'b101011
`define   EXE_SLTI	    6'b001010
`define   EXE_SLTIU	    6'b001011
`define	 EXE_ADD			 6'b100000
`define	 EXE_ADDU		 6'b100001
`define	 EXE_SUB			 6'b100010
`define	 EXE_SUBU		 6'b100011
`define	 EXE_ADDI		 6'b001000
`define	 EXE_ADDIU		 6'b001001
`define	 EXE_CLZ			 6'b100000
`define	 EXE_CLO			 6'b100001
`define	 EXE_MUL			 6'b000010

`define	 EXE_MULT		 6'b011000
`define	 EXE_MULTU		 6'b011001



//***** ALUOP ******
`define 	 EXE_AND_OP   	 8'b00100100
`define 	 EXE_OR_OP   	 8'b00100101
`define 	 EXE_XOR_OP  	 8'b00100110
`define 	 EXE_NOR_OP  	 8'b00100111
`define 	 EXE_ANDI_OP  	 8'b01011001
`define 	 EXE_ORI_OP  	 8'b01011010
`define 	 EXE_XORI_OP  	 8'b01011011
`define 	 EXE_LUI_OP  	 8'b01011100   

`define 	 EXE_SLL_OP  	 8'b01111100
`define 	 EXE_SLLV_OP  	 8'b00000100
`define 	 EXE_SRL_OP  	 8'b00000010
`define   EXE_SRLV_OP  	 8'b00000110
`define   EXE_SRA_OP  	 8'b00000011
`define   EXE_SRAV_OP  	 8'b00000111

`define   EXE_MOVZ_OP  	 8'b00001010
`define   EXE_MOVN_OP  	 8'b00001011
`define   EXE_MFHI_OP	 8'b00010000
`define   EXE_MTHI_OP	 8'b00010001
`define   EXE_MFLO_OP	 8'b00010010
`define   EXE_MTLO_OP	 8'b00010011

`define   EXE_SLT_OP     8'b01101010
`define   EXE_SLTU_OP	 8'b01101011
`define   EXE_ADD_OP		 8'b01100000
`define   EXE_ADDU_OP	 8'b01100001
`define 	 EXE_SUB_OP		 8'b01100010
`define   EXE_SUBU_OP	 8'b01100011
`define   EXE_CLZ_OP		 8'b00100000
`define	 EXE_CLO_OP		 8'b00100001
`define	 EXE_MUL_OP		 8'b01000010

`define	 EXE_MULT_OP	 8'b01011000
`define	 EXE_MULTU_OP	 8'b01011001

`define   EXE_NOP_OP     8'b00000000


//***** ALUSEL ******
`define   EXE_RES_LOGIC  3'b001
`define   EXE_RES_SHIFT  3'b010 
`define   EXE_RES_MOVE	 3'b011
`define	 EXE_RES_ARITH	 3'b100
`define   EXE_RES_NOP    3'b000


//***** FILE *****
`ifdef MAC
`define   INST_ROM_FILE  "inst_rom.data"
`else
`define   INST_ROM_FILE  "C:/Users/Fermat/workplace/exp12/inst_rom.data"
`endif
