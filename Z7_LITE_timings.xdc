# Filename    : Z7_LITE_timings.xdc
# Description : this file has basic universal to all design constraints.
#               additional constraints are added in folders
#


# This constraint needed because Ethernet TX CLK is connected to non-clk-enable pin
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ETH_TXCK_IBUF]