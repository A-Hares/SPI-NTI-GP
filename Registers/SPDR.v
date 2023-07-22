`default_nettype none
module SPDR(
    input wire [7:0] SPDR_in,
    input wire clk, rst,
    output reg SPDR_out
);

always @(posedge clk, negedge rst) begin
    if(~rst)
        SPDR_out <= 0;
    else
        SPDR_out <= SPDR_in;
end
    

endmodule