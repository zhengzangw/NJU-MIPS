`include "macro.v"

module id(
    input wire rst,
    input wire[`INSTADDRBUS] pc_i,
    input wire[`INSTBUS] inst_i,

    input wire[`REGBUS] reg1_data_i,
    input wire[`REGBUS] reg2_data_i,

    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`REGADDRBUS] reg1_addr_o,
    output reg[`REGADDRBUS] reg2_addr_o,

    output reg[`ALUOPBUS] aluop_o,
    output reg[`ALUSELBUS] alusel_o,
    output reg[`REGBUS] reg1_o,
    output reg[`REGBUS] reg2_o,
    output reg[`REGADDRBUS] wd_o,
    output reg wreg_o
);

    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2= inst_i[10:6];
    wire[5:0] op3= inst_i[5:0];
    wire[4:0] op4= inst_i[20:16];
    reg[`REGBUS] imm;
    reg instvalid;

    always @(*) begin
        if (rst==`RSTENABLE) begin 
            aluop_o <= `EXE_NOP_OP;
            alusel_o<= `EXE_RES_NOP;
            wd_o    <= `NOPREGADDR;
            wreg_o <= `WRITEDISABLE;
            instvalid <= `INSTVALID;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= `NOPREGADDR;
            reg2_addr_o <= `NOPREGADDR;
            imm <= 32'h0;
        end else begin 
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o    <= inst_i[15:11];
            wreg_o <= `WRITEDISABLE;
            instvalid <= `INSTINVALID;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= inst_i[25:21];
            reg2_addr_o <= inst_i[20:16];
            imm <= `ZEROWORD;

            case (op)
                `EXE_ORI: begin
                    wreg_o <= `WRITEENALBE;
                    aluop_o<= `EXE_OR_OP;
                    alusel_o<=`EXE_RES_LOGIC;
                    reg1_read_o <= `READENABLE;
                    reg2_read_o <= `READDISABLE;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                    instvalid <= `INSTVALID;
                end
                default: begin
                end
            endcase
        end
    end


    always @(*) begin
        if (rst==`RSTENABLE) begin
            reg1_o <= `ZEROWORD;
        end else if (reg1_read_o == 1'b1) begin
            reg1_o <= reg1_data_i;
        end else if (reg1_read_o == 1'b0) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= `ZEROWORD;
        end 
    end


    always @(*) begin
        if (rst==`RSTENABLE) begin
            reg2_o <= `ZEROWORD;
        end else if (reg2_read_o == 1'b1) begin
            reg2_o <= reg2_data_i;
        end else if (reg2_read_o == 1'b0) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= `ZEROWORD;
        end 
    end

endmodule
