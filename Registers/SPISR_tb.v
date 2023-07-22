`default_nettype none
`include "SPISR.v"

module SPISR_tb();
reg clk, rst;
reg [7:0] SPISR_in;
wire SPIF, SPTEF;

SPISR SPISR1(.clk(clk), .rst(rst), .SPISR_in(SPISR_in), .SPIF(SPIF), .SPTEF(SPTEF));

initial begin
    $dumpfile("SPISR_tb.vcd");
    $dumpvars;
    clk = 0; rst = 1;
    #5 clk = 1;
    SPISR_in = 8'b1001_1110;
    #7 rst = 0; clk = 0;
    #5 SPISR_in = 8'b0011_1010;
    #5 rst = 1; #1 clk = 1;
    #5;
end

endmodule
