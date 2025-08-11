# Pure Ethernet

This is a simple project for this board which shows how Ethernet can be utilized with this board using ZYNQ ENET controller.
The issues for this scenario are:
- PHY is connected to PL
- PHY is 10/100 only, so the data buses should be reduced
For that reason basic bd with zynq is wrapped with simple `top.sv`.

You can also use axi-ethernet core, however it will take resources from PL, which might be crucial for user-defined logic.