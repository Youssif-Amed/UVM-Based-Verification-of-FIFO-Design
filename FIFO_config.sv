package FIFO_config_pkg;
import uvm_pkg::*;              /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"       /* Include UVM macros for convenience */

    class FIFO_config extends uvm_object;
        `uvm_object_utils(FIFO_config)   /* Register the class with UVM factory for object creation */
        
        virtual FIFO_if fifo_config_vif; /* Virtual interface for FIFO configuration */

        /* 
        * Constructor: Initializes the FIFO_config 
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_config")
        * - parent: The parent component in the UVM hierarchy (default = null)
        */
        function new(string name = "FIFO_config");
            super.new(name); 
        endfunction 
    endclass //FIFO_config extends uvm_object
endpackage
