`include "macro.v"
module ex(
    input wire rst,

    input wire[`ALUOPBUS]  aluop_i,
    input wire[`ALUSELBUS] alusel_i,
    input wire[`REGBUS]  reg1_i,
    input wire[`REGBUS]  reg2_i,
    input wire[`REGADDRBUS]  wd_i,
    input wire  wreg_i,

    output reg[`REGADDRBUS]  wd_o,
    output reg  wreg_o,
    output reg[`REGBUS] wdata_o,
	 
	 input wire[`REGBUS] hi_i,
	 input wire[`REGBUS] lo_i,
	 output reg[`REGBUS] hi_o,
	 output reg[`REGBUS] lo_o,
	 output reg whilo_o,
	 
	 input wire[`REGBUS] wb_hi_i,
	 input wire[`REGBUS] wb_lo_i,
	 input wire wb_whilo_i,
	 input wire[`REGBUS] mem_hi_i,
	 input wire[`REGBUS] mem_lo_i,
	 input wire mem_whilo_i,
	 
	 input wire[`DOUBLEREGBUS] hilo_temp_i,
	 input wire[1:0] cnt_i,
	 output reg[`DOUBLEREGBUS] hilo_temp_o,
	 output reg[1:0] cnt_o,
	 
	 output reg  stallreq
);

    reg[`REGBUS] logicout;
	 reg[`REGBUS] shiftres;
	 reg[`REGBUS] moveres;
	 reg[`REGBUS] arithres;
	 reg[`DOUBLEREGBUS] mulres;
	 
	 reg[`REGBUS] HI;
	 reg[`REGBUS] LO;
	 
	 wire overflow;
	 wire reg1_eq_reg2;
	 wire reg1_lt_reg2;
	 wire[`REGBUS] reg2_i_mux;
	 wire[`REGBUS] reg1_i_not;
	 wire[`REGBUS] sumres;
	 wire[`REGBUS] opdata1_mult;
	 wire[`REGBUS] opdata2_mult;
	 wire[`DOUBLEREGBUS] hilo_temp;
	 reg[`DOUBLEREGBUS] hilo_temp_reg;
	 
	 reg  stallreq_for_madd_msub;
	 
	 
	 //HI LO
	 always @(*) begin
		if (rst == `RSTENABLE) begin
			{HI,LO} <= {`ZEROWORD, `ZEROWORD};
		end else if (mem_whilo_i == `WRITEENABLE) begin
			{HI,LO} <= {mem_hi_i,mem_lo_i};
		end else if (wb_whilo_i == `WRITEENABLE) begin
			{HI,LO} <= {wb_hi_i, wb_lo_i};
		end else begin
			{HI,LO} <= {hi_i,lo_i};
		end
	 end
	 
	 
	 //EXE_RES_MUL
	 assign opdata1_mult=(((aluop_i==`EXE_MUL_OP)||(aluop_i==`EXE_MULT_OP)||(aluop_i==`EXE_MADD_OP)||(aluop_i==`EXE_MSUB_OP))&&(reg1_i[31]==1'b1))?(~reg1_i + 1):reg1_i;
	 assign opdata2_mult=(((aluop_i==`EXE_MUL_OP)||(aluop_i==`EXE_MULT_OP)||(aluop_i==`EXE_MADD_OP)||(aluop_i==`EXE_MSUB_OP))&&(reg2_i[31]==1'b1))?(~reg2_i + 1):reg2_i;
	 assign hilo_temp = opdata1_mult * opdata2_mult;
	 
	 always @(*) begin
		if (rst == `RSTENABLE) begin
			mulres <= {`ZEROWORD, `ZEROWORD};
		end else if ((aluop_i==`EXE_MULT_OP)||(aluop_i==`EXE_MUL_OP)||(aluop_i==`EXE_MADD_OP)||(aluop_i==`EXE_MSUB_OP)) begin
			if (reg1_i[31]^reg2_i[31] == 1'b1) begin
				mulres <= ~hilo_temp + 1;
			end else begin
				mulres <= hilo_temp;
			end
		end else begin
			mulres <= hilo_temp;
		end
	 end
	 
	 
	 always @(*) begin
	   if (rst == `RSTENABLE) begin
			hilo_temp_o <= {`ZEROWORD, `ZEROWORD};
			cnt_o <= 2'b00;
			stallreq_for_madd_msub <= `NOSTOP;
		end else begin
			case (aluop_i)
				`EXE_MADD_OP, `EXE_MADDU_OP: begin
					if (cnt_i == 2'b00) begin
						hilo_temp_o <= mulres;
						cnt_o <= 2'b01;
						hilo_temp_reg <= {`ZEROWORD, `ZEROWORD};
						stallreq_for_madd_msub <= `STOP;
					end else if (cnt_i == 2'b01) begin
						hilo_temp_o <= {`ZEROWORD, `ZEROWORD};
						cnt_o <= 2'b10;
						hilo_temp_reg <= hilo_temp_i + {HI, LO};
						stallreq_for_madd_msub <= `NOSTOP;
					end
				end
					
				`EXE_MSUB_OP, `EXE_MSUBU_OP: begin
					if (cnt_i == 2'b00) begin
						hilo_temp_o <= ~mulres+1;
						cnt_o <= 2'b01;
						hilo_temp_reg <= {`ZEROWORD, `ZEROWORD};
						stallreq_for_madd_msub <= `STOP;
					end else if (cnt_i == 2'b01) begin
						hilo_temp_o <= {`ZEROWORD, `ZEROWORD};
						cnt_o <= 2'b10;
						hilo_temp_reg <= hilo_temp_i + {HI, LO};
						stallreq_for_madd_msub <= `NOSTOP;
					end
				end
				
				default: begin
					hilo_temp_o <= {`ZEROWORD, `ZEROWORD};
					cnt_o <= 2'b00;
					stallreq_for_madd_msub <= `NOSTOP;
				end
			endcase
		end
	end
	 
	 
	 //EXE_RES_ARITH
	 assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP)||(aluop_i == `EXE_SUBU_OP)||(aluop_i == `EXE_SLT_OP)) ? (~reg2_i)+1:reg2_i;
	 assign sumres = reg1_i + reg2_i_mux;
	 assign overflow = ((!reg1_i[31] && !reg2_i_mux[31]) && sumres[31]) || ((reg1_i[31] && reg1_i[31]) && (!sumres[31]));
	 assign reg1_lt_reg2 =(aluop_i==`EXE_SLT_OP)?
	 ( (reg1_i[31] && !reg2_i[31])||(!reg1_i[31]&&!reg2_i[31]&&sumres[31])||(reg1_i[31]&&reg2_i[31]&&sumres[31]))
	 :(reg1_i<reg2_i);
	 assign reg1_i_not = ~reg1_i;
	 
	 always @(*) begin
		 if (rst==`RSTENABLE) begin
			  arithres <= `ZEROWORD;
		 end else begin
			case (aluop_i)
				`EXE_SLT_OP, `EXE_SLTU_OP: begin
					arithres <= reg1_lt_reg2;
				end
				
				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_SUB_OP, `EXE_SUBU_OP: begin
					arithres <= sumres;
				end
				
				`EXE_CLZ_OP: begin
					arithres <= 	reg1_i[31] ? 0 : reg1_i[30] ? 1 : reg1_i[29] ? 2 :
										reg1_i[28] ? 3 : reg1_i[27] ? 4 : reg1_i[26] ? 5 :
										reg1_i[25] ? 6 : reg1_i[24] ? 7 : reg1_i[23] ? 8 : 
										reg1_i[22] ? 9 : reg1_i[21] ? 10 : reg1_i[20] ? 11 :
										reg1_i[19] ? 12 : reg1_i[18] ? 13 : reg1_i[17] ? 14 : 
										reg1_i[16] ? 15 : reg1_i[15] ? 16 : reg1_i[14] ? 17 : 
										reg1_i[13] ? 18 : reg1_i[12] ? 19 : reg1_i[11] ? 20 :
										reg1_i[10] ? 21 : reg1_i[9] ? 22 : reg1_i[8] ? 23 : 
										reg1_i[7] ? 24 : reg1_i[6] ? 25 : reg1_i[5] ? 26 : 
										reg1_i[4] ? 27 : reg1_i[3] ? 28 : reg1_i[2] ? 29 : 
										reg1_i[1] ? 30 : reg1_i[0] ? 31 : 32 ;
				end
				
				`EXE_CLO_OP: begin
					arithres <= (reg1_i_not[31] ? 0 : reg1_i_not[30] ? 1 : reg1_i_not[29] ? 2 :
									 reg1_i_not[28] ? 3 : reg1_i_not[27] ? 4 : reg1_i_not[26] ? 5 :
									 reg1_i_not[25] ? 6 : reg1_i_not[24] ? 7 : reg1_i_not[23] ? 8 : 
									 reg1_i_not[22] ? 9 : reg1_i_not[21] ? 10 : reg1_i_not[20] ? 11 :
									 reg1_i_not[19] ? 12 : reg1_i_not[18] ? 13 : reg1_i_not[17] ? 14 : 
									 reg1_i_not[16] ? 15 : reg1_i_not[15] ? 16 : reg1_i_not[14] ? 17 : 
									 reg1_i_not[13] ? 18 : reg1_i_not[12] ? 19 : reg1_i_not[11] ? 20 :
									 reg1_i_not[10] ? 21 : reg1_i_not[9] ? 22 : reg1_i_not[8] ? 23 : 
									 reg1_i_not[7] ? 24 : reg1_i_not[6] ? 25 : reg1_i_not[5] ? 26 : 
									 reg1_i_not[4] ? 27 : reg1_i_not[3] ? 28 : reg1_i_not[2] ? 29 : 
									 reg1_i_not[1] ? 30 : reg1_i_not[0] ? 31 : 32) ;
				end
				
				`EXE_MUL_OP: begin
					arithres <= mulres[31:0];
				end
				
				default: begin
					arithres <= `ZEROWORD;
				end
			endcase
		end
	end

	 //EXE_RES_LOGIC
    always @(*) begin
        if (rst == `RSTENABLE) begin
            logicout <= `ZEROWORD;
        end else begin 
            case (aluop_i)
                `EXE_OR_OP: begin 
                    logicout <= reg1_i | reg2_i;
                end
					 
					 `EXE_AND_OP: begin
						  logicout <= reg1_i & reg2_i;
					 end
					 
					 `EXE_NOR_OP: begin
						  logicout <= ~(reg1_i | reg2_i);
					 end
					 
					 `EXE_XOR_OP: begin
						  logicout <= reg1_i ^ reg2_i;
					 end
					 
                default: begin 
                    logicout <= `ZEROWORD;
                end
					 
            endcase 
        end
    end
	 
	 
	 //EXE_RES_SHIFT
	 always @(*) begin
		if (rst == `RSTENABLE) begin
			shiftres <= `ZEROWORD;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP: begin
					shiftres <= reg2_i << reg1_i[4:0];
				end
				
				`EXE_SRL_OP: begin
					shiftres <= reg2_i >> reg1_i[4:0];
				end
				
				`EXE_SRA_OP: begin
					shiftres <= $signed(reg2_i) >>> reg1_i[4:0];
				end
				
				default: begin
					shiftres <= `ZEROWORD;
				end
			endcase
		end
	end
	
	
	 //EXE_RES_MOVE
	 always @(*) begin
		 if (rst == `RSTENABLE) begin
			  moveres <= `ZEROWORD;
		 end else begin
			  moveres <= `ZEROWORD;
			  case (aluop_i)
				  `EXE_MFHI_OP: begin
					  moveres <= HI;
				  end
				
				  `EXE_MFLO_OP: begin
					  moveres <= LO;
				  end
				
				  `EXE_MOVZ_OP: begin
					  moveres <= reg1_i;
				  end
				
				  `EXE_MOVN_OP: begin
					  moveres <= reg1_i;
				  end
				
				  default: begin
				  end
			  endcase
			  end
	 end
	 

	 //wdata_o
    always @(*) begin 
        wd_o <= wd_i;
		  if (((aluop_i == `EXE_ADD_OP)||(aluop_i == `EXE_SUB_OP))&&(overflow)  ) begin
				wreg_o <= `WRITEDISABLE;
		  end else begin
				wreg_o <= wreg_i;
		  end
		  
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
				
				`EXE_RES_SHIFT: begin
					 wdata_o <= shiftres;
				end
				
				`EXE_RES_MOVE: begin
					wdata_o <= moveres;
				end
				
				`EXE_RES_ARITH: begin
					wdata_o <= arithres;
				end
				
            default: begin
                wdata_o <= `ZEROWORD;
            end
        endcase
    end 
	 
	 
	 //whilo_o, hi_o, lo_i
	 always @(*) begin
		if (rst == `RSTENABLE) begin
			whilo_o <= `WRITEDISABLE;
			hi_o <= `ZEROWORD;
			lo_o <= `ZEROWORD;
		end else if ((aluop_i == `EXE_MSUB_OP) || (aluop_i == `EXE_MSUBU_OP) || (aluop_i == `EXE_MADD_OP) || (aluop_i == `EXE_MADDU_OP)) begin
			whilo_o <= `WRITEENABLE;
			{hi_o, lo_o} <= hilo_temp_reg;
		end else if ((aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MULTU_OP)) begin
			whilo_o <= `WRITEENABLE;
			{hi_o, lo_o} <= mulres;
		end else if (aluop_i == `EXE_MTHI_OP) begin
			whilo_o <= `WRITEENABLE;
			hi_o <= reg1_i;
			lo_o <= LO;
		end else if (aluop_i == `EXE_MTLO_OP) begin
			whilo_o <= `WRITEENABLE;
			hi_o <= HI;
			lo_o <= reg1_i;
		end else begin
			whilo_o <= `WRITEDISABLE;
			hi_o <= `ZEROWORD;
			lo_o <= `ZEROWORD;
		end
	end
	
	
	//stall
	always @(*) begin
		stallreq = stallreq_for_madd_msub;
	end

endmodule
