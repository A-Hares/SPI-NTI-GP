`default_nettype none
`timescale 1ns/100ps
`include "BRG.v"

module BRG_TB;

    localparam PrescalarWidth = 3;
    localparam ClockPeriod = 10;

    reg clk = 0,rst = 0,en = 0, clr=1;
    reg [PrescalarWidth-1:0] SPR = 0;
    wire BaudRate;

    always #(ClockPeriod/2) clk = ~clk;
    
    BRG BRG_inst(.clk(clk), .rst(rst), .clr(clr), .en(en), .SPR(SPR), .BaudRate(BaudRate));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #15
        rst = 1; en = 1; clr = 0;
        #200
        SPR = 1;
        #200
        SPR = 2; en = 1; clr = 1;
        #200
        SPR = 1;
        #100 $finish;
    end

endmodule