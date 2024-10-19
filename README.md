# UVM Based Verification Of Synchronous FIFO Design

## Project Overview
This project focuses on verifying a **Synchronous FIFO Design** using the **Universal Verification Methodology (UVM)**. A FIFO (First-In, First-Out) buffer is critical in digital systems for managing sequential data, ensuring that data is read in the same order it was written. This makes it highly suitable for timing-sensitive applications like data pipelines, communication protocols, and buffering systems.

The goal of this project is to verify the **correctness**, **functionality**, and **robustness** of the FIFO design by identifying and resolving potential bugs.

## Key Features of the FIFO Design

- **FIFO_WIDTH**: 16-bit (default)
- **FIFO_DEPTH**: 8 entries (default)

### Signals Verified:
- **data_in**: Input data bus
- **wr_en**: Write enable signal
- **rd_en**: Read enable signal
- **clk**: Clock signal for synchronization
- **rst_n**: Asynchronous reset
- **data_out**: Output data bus
- **full, almostfull**: FIFO status indicators (full/near full)
- **empty, almostempty**: FIFO status indicators (empty/near empty)
- **overflow, underflow**: Error handling for invalid write/read operations
- **wr_ack**: Acknowledge successful write operations

## UVM-based Verification Flow
The verification environment is structured using UVM methodology, leveraging constrained random stimulus and coverage-driven techniques to ensure thorough testing.

### UVM Components:
- **Driver**: Drives input stimulus to the Design Under Test (DUT) based on sequence instructions.
- **Monitor**: Observes and records transactions from DUT signals, generating information for analysis.
- **Agent**: Combines the driver and monitor, responsible for controlling and monitoring the communication with the DUT.
- **Scoreboard**: Compares DUT output with a reference model to check for correctness.
- **Sequence**: Define the stimulus applied to the DUT, ensuring various modes of operation are verified with constraints.
  - *Write_Only_Sequence*: Focuses solely on write operations to validate how the FIFO behaves when data is being written under various conditions.
  - *Read_Only_Sequence*: Dedicated to verifying the read operations, ensuring data is read correctly from the FIFO without encountering underflow or data loss.
  - *Write_Read_Sequence*: Tests the combination of both read and write operations, ensuring that simultaneous operations work smoothly, and the FIFO's status flags (full, empty, etc.) respond correctly.
- **Coverage Collector**: Functional coverage tracks whether critical features and corner cases are tested, ensuring thorough validation.

## Functional Coverage
Key operational scenarios were monitored during the verification process, including:

- **Overflow/Underflow Conditions**: Ensuring correct handling of invalid writes and reads when FIFO is full or empty.
- **Almost Full/Almost Empty States**: Verifying system responses when nearing capacity or emptiness.
- **Read/Write Command Operation**: Testing the FIFO's correct response to read and write operations under different conditions.

## Results
The verification environment thoroughly tested the FIFO design, identifying and resolving bugs related to data flow and control signals. The design was confirmed to be robust and ready for real-world applications such as data pipelines and communication protocols.

## Special Thanks
A big thank you to **Eng. Kareem Waseem** for his invaluable guidance throughout this project.
