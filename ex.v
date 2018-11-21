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
	 input wire mem_whilo_i
);

    reg[`REGBUS] logicout;
	 reg[`REGBUS] shiftres;
	 reg[`REGBUS] moveres;
	 
	 reg[`REGBUS] HI;
	 reg[`REGBUS] LO;
	 
	 
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
        wreg_o <= wreg_i;
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

endmodule
