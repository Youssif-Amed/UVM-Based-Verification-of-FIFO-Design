module FIFO_SVA #(parameter FIFO_WIDTH = 16, FIFO_DEPTH = 8)
    (
        input logic clk, 
        input logic rst_n, 
        input logic [FIFO_WIDTH-1:0] data_in, 
        input logic wr_en, 
        input logic rd_en, 
        input logic [FIFO_WIDTH-1:0] data_out,
        input logic wr_ack, 
        input logic overflow, 
        input logic underflow, 
        input logic full, 
        input logic empty, 
        input logic almostfull, 
        input logic almostempty,
        input logic [$clog2(FIFO_DEPTH):0] count
    );
    /*---------------------------Assertions---------------------------*/
    /*---------------------Async_assertions----------------------*/
    always_comb begin : Async_assertion
        /*----------full_assertion---------*/
        if(count == FIFO_DEPTH)begin
			full_flag_assert: assert final(full == 1'b1)
						else $error("full flag assertion failed ");
			full_flag_cover : cover (full == 1'b1);
        end 
        /*----------empty_assertion---------*/
        else if(count == 4'b0)
            begin
                empty_flag_assert: assert final(empty == 1'b1)
                                else $error("empty flag assertion failed ");
                empty_flag_cover:  cover (empty == 1'b1);
            end
        /*-------almostfull_assertion-------*/
        else if(count == FIFO_DEPTH-1)
			begin
                almostfull_flag_assert: assert final(almostfull == 1'b1)
                            else $error("almostfull flag assertion failed ");
                almostfull_flag_cover:  cover (almostfull == 1'b1); 
            end
        /*-------almostempty_assertion------*/
        else if(count == 4'b0001)
			begin
                almostempty_flag_assert: assert final(almostempty == 1'b1)
                            else $error("almostempty flag assertion failed ");
                almostempty_flag_cover:  cover (almostempty == 1'b1); 
            end
    end

    /*---------------------Sync_assertions-----------------------*/
    /*------------overflow_assertion------------*/
    property overflow_seq;
        @(posedge clk) disable iff(!rst_n) ((full & wr_en) |-> @(negedge clk) (overflow == 1'b1));
    endproperty
    Overflow_flag_assert: assert property (overflow_seq)
                else $error("Overflow flag assertion failed ");
    Overflow_flag_cover:  cover property (overflow_seq);

    /*------------underflow_assertion------------*/
    property underflow_seq;
        @(posedge clk) disable iff(!rst_n) ((empty & rd_en) |-> @(negedge clk) (underflow == 1'b1));
    endproperty
    underflow_flag_assert: assert property (underflow_seq)
                else $error("underflow flag assertion failed ");
    underflow_flag_cover:  cover property (underflow_seq);

endmodule