module SPIBR(
    input wire [7:0] SPIBR_in,
    input wire clk, rst,
    output wire [2:0] SPR
    );
reg SPR0, SPR1, SPR2;

always @(posedge clk or negedge rst) begin
    if(~rst)begin
      SPR0 <= 0; SPR1 <= 1; SPR2 <= 2;
    end
    else begin
      SPR0 <= SPIBR_in[0];
      SPR1 <= SPIBR_in[1];
      SPR2 <= SPIBR_in[2];
    end
end

assign SPR={SPR2,SPR1,SPR0 };
endmodule