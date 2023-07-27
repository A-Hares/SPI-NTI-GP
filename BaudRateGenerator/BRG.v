`default_nettype none

module BRG
#(  parameter PrescalarWidth = 3)
(
    input wire clk,
    input wire rst, // ~rst | SS
    input wire clr,
    input wire [PrescalarWidth-1:0] SPR,
    output wire BaudRate
);

    reg [2**PrescalarWidth-1:0] counter;
    wire [2**PrescalarWidth-1:0] counterNext;
    

    always @(posedge clk or negedge rst) begin
        if(~rst )
            counter <= 0;
        else if(clr)
             counter <= 0;
        else 
          counter <= counterNext;
  
    end

    assign counterNext = counter + 1;
    assign BaudRate = counter[SPR];

endmodule