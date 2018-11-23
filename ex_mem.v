`include "macro.v"
module ex_mem(
    input wire clk,
    input wire rst,

    input wire[`REGADDRBUS]  ex_wd,
    input wire               ex_wreg,
    input wire[`REGBUS]      ex_wdata,
	 
	 input wire[`REGBUS]		  ex_hi,
	 input wire[`REGBUS]	     ex_lo,
	 input wire					  ex_whilo,

    input wire[5:0]          stall,

    output reg[`REGADDRBUS]  mem_wd,
    output reg               mem_wreg,
    output reg[`REGBUS]      mem_wdata,
	 output reg[`REGBUS]		  mem_hi,
	 output reg[`REGBUS]		  mem_lo,
	 output reg[`REGBUS]		  mem_whilo
);

    always @(posedge clk) begin
        if (rst == `RSTENABLE) begin
            mem_wd <= `NOPREGADDR;
            mem_wreg <= `WRITEDISABLE;
            mem_wdata <= `ZEROWORD;
			mem_hi <= `ZEROWORD;
			mem_lo <= `ZEROWORD;
			mem_whilo <= `WRITEDISABLE;
        end else if (stall[3] == `STOP && stall[4] == `NOSTOP) begin
            mem_wd <= `NOPREGADDR;
            mem_wreg <= `WRITEDISABLE;
            mem_wdata <= `ZEROWORD;
			mem_hi <= `ZEROWORD;
			mem_lo <= `ZEROWORD;
			mem_whilo <= `WRITEDISABLE;
        end else if (stall[3] == `NOSTOP) begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
				mem_hi <= ex_hi;
				mem_lo <= ex_lo;
				mem_whilo <= ex_whilo;
        end
    end

endmodule
