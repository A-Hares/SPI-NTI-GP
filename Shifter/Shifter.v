
`default_nettype none
module Shifter #(parameter DWIDTH = 8)(
    input wire rst,
    input wire Sample_clk, // to take input from data in (from slave)
    input wire Shift_clk, // shifting inside shifter and to data out
    input wire Data_in,
    input wire shifter_en, //in shift clk block it should be one to shift (coming from controller)
    input wire SPDR_wr_en, // to write in spdr
    input wire SPDR_rd_en, // to read in spdr
    input wire [DWIDTH-1:0] SPDR_in,
    output reg [DWIDTH-1:0] SPDR_out,
    output reg Data_out
);
    reg [DWIDTH-1:0] shifter_data_reg;
    reg [DWIDTH-1:0] shifter_data;

    always@(negedge rst, posedge Shift_clk) begin
        if(~rst) begin
            Data_out <= 0;
        end
        else if(shifter_en) begin
            Data_out <= shifter_data[DWIDTH-1];  
        end
    end

    always@(posedge Sample_clk) begin
        shifter_data_reg <= {shifter_data[DWIDTH-2:0] ,Data_in};
    end

    always@(*) begin
        SPDR_out = 'b0 ;
        if (SPDR_wr_en) begin
            SPDR_out = shifter_data_reg ;
        end
        else if (SPDR_rd_en) begin
            shifter_data = SPDR_in;
        end
        else if (Sample_clk)
            shifter_data = shifter_data_reg;

    end

endmodule
