package FIFO_scoreboard_pkg;
import uvm_pkg::*;                  /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"           /* Include UVM macros for convenience */

import FIFO_Sequence_item_pkg::*;   /* Import FIFO sequence item package for handling sequence items */

// Class definition for FIFO scoreboard that extends uvm_scoreboard
class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard) /* Register the class with UVM factory for object creation */

    uvm_analysis_export #(FIFO_seq_item) sb_export;     /* Analysis export for sending sequence items to the scoreboard */
    uvm_tlm_analysis_fifo  #(FIFO_seq_item) sb_fifo;    /* TLM FIFO for holding sequence items */
    FIFO_seq_item seq_item_sb;                          /* Sequence item to hold incoming data from the DUT */

    /* Reference output signals for comparison */
    logic [FIFO_WIDTH-1:0] data_out_ref; 
    logic wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref; 
    
    /* Counters for error and correct transactions */
    int error_count   = 0;      /* Count of errors encountered */
    int correct_count = 0;      /* Count of correct transactions */

    /*-------------FIFO memory Copy---------------*/
    logic [FIFO_WIDTH-1:0] mem_copy [FIFO_DEPTH-1:0];   /* Memory copy to store FIFO data */
    logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr;              /* Write pointer for FIFO */
    logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr;              /* Read pointer for FIFO */
    logic [$clog2(FIFO_DEPTH):0] count;                 /* Count of items in the FIFO */

    /* Constructor for FIFO_scoreboard */
    function new(string name = "FIFO_scoreboard", uvm_component parent = null);
        super.new(name, parent); 
    endfunction 

    /* Build phase for initializing components */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);         /* Create analysis export */
        sb_fifo = new("sb_fifo", this);             /* Create analysis FIFO */
    endfunction

    /* Connect phase for establishing connections between components */
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export); /* Connect the analysis export to the FIFO */
    endfunction

    /* Run phase for monitoring transactions */
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);   /* Get the sequence item from the FIFO */
            ref_model(seq_item_sb);     /* Call the reference model for comparison */
            
            /* Compare each output signal with reference values and log any errors */
            if(seq_item_sb.data_out != data_out_ref)begin
                `uvm_error("run_phase", $sformatf("\nComparison failed, Transaction received by the DUT: %s While the reference out: %04h", seq_item_sb.convert2string(), data_out_ref));
                error_count++; /* Increment error count */
            end
            else if (seq_item_sb.wr_ack != wr_ack_ref)begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference wr_ack: %0b", seq_item_sb.convert2string(), wr_ack_ref));
                error_count++; /* Increment error count */
            end
            else if (seq_item_sb.overflow != overflow_ref)begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference overflow: %0b", seq_item_sb.convert2string(), overflow_ref));
                error_count++; /* Increment error count */
            end
            else if (seq_item_sb.underflow != underflow_ref)begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference underflow: %0b", seq_item_sb.convert2string(), underflow_ref));
                error_count++; /* Increment error count */
            end
            else if (seq_item_sb.full != full_ref)begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference full: %0b", seq_item_sb.convert2string(), full_ref));
                error_count++; /* Increment error count */
            end
            else if (seq_item_sb.empty != empty_ref)begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference empty: %0b", seq_item_sb.convert2string(), empty_ref));
                error_count++; /* Increment error count */
            end
            else if (seq_item_sb.almostfull != almostfull_ref)begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference almostfull: %0b", seq_item_sb.convert2string(), almostfull_ref));
                error_count++; /* Increment error count */
            end
            else if (seq_item_sb.almostempty != almostempty_ref)begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference almostempty: %0b", seq_item_sb.convert2string(), almostempty_ref));
                error_count++; /* Increment error count */
            end
            else begin
                `uvm_info("run_phase", $sformatf("Correct output signals: %s", seq_item_sb.convert2string()), UVM_HIGH);
                correct_count++; /* Increment correct count */
            end
        end
    endtask 

    /* Reference model task to simulate the FIFO behavior */
    task ref_model(FIFO_seq_item seq_item_ref);
        /* Reset conditions */
        if (!seq_item_ref.rst_n) begin
            wr_ptr = 0;             /* Reset write pointer */
            rd_ptr = 0;             /* Reset read pointer */
            count  = 0;             /* Reset item count */
            overflow_ref = 0;       /* Reset overflow flag */
            underflow_ref = 0;      /* Reset underflow flag */
        end else begin
            /* Write operation */
            if(seq_item_ref.wr_en && (count < FIFO_DEPTH)) begin
                mem_copy[wr_ptr] <= seq_item_ref.data_in;   /* Write data to memory */
                wr_ptr = wr_ptr + 1;                        /* Increment write pointer */
                wr_ack_ref = 1;                             /* Set write acknowledgment */
                overflow_ref = 0;                           /* Reset overflow flag */
            end else begin
                wr_ack_ref = 0; /* Clear write acknowledgment */
                if(seq_item_ref.wr_en && (count == FIFO_DEPTH))
                    overflow_ref = 1;   /* Set overflow flag if full */
                else
                    overflow_ref = 0;   /* Clear overflow flag */
            end

            /* Read operation */
            if(seq_item_ref.rd_en && (count != 0))begin
                data_out_ref = mem_copy[rd_ptr];    /* Read data from memory */
                rd_ptr = rd_ptr + 1;                /* Increment read pointer */
                underflow_ref = 0;                  /* Reset underflow flag */
            end else begin 
                if (seq_item_ref.rd_en && (count == 0))
                    underflow_ref = 1; /* Set underflow flag if empty */
                else
                    underflow_ref = 0; /* Clear underflow flag */
            end 

            /* Count operation to track the number of items */
            if(({seq_item_ref.wr_en, seq_item_ref.rd_en} == 2'b11) && (count == 0))
                count = count + 1; /* Increment count if both read and write enabled and count is zero */
            else if(({seq_item_ref.wr_en, seq_item_ref.rd_en} == 2'b11) && (count == FIFO_DEPTH))
                count = count - 1; /* Decrement count if both read and write enabled and count is full */
            else if (seq_item_ref.wr_en && count != FIFO_DEPTH)  
                count = count + 1; /* Increment count on write */
            else if (seq_item_ref.rd_en && count != 0)
                count = count - 1; /* Decrement count on read */
        end

        /* Update flags based on current count */
        full_ref        = (count == FIFO_DEPTH) ? 1 : 0; /* Set full flag if count equals FIFO_DEPTH */
        empty_ref       = (count == 0) ? 1 : 0; /* Set empty flag if count is zero */
        almostfull_ref  = (count == FIFO_DEPTH-1) ? 1 : 0; /* Set almost full flag if count is one less than FIFO_DEPTH */
        almostempty_ref = (count == 1) ? 1 : 0; /* Set almost empty flag if count is one */
    endtask

    /* Report phase for summarizing results */
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("Total successful transactions: %0d", correct_count), UVM_MEDIUM);
        `uvm_info("report_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM);
    endfunction
endclass // FIFO_scoreboard extends uvm_scoreboard
endpackage
