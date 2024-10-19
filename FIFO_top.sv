import uvm_pkg::*;               /* Import UVM package */
`include "uvm_macros.svh"        /* Include UVM macros for UVM utilities */

import FIFO_test_pkg::*;         /* Import the test package where your test class is defined */

module top ();
    bit clk;                     /* Define a clock signal for the DUT and testbench */

    /* Clock generation logic: toggle the clock every 1ns */
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;      
        end
    end

    /* Instantiate the FIFO interface */
    FIFO_if FIFOif (clk);

    /* Instantiate the FIFO DUT and connect signals from the interface */
    FIFO DUT (
        .clk(clk), 
        .data_in(FIFOif.data_in), 
        .wr_en(FIFOif.wr_en), 
        .rd_en(FIFOif.rd_en), 
        .rst_n(FIFOif.rst_n), 
        .full(FIFOif.full), 
        .empty(FIFOif.empty), 
        .almostempty(FIFOif.almostempty), 
        .almostfull(FIFOif.almostfull), 
        .wr_ack(FIFOif.wr_ack), 
        .overflow(FIFOif.overflow), 
        .underflow(FIFOif.underflow), 
        .data_out(FIFOif.data_out)
    );

    /* 
       Bind assertions to the FIFO instance to check properties in real-time.
       This allows real-time checking of properties through SystemVerilog Assertions (SVA).
    */
    bind FIFO FIFO_SVA FIFO_DUT_SVA(
                                        .clk(clk), 
                                        .rst_n(DUT.rst_n), 
                                        .data_in(DUT.data_in), 
                                        .wr_en(DUT.wr_en), 
                                        .rd_en(DUT.rd_en), 
                                        .data_out(DUT.data_out),
                                        .wr_ack(DUT.wr_ack), 
                                        .overflow(DUT.overflow), 
                                        .underflow(DUT.underflow), 
                                        .full(DUT.full), 
                                        .empty(DUT.empty), 
                                        .almostfull(DUT.almostfull), 
                                        .almostempty(DUT.almostempty),
                                        .count(DUT.count)
                                   );

    /* Initial block to configure UVM and start the test */
    initial begin
        /* 
           Set the virtual interface in UVM configuration database.
           This allows the UVM Test environment to access the FIFO interface.
        */
        uvm_config_db #(virtual FIFO_if)::set(null,"uvm_test_top","FIFO_IF",FIFOif);

        /* Run the UVM test defined in the FIFO_test_pkg */
        run_test("FIFO_test");
    end
endmodule
