# Create the work library
vlib work

# Compile all source files listed in src_files.list
vlog -f src_files.list +cover -covercells

# Simulate the top-level module
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

# Run the simulation for 0 time units (initial setup)
run 0

# Add all signals from the ALSUif interface to the waveform viewer
add wave /top/FIFOif/*

# Add specific signals from the scoreboard and DUT to the waveform viewer
add wave -position insertpoint \
    sim:/@FIFO_scoreboard@1.data_out_ref \
    sim:/@FIFO_scoreboard@1.wr_ack_ref \
    sim:/@FIFO_scoreboard@1.overflow_ref \
    sim:/@FIFO_scoreboard@1.full_ref \
    sim:/@FIFO_scoreboard@1.empty_ref \
    sim:/@FIFO_scoreboard@1.almostfull_ref \
    sim:/@FIFO_scoreboard@1.almostempty_ref \
    sim:/@FIFO_scoreboard@1.underflow_ref \
    sim:/@FIFO_scoreboard@1.error_count \
    sim:/@FIFO_scoreboard@1.correct_count \
    sim:/top/DUT/count \
    sim:/@FIFO_scoreboard@1.count \
    sim:/top/DUT/wr_ptr \
    sim:/@FIFO_scoreboard@1.wr_ptr \
    sim:/top/DUT/rd_ptr \
    sim:/@FIFO_scoreboard@1.rd_ptr \
    sim:/top/DUT/wr_en \
    sim:/top/DUT/rd_en

# Exclude specific coverage paths for overflow and underflow conditions
coverage exclude -cvgpath /FIFO_cov_collector_pkg/FIFO_cov_collec/FIFO_COV/overflow_cross/<wr_en_0,rd_en_0,overflow_1>
coverage exclude -cvgpath /FIFO_cov_collector_pkg/FIFO_cov_collec/FIFO_COV/overflow_cross/<wr_en_0,rd_en_1,overflow_1>
coverage exclude -cvgpath /FIFO_cov_collector_pkg/FIFO_cov_collec/FIFO_COV/underflow_cross/<wr_en_0,rd_en_0,underflow_1>
coverage exclude -cvgpath /FIFO_cov_collector_pkg/FIFO_cov_collec/FIFO_COV/underflow_cross/<wr_en_1,rd_en_0,underflow_1>
coverage exclude -cvgpath /FIFO_cov_collector_pkg/FIFO_cov_collec/FIFO_COV/full_cross/<wr_en_0,rd_en_1,full_1>
coverage exclude -cvgpath /FIFO_cov_collector_pkg/FIFO_cov_collec/FIFO_COV/full_cross/<wr_en_0,rd_en_0,full_0>

# Save coverage data to a file on exit
coverage save FIFO_UVM_nn.ucdb -onexit 

# Run the simulation until completion
run -all

