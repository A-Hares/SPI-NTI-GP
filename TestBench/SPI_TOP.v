`default_nettype none
`include "../BRG/BRG.v"
//`include "../Master_controller/Master_controller.v"
`include "../Master_Slave_controller\Master_Slave_controller.v"
`include "../Master_Slave_controller\Master_slave_select.v"
`include "../Port_control_logic\Port_control_logic.v"
`include "../Registers\SPCR.v"
`include "../Registers\SPDR.v"
`include "../Registers\SPIBR.v"
`include "../Registers\SPISR.v"
`include "../SCK_control\SCK_control_master.v"
`include "../SCK_control\SCK_control_slave.v"
`include "../Shifter\Shifter.v"
`include "../Bit_counter\Bit_counter.v"
module SPI_TOP #(
    parameter PrescalarWidth = 3
) (
    input  wire        rst,
    inout  wire        SS,
    inout  wire        MOSI,
    inout  wire        MISO,
    inout  wire        SCK,
    input  wire        clk,
    input  wire        SS_master,
    output wire        SS_slave,  //!connected to slave control
    output wire        SCK_in, 
    input  wire [7:0]  SPCR_in,
    input  wire        LSBFE,
    output  wire        SPIF,
    input  wire [7:0]  SPIBR_in,
    input  wire [7:0]  SPDR_From_user

);
  
wire               BaudRate;
wire               BRG_clr;
wire    [2:0]      SPR;
wire               Sample_clk;
wire               Shift_clk;
wire               Data_in;
wire               shifter_en;
wire               SPDR_wr_en;
wire               SPDR_rd_en;
wire    [7:0]      SPDR_in;
wire    [7:0]      SPDR_out;
wire               Data_out;
wire               SPE;
wire               MSTR;
wire               Reg_write_en;
wire               idle;
wire               SPISR_in;
wire               SCK_out;
wire               CPHA;
wire               CPOL;
wire               M_BaudRate;

//______________________________________________________________________________

BRG #(
       .PrescalarWidth (PrescalarWidth )
)
u_BRG(
	.clk      (clk      ),
    .rst      (rst      ),
    .clr      (BRG_clr  ),
    .SPR      (SPR      ),
    .BaudRate (BaudRate )
);

//______________________________________________________________________________

Shifter u_Shifter(
	.Sample_clk (Sample_clk ),
   .Shift_clk  (Shift_clk  ),
   .Data_in    (Data_in    ),
   .shifter_en (shifter_en ),
   .SPDR_wr_en (SPDR_wr_en ),
   .SPDR_rd_en (SPDR_rd_en ),
   .SPDR_in    (SPDR_in    ),
   .SPDR_out   (SPDR_out   ),
   .Data_out   (Data_out   )
);

//______________________________________________________________________________

wire [2:0] counter;
wire counter_enable;

Bit_counter u_Bit_counter(
    .BaudRate(control_BaudRate),
    .rst(rst),
    .counter(counter),
    .counter_enable(counter_enable)
);

wire S_BaudRate;
wire S_Shift_clk;
wire S_Sample_clk;
wire control_BaudRate;

SCK_control_slave u_SCK_control_slave(
    .SCK_in(SCK_in),
    .CPOL(CPOL),
    .CPHA(CPHA),
    .idle(idle), 
    .S_BaudRate(S_BaudRate),
    .Shift_clk(S_Shift_clk),
    .Sample_clk(S_Sample_clk)
);

Master_slave_select u_Master_slave_select(
    .MSTR(MSTR),
    .S_BaudRate(S_BaudRate),
    .BaudRate(BaudRate),
    .M_Shift_clk(M_Shift_clk),
    .M_Sample_clk(M_Sample_clk),
    .S_Shift_clk(S_Shift_clk),
    .S_Sample_clk(S_Sample_clk),
    .idle(idle),
    .M_BaudRate(M_BaudRate),
    .control_BaudRate(control_BaudRate),
    .Shift_clk(Shift_clk),
    .Sample_clk(Sample_clk)
);

Master_Slave_controller u_Master_Slave_controller(
    .clk          (clk),
    .control_BaudRate     (control_BaudRate     ),           // From baud rate generator
    .rst          (rst          ),
    .SS           (SS           ),
    .SPE          (SPE          ),
    .MSTR         (MSTR         ),
    .counter(counter),
    .counter_enable(counter_enable),
    .Reg_write_en (Reg_write_en ),
    .Shifter_en   (shifter_en   ),
    .idle         (idle         ),
    .SPIF         (SPISR_in     ),
    .BRG_clr      (BRG_clr      ),
    .SPDR_wr_en   (SPDR_wr_en   ),
    .SPDR_rd_en   (SPDR_rd_en   )
);

/*
Master_controller u_Master_controller(
    .clk          (clk),
    .BaudRate     (BaudRate     ),
    .rst          (rst          ),
    .SS           (SS           ),
    .SPE          (SPE          ),
    .MSTR         (MSTR         ),
    .Reg_write_en (Reg_write_en ),
    .Shifter_en   (shifter_en   ),
    .idle         (idle         ),
    .M_BaudRate   (M_BaudRate   ),
    .SPIF         (SPISR_in     ),
    .BRG_clr      (BRG_clr      ),
    .SPDR_wr_en   (SPDR_wr_en   ),
    .SPDR_rd_en   (SPDR_rd_en   ),
    .counter(counter),
    .counter_enable(counter_enable_master)
);
*/

//______________________________________________________________________________

Port_control_logic u_Port_control_logic(
    .MSTR      (MSTR      ),
    .SCK_out   (SCK_out   ),
    .Data_out  (Data_out  ),
    .SS_master (SS_master ),
    .MOSI      (MOSI      ),
    .MISO      (MISO      ),
    .SCK       (SCK       ),
    .SS        (SS        ),
    .SS_slave  (SS_slave  ),
    .SCK_in    (SCK_in    ),
    .Data_in   (Data_in   )
);

//______________________________________________________________________________

wire M_Shift_clk;
wire M_Sample_clk;

SCK_control_master u_SCK_control_master(
    .M_BaudRate (M_BaudRate ),
    .CPOL       (CPOL       ),
    .CPHA       (CPHA       ),
    .idle       (idle       ),
    .SCK_out    (SCK_out    ),
    .Shift_clk  (M_Shift_clk),
    .Sample_clk (M_Sample_clk)
);

//______________________________________________________________________________

SPCR u_SPCR(
    .SPCR_in (SPCR_in ),
    .clk     (clk     ),
    .rst     (rst     ),
    .SPE     (SPE     ),
    .MSTR    (MSTR    ),
    .CPOL    (CPOL    ),
    .CPHA    (CPHA    ),
    .LSBFE   (LSBFE   )
);
//______________________________________________________________________________
SPISR u_SPISR(
    .clk      (clk      ),
    .rst      (rst      ),
    .en       (Reg_write_en),
    .SPISR_in (SPISR_in ),
    .SPIF     (SPIF     )
);
//______________________________________________________________________________
SPIBR u_SPIBR(
    .SPIBR_in (SPIBR_in ),
    .clk      (clk      ),
    .rst      (rst      ),
    .SPR      (SPR      )
);
//______________________________________________________________________________

SPDR u_SPDR(
    .SPDR_in  (SPDR_out  ),
    .clk      (clk      ),
    .rst      (rst      ),
    .en       (SPDR_wr_en),
    .SPDR_out (SPDR_in ),
    .SPDR_From_user(SPDR_From_user),
    .SPDR_rd_en(SPDR_rd_en)
);



endmodule
