`default_nettype none
`include "SCK_control.v"
module SCK_control_tb();

reg M_BaudRate, CPOL, CPHA, idle;
wire SCK_out, Shift_clk, Sample_clk;
SCK_control sck1(.M_BaudRate(M_BaudRate), .CPOL(CPOL), .CPHA(CPHA), .idle(idle), .SCK_out(SCK_out), .Shift_clk(Shift_clk), .Sample_clk(Sample_clk));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    // Mode 0 test
    CPOL = 0; CPHA = 0; idle = 1; M_BaudRate = 0;
    #5 idle = 0;
    repeat(8) begin
      M_BaudRate = 0; 
      #1 M_BaudRate = 1;
      #1;
    end

    //Mode 1 test
    CPOL = 0; CPHA = 1; idle = 1; M_BaudRate = 0;
    #5 idle = 0;
    repeat(8) begin
      M_BaudRate = 0; 
      #1 M_BaudRate = 1;
      #1;
    end


    //Mode 2 test
    CPOL = 1; CPHA = 0; idle = 1; M_BaudRate = 0;
    #5 idle = 0;
    repeat(8) begin
      M_BaudRate = 0; 
      #1 M_BaudRate = 1;
      #1;
    end


    //Mode 3 test
    CPOL = 1; CPHA = 1; idle = 1; M_BaudRate = 0;
    #5 idle = 0;
    repeat(8) begin
      M_BaudRate = 0; 
      #1 M_BaudRate = 1;
      #1;
    end
end

endmodule
