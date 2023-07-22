`default_nettype none
module Shifter #(parameter DWIDTH = 8)(
    input wire Sample_clk,
    input wire Shift_clk,
    input wire Data_in,
    input wire shifter_en,
    input wire SPDR_wr_en,
    input wire SPDR_rd_en,
    input wire [DWIDTH-1:0] SPDR_in,
    output wire [DWIDTH-1:0] SPDR_out,
    output wire Data_out
);

endmodule