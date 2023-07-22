`default_nettype none
`include "SPIBR.v"

module SPIBR_tb();
    reg clk, rst;
    reg [7:0] SPIBR_in;
    wire SPR0, SPR1, SPR2;
    
    SPIBR SPIBR1(.SPIBR_in(SPIBR_in), .clk(clk), .rst(rst), .SPR0(SPR0), .SPR1(SPR1), .SPR2(SPR2));

    initial begin
        $dumpfile("SPIBR_tb.vcd");
        $dumpvars;
        clk = 0; rst = 1;
        #5 clk = 1;
        SPIBR_in = 8'b0001_1110;
        #5 rst = 0; clk = 0;
        #5 SPIBR_in = 8'b0011_1010;
        #5 rst = 1; #1 clk = 1;
        #5;
    end
endmodule