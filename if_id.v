`include "macro.v"
module if_id(
    input wire  clk,
    input wire  rst,
    input wire[`INSTADDRBUS] if_pc,
    input wire[`INSTBUS] if_inst,
    output reg[`INSTADDRBUS] id_pc,
    output reg[`INSTBUS] id_inst
);

    always @(posedge clk) begin
        if (rst==`RSTENABLE) begin
            id_pc <= `ZEROWORD;
            id_inst <= `ZEROWORD;
        end else begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end

endmodule
