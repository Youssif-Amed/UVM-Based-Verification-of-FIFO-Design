package FIFO_Sequence_item_pkg;
import uvm_pkg::*;          /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"   /* Include UVM macros for convenience */

/*------------------------- Parameters -------------------------*/
parameter FIFO_WIDTH = 16;  /* Width of the FIFO data */
parameter FIFO_DEPTH = 8;   /* Depth of the FIFO */

    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)  /* Register the class with the UVM factory */

        /*------------------------- Input Signals -------------------------*/
        rand logic [FIFO_WIDTH-1:0] data_in;  /* Data input to the FIFO */
        rand logic rst_n;                     /* Active-low reset signal */
        rand logic wr_en;                     /* Write enable signal */
        rand logic rd_en;                     /* Read enable signal */

        /*------------------------ Output Signals -------------------------*/
        logic [FIFO_WIDTH-1:0] data_out;  /* Data output from the FIFO */
        logic wr_ack;                     /* Acknowledge signal for write operations */
        logic full;                       /* Indicates if the FIFO is full */
        logic empty;                      /* Indicates if the FIFO is empty */
        logic almostfull;                 /* Indicates the FIFO is nearly full */
        logic almostempty;                /* Indicates the FIFO is nearly empty */
        logic overflow;                   /* Indicates an overflow condition */
        logic underflow;                  /* Indicates an underflow condition */

        /*------------------- Constrains Distribution ---------------------*/
        int WR_EN_ON_DIST,RD_EN_ON_DIST;

        /* 
        * Constructor: Initializes the FIFO_seq_item
        * Parameters:
        * - name: The name of the sequencer instance (default = "FIFO_seq_item")
        */
        function new(string name = "FIFO_seq_item");
            super.new(name);  
        endfunction 

        /* Converts the sequence item into a string for logging/debugging */
        function string convert2string();
            return $sformatf(
                "%s reset = %01b, wr_en = %01b, rd_en = %1b, data_in = %4h, data_out = %03h, wr_ack = %01b, overflow = %01b, underflow = %01b, full = %01b, empty = %01b, almostempty = %01b, almostfull = %01b",
                super.convert2string(), rst_n, wr_en, rd_en, data_in, data_out, wr_ack, overflow, underflow, full, empty, almostempty, almostfull
            );
        endfunction 

        /* Converts the stimulus signals into a string format */
        function string convert2string_stimulus();
            return $sformatf(
                "reset = %01b, wr_en = %01b, rd_en = %1b, data_in = %4h",
                rst_n, wr_en, rd_en, data_in
            );
        endfunction 

        /*------------------------- Constrains -------------------------*/
        /*--------------Reset Constrains--------------*/
        constraint reset_const{
           soft rst_n dist { 1:= 90 , 0:=10 };
        }

        /*--------------Wr_en Constrains--------------*/
        constraint write_en_const{
            wr_en dist { 1:=WR_EN_ON_DIST , 0:=100-WR_EN_ON_DIST };
        }

        /*--------------rd_en Constrains--------------*/
        constraint read_en_const{
            rd_en dist { 1:=RD_EN_ON_DIST , 0:=(100-RD_EN_ON_DIST) };
        }
    endclass 
endpackage 
