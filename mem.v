`include "macro.v"
module mem(
    input wire rst,

    input wire[`REGADDRBUS]  wd_i,
    input wire  wreg_i,
    input wire[`REGBUS]  wdata_i,
	 
	 input wire[`REGBUS]  hi_i,
	 input wire[`REGBUS]  lo_i,
	 input wire				 whilo_i,

    output reg[`REGADDRBUS]  wd_o,
    output reg  wreg_o,
    output reg[`REGBUS]  wdata_o,
	 
	 output reg[`REGBUS]  hi_o,
	 output reg[`REGBUS]  lo_o,
	 output reg				 whilo_o
);

    always @(*) begin
        if (rst == `RSTENABLE) begin
            wd_o <= `NOPREGADDR;
            wreg_o <= `WRITEDISABLE;
            wdata_o <= `ZEROWORD;
				hi_o <= `ZEROWORD;
				lo_o <= `ZEROWORD;
				whilo_o <= `WRITEDISABLE;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
				hi_o <= hi_i;
				lo_o <= lo_i;
				whilo_o <= whilo_i;
        end
    end

endmodule
