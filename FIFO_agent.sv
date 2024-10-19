package FIFO_agent_pkg;

import uvm_pkg::*;                /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"         /* Include UVM macros for convenience */

import FIFO_monitor_pkg::*;       /* Import FIFO monitor package for monitoring signals */
import FIFO_driver_pkg::*;        /* Import FIFO driver package for driving signals */
import FIFO_config_pkg::*;        /* Import FIFO configuration package for configuration settings */
import FIFO_Sequencer_pkg::*;     /* Import FIFO sequencer package for managing sequences */
import FIFO_Sequence_item_pkg::*; /* Import FIFO sequence item package for transaction items */

    class FIFO_agent extends uvm_agent;
        `uvm_component_utils(FIFO_agent) /* Register the class with UVM factory for object creation */
        
        FIFO_Sequencer sqr;                        /* Sequencer for generating sequences */
        FIFO_driver drv;                           /* Driver for sending transactions to the DUT */
        FIFO_monitor mon;                          /* Monitor for observing DUT behavior */
        FIFO_config fifo_agent_config;             /* Configuration object for the agent */
        uvm_analysis_port #(FIFO_seq_item) agt_ap; /* Analysis port for sending transaction data */

        /* 
        * Constructor: Initializes the FIFO_agent 
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_agent")
        * - parent: The parent component in the UVM hierarchy (default = null)
        */
        function new(string name = "FIFO_agent", uvm_component parent = null);
            super.new(name, parent); 
        endfunction //new()

        /* Build phase for creating components */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            if(!uvm_config_db #(FIFO_config)::get(this,"","FIFO_CONFIG",fifo_agent_config)) begin
                `uvm_fatal("build_phase", "Agent - Unable to get configuration object")
            end
            
            sqr = FIFO_Sequencer::type_id::create("sqr", this); /* Create sequencer */
            assert (sqr != null) else `uvm_fatal("Null sequencer", "sequencer not instantiated"); /* Check for null */
            
            drv = FIFO_driver::type_id::create("drv", this); /* Create driver */
            assert (drv != null) else `uvm_fatal("Null Driver", "Driver not instantiated"); /* Check for null */
            
            mon = FIFO_monitor::type_id::create("mon", this); /* Create monitor */
            assert (mon != null) else `uvm_fatal("Null Monitor", "Monitor not instantiated"); /* Check for null */
            
            agt_ap = new("agt_ap", this); /* Create analysis port */
        endfunction

        /* Connect phase for linking components */
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            drv.fifo_driver_vif  = fifo_agent_config.fifo_config_vif;   /* Connect driver virtual interface */
            mon.fifo_monitor_vif = fifo_agent_config.fifo_config_vif;   /* Connect monitor virtual interface */
            drv.seq_item_port.connect(sqr.seq_item_export);             /* Connect sequencer to driver */
            mon.mon_ap.connect(agt_ap);                                 /* Connect monitor to analysis port */
        endfunction
    endclass 
endpackage
