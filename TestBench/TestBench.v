`default_nettype none
`timescale 1ns/100ps
`include "SPI_TOP.v"
module SPI_TB;
    reg rst, clk = 0, SS_master, LSBFE, SPISR_in, SPTEF;
    wire SS, MISO, MOSI, SCK;
    reg SS_reg, MISO_reg, MOSI_reg, SCK_reg;
    wire SCK_in, SS_slave, SPIF;
    reg [7:0] SPCR_in, SPIBR_in, SPDR_From_user;
    

    SPI_TOP DUT(
        .rst       (rst       ),
        .SS        (SS        ),
        .MOSI      (MOSI      ),
        .MISO      (MISO      ),
        .SCK       (SCK       ),
        .clk       (clk       ),
        .SS_master (SS_master ),
        .SS_slave  (SS_slave  ),
        .SCK_in    (SCK_in    ),
        .SPCR_in   (SPCR_in   ),
        .LSBFE     (LSBFE     ),
        .SPDR_From_user (SPDR_From_user),
        .SPIF  (SPIF  ),
        .SPIBR_in (SPIBR_in)
    );

    always #5 clk = ~clk;
   // assign SS = SS_reg;
  //  always @(*) begin
    //    if (SPIF)   SPCR_in = 8'bx0x100xx;
   //        end
    assign MISO = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        rst = 0; #5 rst = 1; SPCR_in = 8'bx0x100xx; SS_master = 0;
        #10;
        SPDR_From_user = 8'b10101010;
        SPIBR_in = 2;
        SPCR_in = 8'bx1x100xx;
        #800;
        SPDR_From_user = 8'hFF;
        #800;
       // SPCR_in = 8'bx0x100xx;
        $finish;

    end

endmodule