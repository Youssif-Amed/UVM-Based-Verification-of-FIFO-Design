package FIFO_Sequencer_pkg;
import uvm_pkg::*;              /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"       /* Include UVM macros for convenience */

import FIFO_Sequence_item_pkg::*;  /* Import the sequence item package to use FIFO_seq_item */

    /* Define the FIFO_Sequencer class to manage and control sequence execution */
    class FIFO_Sequencer extends uvm_sequencer #(FIFO_seq_item);
        `uvm_component_utils(FIFO_Sequencer)  /* Register the sequencer with the UVM factory */

        /* 
        * Constructor: Initializes the FIFO_Sequencer 
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_Sequencer")
        * - parent: The parent component in the UVM hierarchy (default = null)
        */
        function new(string name = "FIFO_Sequencer", uvm_component parent = null);
            super.new(name, parent);  
        endfunction  

    endclass  
endpackage 
