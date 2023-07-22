`default_nettype none
module SPDR(
    input wire [7:0] SPDR_in,
    input wire clk, rst, en,
    output reg [7:0] SPDR_out
);

always @(posedge clk, negedge rst) begin
    if(~rst)
        SPDR_out <= 0;
    else begin
      if(en)
        SPDR_out <= SPDR_in;
      else
        SPDR_out <= SPDR_out;
    end
        
end
    

endmodule
