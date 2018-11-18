module le(
    input wire clk,
    input wire rst,
    
    input wire we,
    input wire[`REGADDRBUS] waddr,
    input wire[`REGDATABUS] wdata,

    input wire re1,
    input wire[`REGADDRBUS] raddr1,
    input wire[`REGDATABUS] rdata1,

    input wire re2,
    input wire[`REGADDRBUS] raddr2,
    input wire[`REGDATABUS] rdata2
)

reg[]
