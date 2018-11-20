`include "macro.v"
`timescale 1ns/1ps

module ori_sopc_tst();
reg CLOCK_50;
reg rst;

initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
end

initial begin
    rst = `RSTENABLE;
    #195 rst = `RSTDISABLE;
    #1000 $stop;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpall;
end

ori_sopc ori_sopc0(
    .clk(CLOCK_50),
    .rst(rst)
);

endmodule
