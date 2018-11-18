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
    output reg[`REGBUS] wdate_o,
);

    reg[`REGBUS] logicout;

    always @(*) begin
        if (rst == `RSTENABLE) begin
            logicout <= `ZEROWORD;
        end else begin 
            case (aluop_i)
                `EXE_OR_OP: begin 
                    logicout <= reg1_i | reg2_i;
                end
                default: begin 
                    logicout <= `ZEROWORD;
                end
            endcase 
        end
    end 

    always @(*) begin 
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
            default: begin
                wdata_o <= `ZEROWORD;
            end
        endcase
    end 

endmodule
