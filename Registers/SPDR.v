`default_nettype none
module SPDR(
    input wire [7:0] SPDR_in,
    input wire [7:0] SPDR_From_user,
    input wire clk, rst, en, SPDR_rd_en,
    output wire [7:0] SPDR_out
);
    reg [7:0] SPDR;
    assign SPDR_out = SPDR;
always @(posedge clk, negedge rst) begin
    if(~rst)
        SPDR <= 0;
    else begin
      if(en)
        SPDR <= SPDR_in;
      else if (SPDR_rd_en)
        SPDR <= SPDR_From_user;
      else
        SPDR <= SPDR_out;
    end
        
end
    

endmodule
