set_property PACKAGE_PIN K17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN G15 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property PACKAGE_PIN T11 [get_ports mosi]
set_property IOSTANDARD LVCMOS33 [get_ports mosi]

set_property PACKAGE_PIN Y16 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]

set_property PACKAGE_PIN W14 [get_ports miso]
set_property IOSTANDARD LVCMOS33 [get_ports miso]

set_property PACKAGE_PIN V15 [get_ports sclk]
set_property IOSTANDARD LVCMOS33 [get_ports sclk]

set_property PACKAGE_PIN W15 [get_ports cs]
set_property IOSTANDARD LVCMOS33 [get_ports cs]
    
#    //rx(miso)
#    output [data_width-1:0] data_out,//miso로 받은 데이터