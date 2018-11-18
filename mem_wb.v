module mem_wb(
    input wire clk,
    input wire rst,
    
    input wire[`REGADDRBUS] mem_wd,
    input wire mem_wreg,
    input wire[`REGBUS] mem_wdata,

    output reg[`REGADDRBUS] wb_wd,
    output reg wb_wreg,
    output reg[`REGBUS] wb_wdata
);

    always @ (posedge clk) begin
        if (rst == `RSTENABLE) begin
            wb_wd <= `NOPREGADDR;
            wb_wreg <= `WRITEBDISABLE;
            wb_wdata <= `ZEROWORD;
        end else begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
        end
    end

endmodule
