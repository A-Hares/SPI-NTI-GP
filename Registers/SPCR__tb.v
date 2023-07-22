`default_nettype none
`include "SPCR_1.v"
module SPCR_tb();
reg [7:0] in;
reg clk, rst;
wire SPE, MSTR, CPOL, CPHA, LSBFE;

SPCR SPCR1(.SPCR_in(in), .clk(clk), .rst(rst), .SPE(SPE), .MSTR(MSTR), .CPOL(CPOL), .CPHA(CPHA), .LSBFE(LSBFE));

initial begin
    $dumpfile("SPCR_tb.vcd");
    $dumpvars;
    clk = 0; rst = 1;
    #5 clk = 1;
    in = 8'b0001_1100;
    #10 rst = 0; clk = 0;
    #5 in = 8'b0011_1010;
    #5 rst = 1; #1 clk = 1;
    #5;
end

endmodule
