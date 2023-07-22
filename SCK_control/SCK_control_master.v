`default_nettype none
module SCK_control_master(
    input wire M_BaudRate,
    input wire CPOL,
    input wire CPHA,
    input wire idle, 
    output reg SCK_out,
    output reg Shift_clk,
    output reg Sample_clk
);

always @(*) begin
    Shift_clk = !idle & !M_BaudRate;
    Sample_clk = M_BaudRate;
    case({CPOL, CPHA})
    0: SCK_out = M_BaudRate;
    1: SCK_out = !idle & !M_BaudRate;
    2: SCK_out = !M_BaudRate;
    3: SCK_out = idle | M_BaudRate;
    endcase
end

endmodule