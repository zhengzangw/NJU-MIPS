`include "macro.v"
module inst_rom(
    input wire ce,
    input wire[`INSTADDRBUS] addr,
    output reg[`INSTBUS] inst
);

    reg [`INSTBUS] inst_mem[0:`INSTMEMNUM-1];

    initial $readmemh(`INST_ROM_FILE, inst_mem);

    always @(*) begin
        if (ce == `CHIPDISABLE) begin
            inst <= `ZEROWORD;
        end else begin
            inst <= inst_mem[addr[`INSTMEMNUMLOG2+1:2]];
        end
    end

endmodule
