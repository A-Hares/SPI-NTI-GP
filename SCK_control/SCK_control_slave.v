`default_nettype none
module SCK_control_slave(
    input wire SCK_in,
    input wire CPOL,
    input wire CPHA,
    input wire idle, 
    output reg S_BaudRate,
    output wire Shift_clk,
    output wire Sample_clk
);

assign Shift_clk = ~idle & S_BaudRate;
assign Sample_clk = ~idle & ~S_BaudRate;

always @(*) begin

 //   Shift_clk = !idle & !S_BaudRate;
 //   Sample_clk = S_BaudRate;

    case({CPOL, CPHA})
        0: S_BaudRate = SCK_in;
        1: S_BaudRate = !idle & !SCK_in;
        2: S_BaudRate = !SCK_in;
        3: S_BaudRate = idle | SCK_in;
    endcase
end

endmodule