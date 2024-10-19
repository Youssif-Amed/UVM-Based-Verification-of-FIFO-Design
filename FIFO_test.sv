package FIFO_test_pkg;

import uvm_pkg::*;          /* Import UVM package */
`include "uvm_macros.svh"   /* Include UVM macros for UVM utilities */

import FIFO_env_pkg::*;     /* Import environment package */
import FIFO_config_pkg::*;  /* Import configuration package */
import FIFO_Sequences_pkg::*;   /* Import sequences package */

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)

        /* 
        * Constructor: Initializes the FIFO_test 
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_test")
        * - parent: The parent component in the UVM hierarchy (default = null)
        */
        function new(string name = "FIFO_test", uvm_component parent  = null);
            super.new(name, parent);
        endfunction //new()

        FIFO_env        env;                    /* Environment for the FIFO */
        FIFO_config     fifo_test_config_obj;   /* Configuration object for the FIFO */
        FIFO_main_seq   main_seq;               /* Main sequence for testing */
        FIFO_reset_seq  reset_seq;              /* Reset sequence for testing */
        FIFO_read_seq   rd_seq;                 /* Read sequence for testing */
        FIFO_write_seq  wr_seq;                 /* Write sequence for testing */

        /* Build phase for creating components */
        function void  build_phase(uvm_phase phase);
            super.build_phase(phase);
            fifo_test_config_obj =  FIFO_config::type_id::create("fifo_test_config_obj"); /* Create configuration object */
            env       = FIFO_env::type_id::create("env",this);                            /* Create FIFO environment */
            main_seq  = FIFO_main_seq::type_id::create("main_seq",this);                  /* Create main sequence */
            reset_seq = FIFO_reset_seq::type_id::create("reset_seq",this);                /* Create reset sequence */
            rd_seq    = FIFO_read_seq::type_id::create("read_seq",this);                  /* Create read sequence */
            wr_seq = FIFO_write_seq::type_id::create("write_seq",this);                   /* Create write sequence */

            /* Check if FIFO interface is set in configuration database */
            if(!uvm_config_db #(virtual FIFO_if)::get(this,"","FIFO_IF",fifo_test_config_obj.fifo_config_vif))begin
                `uvm_fatal("build_phase","FIFO_IF is not set for the test")
            end
            /* Set FIFO configuration in the database */
            uvm_config_db #(FIFO_config)::set(this,"*","FIFO_CONFIG",fifo_test_config_obj);
        endfunction

        /* Run phase for executing the test */
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this); /* Raise objection to keep the phase alive */

                // Reset sequence
                `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
                    reset_seq.start(env.agt.sqr); /* Start reset sequence */
                `uvm_info("run_phase", "Reset Deasserted", UVM_LOW)

                // Main sequence
                `uvm_info("run_phase", "main Stimulus Begins", UVM_LOW)
                    main_seq.start(env.agt.sqr); /* Start main stimulus sequence */
                `uvm_info("run_phase", "Stimulus End", UVM_LOW)
            
                // write ONLY into the memory
                `uvm_info("run_phase", "Write Stimulus Begins", UVM_LOW)
                    wr_seq.start(env.agt.sqr); /* Start main stimulus sequence */
                `uvm_info("run_phase", "Write Stimulus End", UVM_LOW)

                // read ONLY into the memory
                `uvm_info("run_phase", "Read Stimulus Begins", UVM_LOW)
                    rd_seq.start(env.agt.sqr); /* Start main stimulus sequence */
                `uvm_info("run_phase", "Read Stimulus End", UVM_LOW)

                // Main sequence
                `uvm_info("run_phase", "Main Stimulus Begins", UVM_LOW)
                    main_seq.start(env.agt.sqr); /* Start main stimulus sequence */
                `uvm_info("run_phase", "Main Stimulus End", UVM_LOW)

            phase.drop_objection(this); /* Drop objection to end the phase */
        endtask
    endclass

endpackage
