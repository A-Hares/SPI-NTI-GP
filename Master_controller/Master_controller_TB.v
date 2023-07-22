`default_nettype none
`timescale 1ns/100ps
`include "Master_controller.v"

module Master_controller_TB;
    reg BaudRate = 0, rst, SS, SPE,MSTR;
    wire M_BaudRate, Reg_write_en, Shifter_en, idle, SPIF, BRG_clr, SPDR_wr_en, SPDR_rd_en;

    Master_controller inst1(
        .BaudRate(BaudRate),
        .rst(rst),
        .SS(SS),
        .SPE(SPE),
        .MSTR(MSTR),
        .Reg_write_en(Reg_write_en),
        .Shifter_en(Shifter_en),
        .idle(idle),
        .SPIF(SPIF),
        .M_BaudRate(M_BaudRate),
        .BRG_clr(BRG_clr),
        .SPDR_wr_en(SPDR_wr_en),
        .SPDR_rd_en(SPDR_rd_en)
    );

    always BaudRate = #2 ~BaudRate;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        rst = 0; #3 rst = 1; SS = 0; SPE = 1; MSTR = 0;
        #5;
        MSTR = 1;
        #40;
        $finish;
    end



endmodule