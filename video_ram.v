`include "macro.v"
module video_ram(
	input wire clk,
	input wire ce,
   input wire we,
	input wire[`VIDEOADDRBUS] addr,
	input wire[3:0] sel,
	input wire[`VIDEOBUS] data_i,
	output reg[`VIDEOBUS] data_o,
	
	input [11:0] vga_rdaddress,
	output reg [7:0] vga_q
);
	
	wire[`BYTEWIDTH] data_mem0, data_mem1, data_mem2, data_mem3;
	wire[`BYTEWIDTH] video_mem0, video_mem1, video_mem2, video_mem3;
	/*
	video_ram_ip0 ram0(
		.clock(clk), 
		
		.address_a(addr[`VIDEOMEMNUMLOG2+1:2]),
		.wren_a(ce&&we&&sel[0]),
		.data_a(data_i[7:0]),
		.q_a(data_mem0),
		
		.address_b(vga_rdaddress),
		.wren_b(0),
		.data_a(),
		.q_b(video_mem0)
	);
	
	video_ram_ip1 ram1(
		.clock(clk), 
		
		.address_a(addr[`VIDEOMEMNUMLOG2+1:2]),
		.wren_a(ce&&we&&sel[1]),
		.data_a(data_i[15:8]),
		.q_a(data_mem1),
		
		.address_b(vga_rdaddress),
		.wren_b(0),
		.data_a(),
		.q_b(video_mem1)
	);
	
	video_ram_ip2 ram2(
		.clock(clk), 
		
		.address_a(addr[`VIDEOMEMNUMLOG2+1:2]),
		.wren_a(ce&&we&&sel[2]),
		.data_a(data_i[23:16]),
		.q_a(data_mem2),
		
		.address_b(vga_rdaddress),
		.wren_b(0),
		.data_a(),
		.q_b(video_mem2)
	);
	
	video_ram_ip3 ram3(
		.clock(clk), 
		
		.address_a(addr[`VIDEOMEMNUMLOG2+1:2]),
		.wren_a(ce&&we&&sel[3]),
		.data_a(data_i[31:24]),
		.q_a(data_mem3),
		
		.address_b(vga_rdaddress),
		.wren_b(0),
		.data_a(),
		.q_b(video_mem3)
	);

	*/
	always @(posedge clk) begin
		if (ce == `CHIPDISABLE) begin
	   end else if (we == `WRITEDISABLE) begin
			data_o <= {data_mem3, data_mem2, data_mem1, data_mem0};
		end else
			data_o <= `ZEROWORD;
	end
	
	always @(posedge clk) begin
		if (ce == `CHIPDISABLE) begin
	   end else begin
			vga_q <= {video_mem3, video_mem2, video_mem1, video_mem0};
		end
	end
	
endmodule 