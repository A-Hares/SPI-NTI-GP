`default_nettype none
module Master_controller(
    input wire BaudRate,
    input wire rst,
    input wire SS,
    input wire SPE,
    input wire MSTR,
    output wire Reg_write_en,
    output wire Shifter_en, 
    output reg M_BaudRate,
    output reg SPIF,
    output wire BRG_clr,
    output reg SPDR_wr_en,
    output reg SPDR_rd_en
);


endmodule