`include "macro.v"

module id(
    input wire rst,
    input wire[`INSTADDRBUS] pc_i,
    input wire[`INSTBUS] inst_i,

    input wire[`REGBUS] reg1_data_i,
    input wire[`REGBUS] reg2_data_i,

    // Data from Execution
    input wire ex_wreg_i,
    input wire[`REGBUS] ex_wdata_i,
    input wire[`REGADDRBUS] ex_wd_i,
    // Data from Writeback
    input wire mem_wreg_i,
    input wire[`REGBUS] mem_wdata_i,
    input wire[`REGADDRBUS] mem_wd_i,

    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`REGADDRBUS] reg1_addr_o,
    output reg[`REGADDRBUS] reg2_addr_o,

    output reg[`ALUOPBUS] aluop_o,
    output reg[`ALUSELBUS] alusel_o,
    output reg[`REGBUS] reg1_o,
    output reg[`REGBUS] reg2_o,
    output reg[`REGADDRBUS] wd_o,
    output reg wreg_o,
	 
	 output wire stallreq
);

    wire[5:0] op = inst_i[31:26]; //Instruction Code
    wire[4:0] sa= inst_i[10:6];   //sa
    wire[5:0] func = inst_i[5:0]; //Function Code
    wire[4:0] rt = inst_i[20:16]; //rt
	 wire[4:0] rs = inst_i[25:21]; //rs
	 wire[4:0] rd = inst_i[15:11]; //rd
    reg[`REGBUS] imm;
    reg instvalid;
	 
	 assign stallreq = `NOSTOP;

    always @(*) begin
        if (rst==`RSTENABLE) begin 
            aluop_o <= `EXE_NOP_OP;
            alusel_o<= `EXE_RES_NOP;
            wd_o    <= `NOPREGADDR;
            wreg_o <= `WRITEDISABLE;
            instvalid <= `INSTVALID;
            reg1_read_o <= `READDISABLE;
            reg2_read_o <= `READDISABLE;
            reg1_addr_o <= `NOPREGADDR;
            reg2_addr_o <= `NOPREGADDR;
            imm <= `ZEROWORD;
        end else begin 
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o    <= rd;
            wreg_o <= `WRITEDISABLE;
            instvalid <= `INSTINVALID;
            reg1_read_o <= `READDISABLE;
            reg2_read_o <= `READDISABLE;
            reg1_addr_o <= rs;
            reg2_addr_o <= rt;
            imm <= `ZEROWORD;

            case (op)
					`EXE_SPECIAL: begin
//						case (sa)
//							`NOPREGADDR: begin
								case (func)
								   //LOGIC
									`EXE_OR: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_OR_OP;
										alusel_o <= `EXE_RES_LOGIC;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_AND: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_AND_OP;
										alusel_o <= `EXE_RES_LOGIC;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_XOR: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_XOR_OP;
										alusel_o <= `EXE_RES_LOGIC;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_NOR: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_NOR_OP;
										alusel_o <= `EXE_RES_LOGIC;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									//SHIFT
									`EXE_SLLV: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_SLL_OP;
										alusel_o <= `EXE_RES_SHIFT;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_SRLV: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_SRL_OP;
										alusel_o <= `EXE_RES_SHIFT;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_SRAV: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_SRAV_OP;
										alusel_o <= `EXE_RES_SHIFT;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_SYNC: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_NOP_OP;
										alusel_o <= `EXE_RES_NOP;
										reg1_read_o <= `READDISABLE;
										reg2_read_o <= `READDISABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_SLL: begin
										if (rs==`NOPREGADDR) begin
											wreg_o <= `WRITEENABLE;
											aluop_o <= `EXE_SLL_OP;
											alusel_o <= `EXE_RES_SHIFT;
											reg1_read_o <= `READDISABLE;
											reg2_read_o <= `READENABLE;
											imm[4:0] <= sa;
											instvalid <= `INSTVALID;
										end
									end
									
									`EXE_SRL: begin
										if (rs==`NOPREGADDR) begin
											wreg_o <= `WRITEENABLE;
											aluop_o <= `EXE_SRL_OP;
											alusel_o <= `EXE_RES_SHIFT;
											reg1_read_o <= `READDISABLE;
											reg2_read_o <= `READENABLE;
											imm[4:0] <= sa;
											instvalid <= `INSTVALID;
										end
									end
									
									`EXE_SRA: begin
										if (rs==`NOPREGADDR) begin
											wreg_o <= `WRITEENABLE;
											aluop_o <= `EXE_SRA_OP;
											alusel_o <= `EXE_RES_SHIFT;
											reg1_read_o <= `READDISABLE;
											reg2_read_o <= `READENABLE;
											imm[4:0] <= sa;
											instvalid <= `INSTVALID;
										end
									end
									//MOVE
									`EXE_MFHI: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_MFHI_OP;
										alusel_o <= `EXE_RES_MOVE;
										reg1_read_o <= `READDISABLE;
										reg2_read_o <= `READDISABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_MFLO: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_MFLO_OP;
										alusel_o <= `EXE_RES_MOVE;
										reg1_read_o <= `READDISABLE;
										reg2_read_o <= `READDISABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_MTHI: begin
										wreg_o <= `WRITEDISABLE;
										aluop_o <= `EXE_MTHI_OP;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READDISABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_MTLO: begin
										wreg_o <= `WRITEDISABLE;
										aluop_o <= `EXE_MTLO_OP;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READDISABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_MOVN: begin
										aluop_o <= `EXE_MOVN_OP;
										alusel_o <= `EXE_RES_MOVE;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
										if (reg2_o != `ZEROWORD) begin
											wreg_o <= `WRITEENABLE;
										end else begin
											wreg_o <= `WRITEDISABLE;
										end
									end
									
									`EXE_MOVZ: begin
										aluop_o <= `EXE_MOVZ_OP;
										alusel_o <= `EXE_RES_MOVE;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
										if (reg2_o == `ZEROWORD) begin
											wreg_o <= `WRITEENABLE;
										end else begin
											wreg_o <= `WRITEDISABLE;
										end
									end
									//ARITHMATIC
									`EXE_SLT: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_SLT_OP;
										alusel_o <= `EXE_RES_ARITH;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_SLTU: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_SLTU_OP;
										alusel_o <= `EXE_RES_ARITH;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_ADD: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_ADD_OP;
										alusel_o <= `EXE_RES_ARITH;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_ADDU: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_ADDU_OP;
										alusel_o <= `EXE_RES_ARITH;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_SUB: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_SUB_OP;
										alusel_o <= `EXE_RES_ARITH;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_SUBU: begin
										wreg_o <= `WRITEENABLE;
										aluop_o <= `EXE_SUBU_OP;
										alusel_o <= `EXE_RES_ARITH;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_MULT: begin
										wreg_o <= `WRITEDISABLE;
										aluop_o <= `EXE_MULT_OP;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									`EXE_MULTU: begin
										wreg_o <= `WRITEDISABLE;
										aluop_o <= `EXE_MULTU_OP;
										reg1_read_o <= `READENABLE;
										reg2_read_o <= `READENABLE;
										instvalid <= `INSTVALID;
									end
									
									default: begin
									end
									
								endcase
//							end
							
//							default: begin
//							end
							
//						endcase
					end
					//LOGIC
               `EXE_ORI: begin
						  wreg_o <= `WRITEENABLE;
						  aluop_o<= `EXE_OR_OP;
						  alusel_o<=`EXE_RES_LOGIC;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {16'h0, inst_i[15:0]};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_ANDI: begin
					 	  wreg_o <= `WRITEENABLE;
						  aluop_o<= `EXE_AND_OP;
						  alusel_o<=`EXE_RES_LOGIC;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {16'h0, inst_i[15:0]};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_XORI: begin
					 	  wreg_o <= `WRITEENABLE;
						  aluop_o<= `EXE_XOR_OP;
						  alusel_o<=`EXE_RES_LOGIC;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {16'h0, inst_i[15:0]};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_LUI: begin
					 	  wreg_o <= `WRITEENABLE;
						  aluop_o<= `EXE_OR_OP;
						  alusel_o<=`EXE_RES_LOGIC;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {inst_i[15:0], 16'h0};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_PREF: begin
					 	  wreg_o <= `WRITEENABLE;
						  aluop_o<= `EXE_NOP_OP;
						  alusel_o<=`EXE_RES_NOP;
						  reg1_read_o <= `READDISABLE;
						  reg2_read_o <= `READDISABLE;
						  instvalid <= `INSTVALID;
					 end
					 //ARITHMATIC
					 `EXE_SLTI: begin
					     wreg_o <= `WRITEENABLE;
						  aluop_o <= `EXE_SLT_OP;
						  alusel_o <= `EXE_RES_ARITH;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {{16{inst_i[15]}},inst_i[15:0]};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_SLTIU: begin
					     wreg_o <= `WRITEENABLE;
						  aluop_o <= `EXE_SLTU_OP;
						  alusel_o <= `EXE_RES_ARITH;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {{16{inst_i[15]}},inst_i[15:0]};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_ADDI: begin
						  wreg_o <= `WRITEENABLE;
						  aluop_o <= `EXE_ADD_OP;
						  alusel_o <= `EXE_RES_ARITH;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {{16{inst_i[15]}},inst_i[15:0]};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_ADDIU: begin
					     wreg_o <= `WRITEENABLE;
						  aluop_o <= `EXE_ADDU_OP;
						  alusel_o <= `EXE_RES_ARITH;
						  reg1_read_o <= `READENABLE;
						  reg2_read_o <= `READDISABLE;
						  imm <= {{16{inst_i[15]}},inst_i[15:0]};
						  wd_o <= rt;
						  instvalid <= `INSTVALID;
					 end
					 
					 `EXE_SPECIAL2: begin
							case(func)
								`EXE_CLZ: begin
									wreg_o <= `WRITEENABLE;
									aluop_o <= `EXE_CLZ_OP;
									alusel_o <= `EXE_RES_ARITH;
									reg1_read_o <= `READENABLE;
									reg2_read_o <= `READDISABLE;
									instvalid <= `INSTVALID;
								end
								
								`EXE_CLO: begin
									wreg_o <= `WRITEENABLE;
									aluop_o <= `EXE_CLO_OP;
									alusel_o <= `EXE_RES_ARITH;
									reg1_read_o <= `READENABLE;
									reg2_read_o <= `READDISABLE;
									instvalid <= `INSTVALID;
								end
								
								`EXE_MUL: begin
									wreg_o <= `WRITEENABLE;
									aluop_o <= `EXE_MUL_OP;
									alusel_o <= `EXE_RES_ARITH;
									reg1_read_o <= `READENABLE;
									reg2_read_o <= `READENABLE;
									instvalid <= `INSTVALID;
								end
								
								`EXE_MADD: begin
									wreg_o <= `WRITEDISABLE;
									aluop_o <= `EXE_MADD_OP;
									//alusel_o <= `EXE_RES_MUL;
									reg1_read_o <= `READENABLE;
									reg2_read_o <= `READENABLE;
									instvalid <= `INSTVALID;
								end
								
								`EXE_MADDU: begin
									wreg_o <= `WRITEDISABLE;
									aluop_o <= `EXE_MADDU_OP;
									//alusel_o <= `EXE_RES_MUL;
									reg1_read_o <= `READENABLE;
									reg2_read_o <= `READENABLE;
									instvalid <= `INSTVALID;
								end
								
								`EXE_MSUB: begin
									wreg_o <= `WRITEDISABLE;
									aluop_o <= `EXE_MSUB_OP;
									//alusel_o <= `EXE_RES_MUL;
									reg1_read_o <= `READENABLE;
									reg2_read_o <= `READENABLE;
									instvalid <= `INSTVALID;
								end
								
								`EXE_MSUBU: begin
									wreg_o <= `WRITEDISABLE;
									aluop_o <= `EXE_MSUBU_OP;
									//alusel_o <= `EXE_RES_MUL;
									reg1_read_o <= `READENABLE;
									reg2_read_o <= `READENABLE;
									instvalid <= `INSTVALID;
								end
								
								default: begin
								end
							endcase
					 end
					 
               default: begin
               end
					 
            endcase

        end
    end


    always @(*) begin
        if (rst==`RSTENABLE) begin
            reg1_o <= `ZEROWORD;
        // Data Hazzard
        end else if ((reg1_read_o==`READENABLE)&&(ex_wreg_i==`WRITEENABLE)&&(ex_wd_i==reg1_addr_o)) begin
            reg1_o <= ex_wdata_i;
        end else if ((reg1_read_o==`READENABLE)&&(mem_wreg_i==`WRITEENABLE)&&(mem_wd_i==reg1_addr_o)) begin
            reg1_o <= mem_wdata_i;
        end else if (reg1_read_o == `READENABLE) begin
            reg1_o <= reg1_data_i;
        end else if (reg1_read_o == `READDISABLE) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= `ZEROWORD;
        end 
    end


    always @(*) begin
        if (rst==`RSTENABLE) begin
            reg2_o <= `ZEROWORD;
        // Data Hazzard
        end else if ((reg2_read_o==`READENABLE)&&(ex_wreg_i==`WRITEENABLE)&&(ex_wd_i==reg2_addr_o)) begin
            reg2_o <= ex_wdata_i;
        end else if ((reg2_read_o==`READENABLE)&&(mem_wreg_i==`WRITEENABLE)&&(mem_wd_i==reg2_addr_o)) begin
            reg2_o <= mem_wdata_i;
        end else if (reg2_read_o == `READENABLE) begin
            reg2_o <= reg2_data_i;
        end else if (reg2_read_o == `READDISABLE) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= `ZEROWORD;
        end 
    end

endmodule
