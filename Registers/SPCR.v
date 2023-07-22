`default_nettype none

module SPCR(
    input wire [7:0] SPCR_in,
    input wire clk, rst,
    output reg SPE, MSTR, CPOL, CPHA, LSBFE
);

always @(posedge clk or negedge rst) begin
    if(~rst)begin
      SPE <= 0; MSTR <= 0; CPOL <= 0; CPHA <= 0; LSBFE <= 0;
    end
    else begin
      SPE <= SPCR_in[6]; //SPI enable
      MSTR <= SPCR_in[4]; // Master or slave
      CPOL <= SPCR_in[3]; //Clock polarity
      CPHA <= SPCR_in[2]; //Clock phase
      LSBFE <= SPCR_in[0]; //Most sig bit or least sig bit first
    end
end
endmodule
