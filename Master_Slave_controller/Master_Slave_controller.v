
`default_nettype none

module Master_Slave_controller(
    input wire clk,
    input wire control_BaudRate,            // From baud rate generator
    input wire rst,                 // Global Reset
    input wire SS,                  // Slave Select , active low, comes from processor or port register
    input wire SPE,                 // SPI enable from SPCR, comes from user
    input wire MSTR,                // Master enable from SPCR, comes from user
    input wire [2:0] counter,
    output reg counter_enable,
    output reg Reg_write_en,       // enable writing in SPI Status Register(SPSR) , to enable writing SPIF
    output reg Shifter_en,         // enable shifter operation 
    output reg idle,               // signal indicates that nothing is being sent/recieved, goes to SCK_control,when idle state , idle =1
    output reg start,
    output reg SPIF,                // SPI Flag, is set to high when 1 byte is ready and written to SPDR
    output wire BRG_clr,            // is set to 1 when SS is 1 or MSTR is 0, goes to BRG
    output reg SPDR_wr_en,          // goes to shifter to enable writing to SPDR from shifter register
    output reg SPDR_rd_en           // goes to shifter to enable writing to shifter register after reading SPDR

);
    localparam Start = 0, Idle = 1 , Run = 2, Update = 3;
    reg [1:0] current_state, next_state;

    assign BRG_clr = ~MSTR | SS | ~SPE;


    always @(posedge control_BaudRate , negedge rst) begin
        if(~rst)
            current_state <= Start;
        else
            current_state <= next_state;
    end

    always @(*) 
        case (current_state)
            Start:  if (SPE) next_state=Idle;
            Idle:   if (!SS && SPE) begin next_state=Run; end
                    else begin next_state=Idle; end
            
            Run:    if (counter==7) begin next_state=Update; end
                    else begin next_state=Run; end

            Update: next_state=Idle;
        endcase 




    always @(*) begin
        idle = 0;
        SPDR_rd_en = 0;
        SPDR_wr_en = 0;
        Shifter_en = 0;
        SPIF = 0;
        Reg_write_en = 0;
        counter_enable = 0;
        start = 0;
        case (current_state)
            Start:  begin
                        start = 1;
                    end
            Idle :  begin
                        idle = 1;
                        SPDR_rd_en = 1;
                        Reg_write_en = 1;
                    end
            Run :   begin   
                        Shifter_en = 1; 
                        counter_enable = 1;
                    end
            Update: begin
                        idle = 1; 
                        SPDR_wr_en = 1;
                        SPIF = 1;
                        Reg_write_en = 1;
                    end
            
        endcase
    end


endmodule