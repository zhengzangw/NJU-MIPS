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
	 wire mem_we_i;
    wire[`REGBUS] mem_addr_i;
    wire[`REGBUS] mem_data_i;
    wire[`REGBUS] mem_data_o;
    wire[3:0] mem_sel_i;  
    wire mem_ce_i;  
	 
	 wire clk_12M;
	 clkgen #(12500000)clk12M(
		  .clkin(clk),
		  .rst(1'b0),
		  .clken(1'b1),
		  .clkout(clk_12M)
    );

    NJU_MIPS mips0(
        .clk(clk_12M), .rst(rst),
        .rom_addr_o(inst_addr), .rom_data_i(inst),
        .rom_ce_o(rom_ce),
		  
		  .ram_we_o(mem_we_i),
		  .ram_addr_o(mem_addr_i),
		  .ram_sel_o(mem_sel_i),
		  .ram_data_o(mem_data_i),
		  .ram_data_i(mem_data_o),
		  .ram_ce_o(mem_ce_i),
	 //DEBUG
		  .debug(debug)
    );

    inst_rom inst_rom0(
        .ce(rom_ce),
        .addr(inst_addr), .inst(inst)
    );
	 
	 data_ram data_ram0(
		.clk(clk),
		.we(mem_we_i),
		.addr(mem_addr_i),
		.sel(mem_sel_i),
		.data_i(mem_data_i),
		.data_o(mem_data_o),
		.ce(mem_ce_i)		
	);

endmodule
