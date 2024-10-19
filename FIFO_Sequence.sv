package FIFO_Sequences_pkg;

import uvm_pkg::*;                /* Import UVM package for Universal Verification Methodology */
`include "uvm_macros.svh"         /* Include UVM macros for convenience */

import FIFO_Sequence_item_pkg::*; /* Import FIFO sequence item package for transaction items */

    /* 
    * Description: 
    *  - A sequence to simulate the FIFO reset operation. 
    *  - It creates sequence items with reset signals set.
    */
    class FIFO_reset_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_reset_seq) /* Register with the UVM factory */

        FIFO_seq_item rst_seq_item;       /* Reset operation item */

        /* Constructor: Initializes the sequence with an optional name */
        function new(string name = "FIFO_reset_seq");
            super.new(name);
        endfunction

        /* Generates 5 reset items with initialized signal values */
        task body();
            rst_seq_item = FIFO_seq_item::type_id::create("rst_seq_item");
            repeat(5) begin
                start_item(rst_seq_item);
                rst_seq_item.data_in = $random;     /* Random data input */
                rst_seq_item.rst_n   = 0;           /* Active-low reset */
                rst_seq_item.wr_en   = 0;           /* Disable write */
                rst_seq_item.rd_en   = 0;           /* Disable read */
                finish_item(rst_seq_item);
            end
        endtask
    endclass

    /* 
    * Description: 
    *  - A sequence to generate 1000 random FIFO operations.
    */
    class FIFO_main_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_main_seq) /* Register with the UVM factory */

        FIFO_seq_item main_seq_item;     /* Main operation item */

        /* Constructor: Initializes the sequence with an optional name */
        function new(string name = "FIFO_main_seq");
            super.new(name);
        endfunction

        /* Generates 1000 random FIFO operations */
        task body();
            repeat(2000) begin
                main_seq_item = FIFO_seq_item::type_id::create("main_seq_item");
                start_item(main_seq_item);
                main_seq_item.WR_EN_ON_DIST = 70;  /* 70% chance of write enable */
                main_seq_item.RD_EN_ON_DIST = 30;  /* 30% chance of read enable */
                assert(main_seq_item.randomize()); /* Ensure successful randomization */
                finish_item(main_seq_item);
            end
        endtask
    endclass

    /* 
    * Description: 
    *  - A sequence to simulate 50 write operations. 
    *  - Write is always enabled, and read is disabled.
    */
    class FIFO_write_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_write_seq) /* Register with the UVM factory */

        FIFO_seq_item wr_seq_item;        /* Write operation item */

        /* Constructor: Initializes the sequence with an optional name */
        function new(string name = "FIFO_write_seq");
            super.new(name);
        endfunction

        /* Generates 200 write operations */
        task body();
            repeat(200) begin
                wr_seq_item = FIFO_seq_item::type_id::create("wr_seq_item");
                start_item(wr_seq_item);
                wr_seq_item.WR_EN_ON_DIST = 100;   /* Write is always enabled */
                wr_seq_item.RD_EN_ON_DIST = 0;     /* Read is always disabled */
                assert(wr_seq_item.randomize() with {rst_n == 1;}); 
                finish_item(wr_seq_item);
            end
        endtask
    endclass

    /* 
    * Description: 
    *  - A sequence to simulate 50 read operations. 
    *  - Read is always enabled, and write is disabled.
    */
    class FIFO_read_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_read_seq) /* Register with the UVM factory */

        FIFO_seq_item rd_seq_item;       /* Read operation item */

        /* Constructor: Initializes the sequence with an optional name */
        function new(string name = "FIFO_read_seq");
            super.new(name);
        endfunction

        /* Generates 200 read operations */
        task body();
            repeat(200) begin
                rd_seq_item = FIFO_seq_item::type_id::create("rd_seq_item");
                start_item(rd_seq_item);
                rd_seq_item.WR_EN_ON_DIST = 0;      /* Write is always disabled */
                rd_seq_item.RD_EN_ON_DIST = 100;    /* Read is always enabled */
                assert(rd_seq_item.randomize() with {rst_n == 1;});
                finish_item(rd_seq_item);
            end
        endtask
    endclass
endpackage
