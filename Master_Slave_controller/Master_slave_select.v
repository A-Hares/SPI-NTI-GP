`default_nettype none
module Master_slave_select(
    input wire MSTR,
    input wire S_BaudRate,
    input wire BaudRate,
    input wire M_Shift_clk,
    input wire M_Sample_clk,
    input wire S_Shift_clk,
    input wire S_Sample_clk,
    input wire idle,
    output reg M_BaudRate,
    output reg control_BaudRate,
    output reg Shift_clk,
    output reg Sample_clk
);
    
    always @(*) begin
        if (MSTR) begin
            M_BaudRate = ~idle & ~BaudRate;
            control_BaudRate = M_BaudRate;
            Shift_clk = M_Shift_clk;
            Sample_clk = M_Sample_clk;
        end
        else if (~MSTR) begin
            M_BaudRate = 0;
            control_BaudRate = S_BaudRate;
            Shift_clk = S_Shift_clk;
            Sample_clk = S_Sample_clk;
        end
    end
endmodule