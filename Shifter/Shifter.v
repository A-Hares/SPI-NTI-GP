
`default_nettype none
module Shifter #(parameter DWIDTH = 8)(
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

    always@(posedge Sample_clk) begin
        shifter_data_reg <= {shifter_data_reg[DWIDTH-2:0] ,Data_in};
    end


    always@(posedge Shift_clk) begin
        if(shifter_en) begin
            Data_out <= shifter_data_reg[DWIDTH-1];  
        end
    end


    always@(*) begin
        if (SPDR_wr_en) begin
            SPDR_out = shifter_data ;
            shifter_data = shifter_data_reg;
        end
        else if (SPDR_rd_en) begin
            shifter_data_reg = SPDR_in;
            shifter_data = SPDR_in;
            SPDR_out = 'bz ;
        end
        else begin
            shifter_data = shifter_data_reg;
            SPDR_out = 'bz ;
        end
    end


endmodule
