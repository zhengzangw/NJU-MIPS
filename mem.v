`include "macro.v"
module mem(
    input wire rst,

    input wire[`REGADDRBUS]  wd_i,
    input wire  wreg_i,
    input wire[`REGBUS]  wdata_i,

    output reg[`REGADDRBUS]  wd_o,
    output reg  wreg_o,
    output reg[`REGBUS]  wdata_o
);

    always @(*) begin
        if (rst == `RSTENABLE) begin
            wd_o <= `NOPREGADDR;
            wreg_o <= `WRITEDISABLE;
            wdata_o <= `ZEROWORD;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
        end
    end

endmodule
