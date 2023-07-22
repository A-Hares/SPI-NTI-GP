`default_nettype none

module SPISR(
    input wire clk, rst,
    input wire [7:0] SPISR_in,
    output reg SPIF, SPTEF
);

always @(posedge clk or negedge rst) begin
    if(~rst)begin
      SPIF <= 0; SPTEF <= 0;
    end
    else begin
      SPIF <= SPISR_in[7];
      SPTEF <= SPISR_in[5];
    end
end
endmodule