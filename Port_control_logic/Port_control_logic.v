`default_nettype none
module Port_control_logic(
    input wire MSTR,
    input wire SCK_out,
    input wire Data_out,
    // input wire SS_master, // processor
    inout wire MOSI,
    inout wire MISO,
    inout wire SCK,
    inout wire SS,
    //output wire SS_slave, 
    output wire SCK_in,
    output wire Data_in
);

endmodule