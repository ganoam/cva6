add wave -group model-inout -position end  sim:/ariane_regfile_tb/model_i/raddr_i
add wave -group model-inout -position end  sim:/ariane_regfile_tb/model_i/rdata_o
add wave -group model-inout -position end  sim:/ariane_regfile_tb/model_i/waddr_i
add wave -group model-inout -position end  sim:/ariane_regfile_tb/model_i/wdata_i
add wave -group model-inout -position end  sim:/ariane_regfile_tb/model_i/we_i

add wave -group dut-inout -position end  sim:/ariane_regfile_tb/dut_i/raddr_i
add wave -group dut-inout -position end  sim:/ariane_regfile_tb/dut_i/rdata_o
add wave -group dut-inout -position end  sim:/ariane_regfile_tb/dut_i/waddr_i
add wave -group dut-inout -position end  sim:/ariane_regfile_tb/dut_i/wdata_i
add wave -group dut-inout -position end  sim:/ariane_regfile_tb/dut_i/we_i

add wave -group dut-internal -position end  sim:/ariane_regfile_tb/dut_i/mem
add wave -group dut-internal -position end  sim:/ariane_regfile_tb/dut_i/we_dec
add wave -group dut-internal -position end  sim:/ariane_regfile_tb/dut_i/mem_block_sel
add wave -group dut-internal -position end  sim:/ariane_regfile_tb/dut_i/mem_block_sel_q
add wave -group dut-internal -position end  sim:/ariane_regfile_tb/dut_i/mem_read
add wave -group dut-internal -position end  sim:/ariane_regfile_tb/dut_i/block_addr
