`include "macro.v"

module pc_reg(
	input wire			clk,
	input wire			rst,
	output reg[`INSTADDRBUS] pc,
	output reg			ce
);

	always @ (posedge clk) begin
		if (rst == `RSTENABLE) begin
			ce <= `CHIPDISABLE;
		end else begin
			ce <= `CHIPENABLE;
		end
	end
		
	always @ (posedge clk) begin
		if (ce == `CHIPDISABLE) begin
			pc <= 32'h00000000;
		end else begin
			pc <= pc + 4'h4;
		end
	end
	
endmodule 
