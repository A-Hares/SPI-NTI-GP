
`default_nettype none
module Master_controller(
    input wire clk,
    input wire BaudRate,            // From baud rate generator
    input wire rst,                 // Global Reset
    input wire SS,                  // Slave Select , active low, comes from processor or port register
    input wire SPE,                 // SPI enable from SPCR, comes from user
    input wire MSTR,                // Master enable from SPCR, comes from user
    output reg Reg_write_en,       // enable writing in SPI Status Register(SPSR) , to enable writing SPIF
    output reg Shifter_en,         // enable shifter operation 
    output reg idle,               // signal indicates that nothing is being sent/recieved, goes to SCK_control,when idle state , idle =1
    output wire M_BaudRate,          // Master baud rate, goes to SCK control
    output reg SPIF,                // SPI Flag, is set to high when 1 byte is ready and written to SPDR
    output wire BRG_clr,            // is set to 1 when SS is 1 or MSTR is 0, goes to BRG
    output reg SPDR_wr_en,          // goes to shifter to enable writing to SPDR from shifter register
    output reg SPDR_rd_en           // goes to shifter to enable writing to shifter register after reading SPDR

);
    localparam Idle = 0 , Run = 1, Update = 2;
    reg [1:0] current_state, next_state;
    assign M_BaudRate = ~idle & ~BaudRate;
   
    reg [2:0] counter;
    reg  counter_enable ; 
    always@(posedge BaudRate or negedge rst)
    begin
        if(!rst) begin counter<='b0; end

        else if (counter_enable)
        begin 
            counter <= counter + 1'b1;
        end
    end

    assign BRG_clr = ~MSTR | SS | ~SPE;


    always @(posedge BaudRate , negedge rst) begin
        if(~rst)
            current_state <= Idle;
        else
            current_state <= next_state;
    end

    always @(*) 
        case (current_state)
            Idle:   if (!SS && MSTR && SPE) begin next_state=Run; end
                    else begin next_state=Idle; end
            
            Run:    if (counter==7) begin next_state=Update; end
                    else begin next_state=Run; end

            Update: next_state=Idle;
        endcase 
    reg temp;
    always @(posedge clk) begin
        temp <= 0;
        if ((current_state == Update)) begin
            current_state <= next_state;
        end 
        else if (current_state == Idle)
            if (temp == 0)
                temp <= 1;
            else 
                current_state <= next_state;
    end

    always @(*) begin
        idle = 0;
        SPDR_rd_en = 0;
        SPDR_wr_en = 0;
        Shifter_en = 0;
        SPIF = 0;
        Reg_write_en = 0;
        counter_enable = 0;
        case (current_state)
            Idle :  begin
                        idle = 1;
                        SPDR_rd_en = 1;
                    end
            Run :   begin
                        SPIF = 0;
                        Reg_write_en = 1;
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