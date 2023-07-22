`default_nettype none
`timescale 1ns/100ps
`include "SPI_TOP.v"
module SPI_TB;
    reg rst = 1, clk = 0, SS_master;
    wire SS, MISO, MOSI, SCK;
    wire SPIF;
    reg [7:0] SPCR_in, SPIBR_in, SPDR_From_user;
    
    localparam clockperiod = 10;

    SPI_TOP DUT_master(
        .rst       (rst       ),
        .SS        (SS        ),
        .MOSI      (MOSI      ),
        .MISO      (MISO      ),
        .SCK       (SCK       ),
        .clk       (clk       ),
        .SS_master (SS_master ),
        .SPCR_in   (SPCR_in   ),
        .SPDR_From_user (SPDR_From_user),
        .SPIF  (SPIF  ),
        .SPIBR_in (SPIBR_in)
    );

    wire S_SPIF;
    reg [7:0] S_SPCR_in, S_SPDR_From_user;

    SPI_TOP DUT_slave(
        .rst       (rst       ),
        .SS        (SS        ),
        .MOSI      (MOSI      ),
        .MISO      (MISO      ),
        .SCK       (SCK       ),
        .clk       (clk       ),
        .SS_master (1'b1 ),
        .SPCR_in   (S_SPCR_in   ),
        .SPDR_From_user (S_SPDR_From_user),
        .SPIF  (S_SPIF ),
        .SPIBR_in (8'b0)
    );

    always #(clockperiod/2) clk = ~clk;

    initial begin
        $dumpfile("dump2.vcd");
        $dumpvars;

        // Global Reset
            #(clockperiod/2) rst = 0; 
            #(clockperiod/2) rst = 1; 
        
        // Insert 1st Byte into each SPDR
            S_SPDR_From_user = 8'b01010101; // Slave SPDR
            SPDR_From_user = 8'b10101010;   // Master SPDR
            
        // Master & Slave Setup
                       
            SS_master = 0;
            SPIBR_in = 2;                   // Prescalar = 2 
            #(clockperiod);
            SPCR_in = 8'bx0x100xx;          // Master Control Register
            S_SPCR_in = 8'bx0x000xx;        // Slave Control Register 
        // Master & Slave Enable
            S_SPCR_in = 8'bx1x000xx;        // Set slave MSTR = 0
            SPCR_in = 8'bx1x100xx;          // Set Master MSTR = 1

        // Check the values  ( Test 1)
            #(clockperiod*2**(3)*9 + clockperiod); 
            expect_master(8'b01010101);
            expect_slave(8'b10101010);
        
        // New Test 2
            SPDR_From_user = 8'hBB;
            S_SPDR_From_user = 8'hDD;
        
        // Check the values  ( Test 2)
            #(clockperiod*2**(3)*9); 
            expect_master(8'hDD);
            expect_slave(8'hBB);
        
        // New Test 3
            SPDR_From_user = 8'hBC;
            S_SPDR_From_user = 8'hDA;
        
        // Check the values  ( Test 3)
            #(clockperiod*2**(3)*9); 
            expect_master(8'hDA);
            expect_slave(8'hBC);

        // New Test 4
            SPDR_From_user = 8'hFB;
            S_SPDR_From_user = 8'hAC;
        
        // Check the values  ( Test 4)
            #(clockperiod*2**(3)*9); 
            expect_master(8'hAC);
            expect_slave(8'hFB);

        $display("TEST PASSED!");
        $finish;

    end

    task expect_master (input [7:0] exp_SPDR);
        if (DUT_master.u_SPDR.SPDR !== exp_SPDR) begin
            $display("TEST FAILED");
            $display("time=%0d: Master SPDR is 0x%h and should be 0x%h",
                    $time, DUT_master.u_SPDR.SPDR, exp_SPDR);
            $finish;
        end
        else
            $display("time=%0d: \t SUCCESS: \t Master SPDR is \t 0x%h \t and wanted value is \t 0x%h",
                    $time, DUT_master.u_SPDR.SPDR, exp_SPDR);
    endtask

    task expect_slave (input [7:0] exp_SPDR);
        if (DUT_slave.u_SPDR.SPDR !== exp_SPDR) begin
            $display("TEST FAILED");
            $display("time=%0d: Slave SPDR is 0x%h and should be 0x%h",
                    $time, DUT_slave.u_SPDR.SPDR, exp_SPDR);
            $finish;
        end
        else
            $display("time=%0d: \t SUCCESS:  \t  Slave SPDR is \t 0x%h \t and wanted value is \t 0x%h",
                    $time, DUT_slave.u_SPDR.SPDR, exp_SPDR);
    endtask

endmodule