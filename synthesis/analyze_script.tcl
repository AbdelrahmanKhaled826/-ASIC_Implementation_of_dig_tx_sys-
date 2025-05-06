analyze -library WORK -format sverilog " \
$VERILOG_PATH/dig_tx_clock_gating.sv \
$VERILOG_PATH/dig_tx_reg_file.sv\
$VERILOG_PATH/dig_tx_serializer.sv\
$VERILOG_PATH/dig_tx_rst_sync.sv\
$VERILOG_PATH/dig_tx_pulse_delayed.sv \
$VERILOG_PATH/dig_tx_pow_man_unit.sv \
$VERILOG_PATH/dig_tx_crc.sv \
$VERILOG_PATH/dig_tx_fifo_synchronizer.sv\
$VERILOG_PATH/dig_tx_fifo_wr_ptr_handler.sv \
$VERILOG_PATH/dig_tx_fifo_re_ptr_handler.sv \
$VERILOG_PATH/dig_tx_fifo_mem.sv \
$VERILOG_PATH/dig_tx_asyn_fifo.sv \
$VERILOG_PATH/dig_tx_control_unit.sv \
$VERILOG_PATH/spi_slave.sv\
$VERILOG_PATH/dig_tx_system.sv "
