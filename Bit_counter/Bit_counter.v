`default_nettype none
module Bit_counter(
    input wire BaudRate,
    input wire rst,
    input wire counter_enable_master,
    input wire counter_enable_slave,
    output reg [2:0] counter
);
    wire counter_enable;
    assign counter_enable = counter_enable_master | counter_enable_slave;
    
    always@(posedge BaudRate or negedge rst)
        begin
            if(!rst) begin counter<='b0; end

            else if (counter_enable)
            begin 
                counter <= counter + 1'b1;
            end
        end

endmodule