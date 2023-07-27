# SPI Master/Slave RTL Implementation

SPI is a synchronous serial communication protocol used primarily in embedded systems for short distance wired communications.
It was developed by Motorola in the mid-1980s. It is a full duplex communication where the master and slave can exchange data in the same time. It is a single master multi slave protocol where a master can select which slave he wants to communicate with. 

SPI has four main signals as shown in the figure below.
<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/0fba77b5-3d36-4686-b72a-7b35bc5884a4"
  style="width:500px">
</p>

<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/fe805ef6-a95c-4037-807b-7d61ee90f069"
  style="width:500px">
</p>

The master is responsible for generating the clock in which the whole system works on and it selects which slave he will communicate with.
# Architecture
With regards to the architecture, we built our own architecture as shown in the figure below.

<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/d805f039-1717-4691-912f-4407ac0f89b1">
</p>

## Modes of Operation
SPI can work with 4 modes of operations according to 2 signals which are CPOL and CPHA as shown in the figure below. The choice of which mode depends on which type of slave we are communicating with.

<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/b7f75680-9db0-4f02-8d0c-be2fd2601513"
  style="width:600px">
</p>

## Detailed Block Explanation

### Registers

We have 4 main registers which are:

1.	`SPI Control register (SPICR):` This register is mainly responsible for enabling the SPI, controlling whether it is master or slave and controlling the mode of operation if it is a master.

2.	`SPI Data register (SPIDR):` This register contains the data which needed to be sent and also received data.

3.	`SPI BaudRate register (SPIBR):` It is responsible for the SPR signal which is the prescalar the is used to calculate the value the clock is divided by.

4.	`SPI Status register (SPISR):` This register raises a flag when the data is successfully sent.

### BaudRate_generator

This module divides the system clock frequency by the Divisor which can be calculated from SPR bits from the SPIBR register.

### SCK_control Master and Slave

This block has an inputs of CPOL and CPHA and then it generates the output clock on which the SPI sends data with. It also generates 2 signals which are Shift clock and Sample clock. The Master Block takes the M_BaudRate Signal and outputs the SCK_out. Whule the Slave Block takes the SCK_in and outputs the S_BaudRate signal.

1.	`Shift clock` is when the data is Driven to output.

2.	`Sample clock` is when the master/slave samples the data which is already driven by other device.

### Master_Slave_select

Depending on the MSTR signal coming from the SPDR register, this block selects whether the Shift and Sample clocks produced by SCK_control_master or SCK_control_slave is propagated into the Shifter. This Block also produces the control_BaudRate which is the main count signal of the controller. 

### Shifter

The shifter block is the block which takes the shift and sample clocks from the Master_slave_select to Drive the data to be sent and sample the recieved data.

### Master/Slave Controller

<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/0eced881-bbb7-4ac8-bb79-dfe5aae984bf"
  style="width:600px">
</p>

1. `Start State` is a state used for synchronization between the Slave and Master so that the idle state starts at the same edge.
2. `Idle State` is a state signaling the start of operation. In this state, data in the SPDR is recieved from the user and propagated into the Shifter Shift register, and the SPIF is set to zero.
3. `Run State` is the state of sending and recieving data. The bit counter starts to be enabled and counts from 0 to 7 a total of 8 counts. The shifter is enabled as well in this state.
4. `Update State` signals finishing the sending/recieving of data. The data from the shifter is transferred to the SPDR to be taken by the user. The next state from here returns to the Idle state since the Master and Slave is already synchronized.

# TestBench

A simple testbench was created consisting of a few directed tests where a value of the SPDR is set at periodic intervals and then it is checked to see whether the data recieved at the corresponding device is the same. 

<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/9ef36c32-8ff8-4aad-be68-c9f38aaaf6fd"
  style="width:900px">
</p>

<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/c7f00aa7-ed22-4cbd-b899-3ed4083b4a16"
  style="width:600px">
</p>

# Synthesis
<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/ac321c30-1d18-4de1-89d3-92556b07d85f"
  style="width:600px">
</p>
<p align="center">
<img
  src="https://github.com/A-Hares/SPI-NTI-GP/assets/139650137/598713b0-9a3b-42ba-a122-b4dc2ce429ea"
  style="width:600px">
</p>

