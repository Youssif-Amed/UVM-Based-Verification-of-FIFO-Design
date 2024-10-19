package FIFO_monitor_pkg;
import uvm_pkg::*;                /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"         /* Include UVM macros for convenience */

import FIFO_Sequence_item_pkg::*; /* Import FIFO sequence item package for handling sequence items */

    class FIFO_monitor extends uvm_monitor;
        `uvm_component_utils(FIFO_monitor) /* Register the class with UVM factory for object creation */
        
        virtual FIFO_if fifo_monitor_vif;          /* Virtual interface for monitor communication */
        FIFO_seq_item   rsp_seq_item;              /* Sequence item to hold response data */
        uvm_analysis_port #(FIFO_seq_item) mon_ap; /* Analysis port for sending data to analysis components */

        /* 
        * Constructor: Initializes the FIFO_monitor 
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_monitor")
        * - parent: The parent component in the UVM hierarchy (default = null)
        */
        function new(string name = "FIFO_monitor", uvm_component parent = null);
            super.new(name, parent); 
        endfunction 

        /* Build phase for initializing the monitor */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this); /* Create a new analysis port */
        endfunction

        /* Run phase for monitoring the DUT signals */
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            forever begin
                rsp_seq_item = FIFO_seq_item::type_id::create("rsp_seq_item"); /* Create a new response sequence item */

                /* Wait for the falling edge of the clock */
                @(negedge fifo_monitor_vif.clk); 
                
                /* Capture the signals from the virtual interface into the sequence item */
                rsp_seq_item.data_in     = fifo_monitor_vif.data_in;
                rsp_seq_item.rst_n       = fifo_monitor_vif.rst_n;
                rsp_seq_item.wr_en       = fifo_monitor_vif.wr_en;
                rsp_seq_item.rd_en       = fifo_monitor_vif.rd_en;
                rsp_seq_item.data_out    = fifo_monitor_vif.data_out;
                rsp_seq_item.wr_ack      = fifo_monitor_vif.wr_ack;
                rsp_seq_item.overflow    = fifo_monitor_vif.overflow;
                rsp_seq_item.underflow   = fifo_monitor_vif.underflow;
                rsp_seq_item.full        = fifo_monitor_vif.full;
                rsp_seq_item.empty       = fifo_monitor_vif.empty;
                rsp_seq_item.almostempty = fifo_monitor_vif.almostempty;
                rsp_seq_item.almostfull  = fifo_monitor_vif.almostfull;
                /* Write the captured sequence item to the analysis port */
                mon_ap.write(rsp_seq_item); 
                
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH) /* Log the captured data */
            end
        endtask 
    endclass //FIFO_monitor extends uvm_monitor
endpackage
