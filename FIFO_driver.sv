package FIFO_driver_pkg;
import uvm_pkg::*;                /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"         /* Include UVM macros for convenience */

import FIFO_Sequence_item_pkg::*; /* Import FIFO sequence item package for transaction items */

    class FIFO_driver extends uvm_driver #(FIFO_seq_item);
        `uvm_component_utils(FIFO_driver) /* Register the class with UVM factory for object creation */

        virtual FIFO_if fifo_driver_vif;        /* Virtual interface for driver communication */
        FIFO_seq_item stim_seq_item;            /* Sequence item to hold stimulus data */

        /* 
        * Constructor: Initializes the FIFO_driver 
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_driver")
        * - parent: The parent component in the UVM hierarchy (default = null)
        */
        function new(string name = "FIFO_driver", uvm_component parent = null);
            super.new(name, parent); 
        endfunction 

        /* Build phase for driver configuration */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        /* Connect phase for linking the driver to its virtual interface */
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
        endfunction

        /* Run phase for driving the stimulus to the DUT */
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            forever begin
                stim_seq_item = FIFO_seq_item::type_id::create("stim_seq_item"); /* Create a new sequence item */
                seq_item_port.get_next_item(stim_seq_item); /* Get the next item from the sequencer */
                
                /* Drive the stimulus to the virtual interface */
                fifo_driver_vif.data_in     = stim_seq_item.data_in;
                fifo_driver_vif.rst_n       = stim_seq_item.rst_n;
                fifo_driver_vif.wr_en       = stim_seq_item.wr_en;
                fifo_driver_vif.rd_en       = stim_seq_item.rd_en;

                /* Wait for the falling edge of the clock */
                @(negedge fifo_driver_vif.clk); 
                /* Indicate that the item has been processed */
                seq_item_port.item_done();      
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH) /* Log the stimulus */
            end
        endtask 
    endclass //FIFO_driver extends uvm_driver
endpackage
