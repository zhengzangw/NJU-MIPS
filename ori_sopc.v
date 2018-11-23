`include "macro.v"
module ori_sopc(
    input wire clk,
    input wire rst,
	 //DEBUG
	 output wire[9:0] debug
);

    wire[`INSTADDRBUS] inst_addr;
    wire[`INSTBUS] inst;
    wire rom_ce;

    NJU_MIPS mips0(
        .clk(clk), .rst(rst),
        .rom_addr_o(inst_addr), .rom_data_i(inst),
        .rom_ce_o(rom_ce),
	 //DEBUG
		  .debug(debug)
    );

    inst_rom inst_rom0(
        .ce(rom_ce),
        .addr(inst_addr), .inst(inst)
    );

endmodule
