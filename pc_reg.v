`include "macro.v"
module pc_reg(
	input wire			clk,
	input wire			rst,
    input wire[5:0]     stall,
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
		end else if (stall[0] == `NOSTOP) begin
			pc <= pc + 4'h4;
		end
	end
	
endmodule 
