`default_nettype none

module SPISR(
    input wire clk, rst, en, 
    input wire SPISR_in,
    output reg SPIF
);

always @(posedge clk or negedge rst) begin
    if(~rst)begin
      SPIF <= 0;
    end
    else begin
        if(en) begin
          SPIF <= SPISR_in;
        end
        else begin
          SPIF <= SPIF;
        end
      
    end
end
endmodule
