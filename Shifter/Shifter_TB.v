`default_nettype none
`timescale 1ns/100ps
`include "Shifter.v"
`include "../SCK_control/SCK_control.v"
module Shifter_TB();

reg M_BaudRate, CPOL, CPHA, idle;
wire SCK_out, Shift_clk, Sample_clk;
SCK_control sck1(.M_BaudRate(M_BaudRate), .CPOL(CPOL), .CPHA(CPHA), .idle(idle), .SCK_out(SCK_out), .Shift_clk(Shift_clk), .Sample_clk(Sample_clk));

wire Data_out, SPDR_rd_en , shifter_en;
reg SPDR_wr_en, Data_in;
reg [7:0] SPDR_in;
wire [7:0] SPDR_out;

Shifter #(8) shift_inst1(.Sample_clk(Sample_clk), .Shift_clk(Shift_clk), .Data_in(Data_in),.shifter_en(shifter_en), 
    .SPDR_wr_en(SPDR_wr_en), .SPDR_rd_en(SPDR_rd_en), .SPDR_in(SPDR_in), .SPDR_out(SPDR_out), .Data_out(Data_out));

assign shifter_en = 1;
assign SPDR_rd_en = idle;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    // Mode 0 test
    CPOL = 0; CPHA = 1; idle = 1; M_BaudRate = 0; Data_in = 0; SPDR_wr_en = 0; SPDR_in = 8'hFF;
    #5 idle = 0; 
    repeat(8) begin
      M_BaudRate = 0; 
      #1 M_BaudRate = 1;
      #1;
    end
      SPDR_wr_en = 1; 
      #5;

end

endmodule

