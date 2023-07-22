`default_nettype none
module Port_control_logic(
    /*MSTR — SPI Master/Slave Mode Select Bit
                     This bit selects, if the SPI operates in master or slave mode. Switching the SPI from master to slave or
                     vice versa forces the SPI system into idle state.
                     1 = SPI is in Master mode
                     0 = SPI is in Slave mode */
    input wire MSTR, 
    input wire  SCK_out,
    input wire  Data_out,
    input wire  SS_master, //! from processor
    inout wire  MOSI,
    inout wire  MISO,
    inout wire  SCK,
    inout wire  SS,
    output wire SCK_in,
    output wire Data_in
);


//----------------------------------------------------------------------------------------------------
/*This pin is used to transmit data out of the SPI module when it is configured as a Master and receive data
  when it is configured as Slave.*/
assign  MOSI = MSTR? Data_out: 'bz;
assign  Data_in = MSTR ? MISO : MOSI;
//----------------------------------------------------------------------------------------------------
/*This pin is used to transmit data out of the SPI module when it is configured as a Slave and receive data
when it is configured as Master.*/
assign  MISO = ~MSTR ? Data_out:'bz;

//----------------------------------------------------------------------------------------------------
/*This pin is used to output the select signal from the SPI module to another peripheral with which a data
transfer is to take place when its configured as a Masterand its used as an input to receive the slave select
signal when the SPI is configured as Slave.*/
assign  SS = MSTR ? SS_master : 'bz;

//----------------------------------------------------------------------------------------------------
/*This pin is used to output the clock with respect to which the SPI transfers data or receive clock in case of
Slave.*/
assign  SCK = MSTR ? SCK_out :'bz;
assign  SCK_in = MSTR ? 'bz : SCK;

endmodule