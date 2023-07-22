`default_nettype none

module SPISR(
    input wire clk, rst, en, 
    input wire [7:0] SPISR_in,
    output reg SPIF, SPTEF
);

always @(posedge clk or negedge rst) begin
    if(~rst)begin
      SPIF <= 0; SPTEF <= 0;
    end
    else begin
        if(en) begin
          SPIF <= SPISR_in[7];
          SPTEF <= SPISR_in[5];
        end
        else begin
          SPIF <= SPIF;
          SPTEF <= SPTEF;
        end
      
    end
end
endmodule
