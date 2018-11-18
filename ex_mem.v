module ex_mem(
    input wire clk,
    input wire rst,

    input wire[`REGADDRBUS]  ex_wd,
    input wire               ex_wreg,
    input wire[`REGBUS]      ex_wdata,

    output reg[`REGADDRBUS]  mem_wd,
    output reg               mem_wreg,
    output reg[`REGBUS]      mem_wdate
);

    always @(posedge clk) begin
        if (rst == `RSTENABLE) begin
            mem_wd <= `NOPREGADDR;
            mem_wreg <= `WRITEDISABLE;
            mem_wdata <= `ZEROWORD;
        end else begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
        end
    end

endmodule
