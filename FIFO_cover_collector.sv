package FIFO_cov_collector_pkg;
import uvm_pkg::*;              /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"       /* Include UVM macros for convenience */

import FIFO_Sequence_item_pkg::*;  /* Import the sequence item package */

    /* 
    * FIFO_cov_collec: Coverage collector class 
    * - Collects and analyzes coverage data for FIFO signals during simulation.
    */
    class FIFO_cov_collec extends uvm_component;
        `uvm_component_utils(FIFO_cov_collec)             /* Register the component with the UVM factory */

        uvm_analysis_export   #(FIFO_seq_item) cov_export;  /* Export analysis transactions */
        uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;  /* FIFO to store sequence items */
        FIFO_seq_item seq_item_cov;                       /* Sequence item to hold coverage data */

        /*------------------------- Covergroup -------------------------*/
        /* 
        * FIFO_COV: Covergroup for tracking and analyzing FIFO operations 
        * - Monitors multiple signals like write enable, read enable, and flags.
        */
        covergroup FIFO_COV;

            /* Coverpoint for write enable signal */
            wr_en_cp: coverpoint seq_item_cov.wr_en {
                bins wr_en_0 = {0};  /* Write enable = 0 */
                bins wr_en_1 = {1};  /* Write enable = 1 */
            }

            /* Coverpoint for read enable signal */
            rd_en_cp: coverpoint seq_item_cov.rd_en {
                bins rd_en_0 = {0};  /* Read enable = 0 */
                bins rd_en_1 = {1};  /* Read enable = 1 */
            }

            /* Coverpoint for write acknowledge signal */
            wr_ack_cp: coverpoint seq_item_cov.wr_ack {
                bins wr_ack_0 = {0};  /* Write acknowledgment = 0 */
                bins wr_ack_1 = {1};  /* Write acknowledgment = 1 */
            }

            /* Coverpoint for overflow condition */
            overflow_cp: coverpoint seq_item_cov.overflow {
                bins overflow_0 = {0};  /* No overflow */
                bins overflow_1 = {1};  /* Overflow occurred */
            }

            /* Coverpoint for underflow condition */
            underflow_cp: coverpoint seq_item_cov.underflow {
                bins underflow_0 = {0};  /* No underflow */
                bins underflow_1 = {1};  /* Underflow occurred */
            }

            /* Coverpoint for full flag */
            full_cp: coverpoint seq_item_cov.full {
                bins full_0 = {0};  /* FIFO is not full */
                bins full_1 = {1};  /* FIFO is full */
            }

            /* Coverpoint for almost full flag */
            almostfull_cp: coverpoint seq_item_cov.almostfull {
                bins almostfull_0 = {0};  /* FIFO is not almost full */
                bins almostfull_1 = {1};  /* FIFO is almost full */
            }

            /* Coverpoint for empty flag */
            empty_cp: coverpoint seq_item_cov.empty {
                bins empty_0 = {0};  /* FIFO is not empty */
                bins empty_1 = {1};  /* FIFO is empty */
            }

            /* Coverpoint for almost empty flag */
            almostempty_cp: coverpoint seq_item_cov.almostempty {
                bins almostempty_0 = {0};  /* FIFO is not almost empty */
                bins almostempty_1 = {1};  /* FIFO is almost empty */
            }

            /* Cross-coverage between write, read, and write acknowledgment signals */
            wr_ack_cross: cross wr_en_cp, rd_en_cp, wr_ack_cp;

            /* Cross-coverage for overflow scenarios */
            overflow_cross: cross wr_en_cp, rd_en_cp, overflow_cp;

            /* Cross-coverage for underflow scenarios */
            underflow_cross: cross wr_en_cp, rd_en_cp, underflow_cp;

            /* Cross-coverage for full flag scenarios */
            full_cross: cross wr_en_cp, rd_en_cp, full_cp;

            /* Cross-coverage for almost full flag scenarios */
            almostfull_cross: cross wr_en_cp, rd_en_cp, almostfull_cp;

            /* Cross-coverage for empty flag scenarios */
            empty_cross: cross wr_en_cp, rd_en_cp, empty_cp;

            /* Cross-coverage for almost empty flag scenarios */
            almostempty_cross: cross wr_en_cp, rd_en_cp, almostempty_cp;
        endgroup  

        /* 
        * Constructor: Initializes the FIFO_cov_collec 
        * - Sets up the covergroup and initializes the parent component.
        */
        function new(string name = "FIFO_cov_collec", uvm_component parent = null);
            super.new(name, parent);  /* Call the parent class constructor */
            FIFO_COV = new();         /* Initialize the covergroup */
        endfunction  /* new() */

        /* 
        * build_phase: Phase to build and initialize components 
        * - Creates sequence item and analysis ports.
        */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);  /* Call the parent build phase */
            seq_item_cov = FIFO_seq_item::type_id::create("seq_item_cov");  /* Create sequence item */
            cov_export = new("cov_export", this);                           /* Initialize export port */
            cov_fifo = new("cov_fifo", this);                               /* Initialize analysis FIFO */
        endfunction  

        /* 
        * connect_phase: Phase to connect analysis ports 
        * - Connects the export port to the FIFO’s analysis export.
        */
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);  /* Call the parent connect phase */
            cov_export.connect(cov_fifo.analysis_export);  /* Connect export to FIFO */
        endfunction  

        /* 
        * run_phase: Phase to collect and sample coverage data 
        * - Runs continuously, sampling the covergroup on each transaction.
        */
        task run_phase(uvm_phase phase);
            super.run_phase(phase);  /* Call the parent run phase */

            /* Continuously collect coverage data */
            forever begin  
                /* Retrieve sequence item from FIFO */
                cov_fifo.get(seq_item_cov); 

                /* Sample the covergroup */ 
                FIFO_COV.sample();  
            end
        endtask 
    endclass  
endpackage  
