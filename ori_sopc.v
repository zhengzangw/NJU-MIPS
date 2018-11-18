`include "macro.v"

module ori_sopc(
    input wire clk,
    input wire rst
);

    wire[`INSTADDRBUS] inst_addr;
    wire[`INSTBUS] inst;
    wire rom_ce;

    NJU_MIPS mips0(
        .clk(clk), .rst(rst),
        .rom_addr_o(inst_addr), .rom_data_i(inst),
        .rom_ce(rom_ce)
    );

    inst_rom inst_rom0(
        .ce(rom_ce),
        .addr(inst_addr), .inst(inst)
    );

endmodule
