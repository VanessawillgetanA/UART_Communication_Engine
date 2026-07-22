# UART Communication Engine

A UART (Universal Asynchronous Receiver/Transmitter) implemented in Verilog HDL using a Finite State Machine (FSM).

This project was created as part of my journey learning digital hardware design. The goal was to understand how hardware is described using Verilog while implementing a common communication protocol from scratch.

## Project Overview

This UART transmitter accepts an 8-bit input and serializes the data into a standard UART frame consisting of:

- 1 Start Bit
- 8 Data Bits (Least Significant Bit first)
- 1 Stop Bit

The design is controlled by a Finite State Machine (FSM) and was verified through simulation using **Icarus Verilog** and **GTKWave**.

## Features

- Verilog HDL implementation
- Finite State Machine (FSM)
- Synchronous reset
- Busy signal during transmission
- Data latching before transmission
- LSB-first serial transmission
- Simulation testbench included

## State Machine

The transmitter progresses through the following states (assuming the possiblity of staying on reset):

```
        +------+ <--
        | IDLE |    |
        +------+ ---
            |
            v
       +---------+
       | START   |
       +---------+
            |
            v
        +-------+
        | DATA  |
        +-------+
            |
            v
        +-------+
        | STOP  |
        +-------+
            |
            +-----------> IDLE
```

## UART Frame Format

```
Idle    Start      Data Bits               Stop

  1  ---> 0 ---> b0 b1 b2 b3 b4 b5 b6 b7 ---> 1
```

Data is transmitted **Least Significant Bit (LSB) first**, following the UART protocol.

## Simulation

The design was compiled and simulated using **Icarus Verilog**.

Compile:

```bash
iverilog -o uart_tx uart.v uart_tb.v
```

Run:

```bash
vvp uart_tx
```

View waveform:

```bash
gtkwave uart_tx.vcd
```

## Simulation Results

The command prompt output confirms successful compilation and simulation. The finite state machine transitions through the expected sequence:

- IDLE
- START
- DATA
- STOP
- IDLE

## Waveform Verification

GTKWave was used to verify the UART transmission.

The waveform confirms:

- Correct state transitions
- Start bit generation
- 8-bit serial transmission
- Stop bit generation
- Busy signal behavior

## Concepts Learned

Through this project I gained experience with:

- Verilog HDL
- Hardware Description Languages (HDLs)
- Sequential Logic
- Registers
- Finite State Machines (FSMs)
- UART Communication
- Digital Simulation
- Testbench Development
- Waveform Analysis using GTKWave

## Future Improvements

Potential future enhancements include:

- Configurable baud rate
- UART receiver implementation
- Parity bit support
- Parameterized data width
- FPGA implementation using Vivado

## Learning Notes

This project emphasizes understanding the design process rather than using pre-built IP cores. It represents one of my first complete digital hardware projects and serves as a foundation for future FPGA and digital communication designs.

## Author

**Vanessa**

Designed and implemented as part of a personal digital hardware learning roadmap focused on Verilog HDL, FPGA development, and quantum hardware engineering.

I strive to approach each learning project using professional engineering practices, including version control with GitHub, simulation and verification, clear documentation, and iterative design improvements.

## Acknowledgements

Special thanks to **ChatGPT (OpenAI)** for mentorship, technical guidance, and code review throughout this project. Discussions emphasized understanding engineering concepts and design decisions while encouraging industry-style development practices.
