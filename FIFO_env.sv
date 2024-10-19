package FIFO_env_pkg;

import uvm_pkg::*;                 /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"          /* Include UVM macros for convenience */

import FIFO_driver_pkg::*;         /* Import FIFO driver package for driving signals */
import FIFO_cov_collector_pkg::*;  /* Import FIFO coverage package for coverage metrics */
import FIFO_scoreboard_pkg::*;     /* Import FIFO scoreboard package for verification */
import FIFO_agent_pkg::*;          /* Import FIFO agent package for handling transaction generation */

    class FIFO_env extends uvm_env;
        `uvm_component_utils(FIFO_env)

        FIFO_agent        agt;          /* FIFO agent for driving and monitoring */
        FIFO_scoreboard   sb;           /* Scoreboard for checking correctness */
        FIFO_cov_collec   cov;          /* Coverage collector for the FIFO */

        /* 
        * Constructor: Initializes the FIFO_env 
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_env")
        * - parent: The parent component in the UVM hierarchy (default = null)
        */
        function new(string name = "FIFO_env", uvm_component parent = null);
            super.new(name, parent);    
        endfunction 

        /* Build phase for creating components */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt = FIFO_agent::type_id::create("agt",this);       /* Create FIFO agent */
            sb  = FIFO_scoreboard::type_id::create("sb",this);   /* Create scoreboard */
            cov = FIFO_cov_collec::type_id::create("cov",this);  /* Create coverage collector */
        endfunction

        /* Connect phase for linking components */
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);   /* Connect agent to scoreboard */
            agt.agt_ap.connect(cov.cov_export); /* Connect agent to coverage collector */
        endfunction
    endclass 
endpackage
