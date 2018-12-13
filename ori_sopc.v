`include "macro.v"
module ori_sopc(
    input wire CLOCK_50,
    input wire rst,
	 //output [7:0] vga_q,
	 //input [11:0] vga_rdaddress,
	 
	 //DEBUG
	 output wire[9:0] debug
);

    
	 wire mem_we_i;
    wire[`REGBUS] mem_addr_i;
    wire[`REGBUS] mem_data_i;
    wire[`REGBUS] mem_data_o;
    wire[3:0] mem_sel_i;  
    wire mem_ce_i;  
	 
	 wire [`REGBUS] inst_data_o;
	 wire[`INSTADDRBUS] inst_addr;
    wire[`INSTBUS] inst;
    wire rom_ce;
	 
	 wire [`REGBUS] video_data_o;
	 
	 wire mmio_GRAM = (mem_addr_i >= `MMIO_GRAM_START) && (mem_addr_i < `MMIO_GRAM_END);
	 wire mmio_ROM = (mem_addr_i >= `MMIO_ROM_START) && (mem_addr_i < `MMIO_ROM_END);
	 wire no_mmio = (mem_addr_i >= `MMIO_NO);
	 wire [`REGBUS] ram_data_return = (mmio_GRAM)?video_data_o:((mmio_ROM)?inst_data_o:mem_data_o);
	 
	 wire clk_12M;
	 clkgen #(12500000)clk12M(
		  .clkin(CLOCK_50),
		  .rst(1'b0),
		  .clken(1'b1),
		  .clkout(clk_12M)
    );

    NJU_MIPS mips0(
        .clk(clk_12M), .rst(rst),
        .rom_addr_o(inst_addr), 
		  .rom_data_i(inst),
        .rom_ce_o(rom_ce),
		  
		  .ram_we_o(mem_we_i),
		  .ram_addr_o(mem_addr_i),
		  .ram_sel_o(mem_sel_i),
		  .ram_data_o(mem_data_i),
		  .ram_data_i(ram_data_return),
		  .ram_ce_o(mem_ce_i),
	 //DEBUG
		  .debug(debug)
    );

    
    inst_rom inst_rom0(
		  .clk(CLOCK_50),
        .ce(rom_ce),
		  
        .inst_addr(inst_addr), 
		  .inst(inst),
		  
		  .addr(mem_addr_i),
		  .sel(mem_sel_i),
		  .data_o(inst_data_o)
    );
	 
	 data_ram data_ram0(
		.clk(CLOCK_50),
		.ce(mem_ce_i),
		
		.addr(mem_addr_i),
		.sel(mem_sel_i),
		.we(no_mmio && mem_we_i),
		.data_i(mem_data_i),
		.data_o(video_data_o)
	 );
	
	wire				  [7:0]		vga_q;
	wire	        [11:0]    vga_rdaddress;
	 video_ram video_ram0(
		 .clk(CLOCK_50),
		 .ce(mem_ce_i),
		 
		 .addr(mem_addr_i - `MMIO_GRAM_START),
		 .sel(mem_sel_i),
		 .we(mmio_GRAM && mem_we_i),
		 .data_i(mem_data_i),
		 .data_o(mem_data_o),
		 
		 .vga_rdaddress(vga_rdaddress),
		 .vga_q(vga_q)
	 );
	 
	 vga video_output(
	.CLOCK_50(CLOCK_50),
	.VGA_BLANK_N(VGA_BLANK_N),
	.VGA_B(VGA_B),
	.VGA_CLK(VGA_CLK),
	.VGA_G(VGA_G),
	.VGA_HS(VGA_HS),
	.VGA_R(VGA_R),
	.VGA_SYNC_N(VGA_SYNC_N),
	.VGA_VS(VGA_VS),
	.q(vga_q),
	.rdaddress(vga_rdaddress)
	);			

endmodule
