# DMA project

This is a project with simple DMA usage demonstration: running data recording from parametrized `data_gen` to the DDR, then passing it to PS and tossing to the Ethernet via lwIP.

Simplified structure below:

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  ┌───────────────┐     ┌───────────────┐     ┌──────────────┐    │
└──┤AXI4Lite       │  ┌─►│SAXIS          │  ┌─►│HP          GP├────┘
   │               │  │  │               │  │  │              │     
   │   data_gen    │  │  │   AXI-DMA IP  │  │  │     ZYNQ     │     
   │               │  │  │               │  │  │              │     
   │          MAXIS├──┘  │           AXI4├──┘  │              │     
   └───────────────┘     └───────────────┘     └──────────────┘     
```

## Structure description

Data generator block (`data_gen`) is a block which can generate and send via AXI-Stream counter values. Block can be modified via AXI4Lite. THe register part is generated via **[Corsair](https://corsair.readthedocs.io/en/latest/index.html)**. Register table for that block is below

|Register name|Offset|R/W|Type|description|
|-|-|-|-|-|
|Control  |`0x0000`|RW|`uint_8`|See description below|
|Increment|`0x0004`|RW|`uint_8`|Increment value for counter data|
|Limit|`0x0005`|RW|`uint_16`|Max value for counter before zero|
|Burst length|`0x0008`|RW|`uint_16`|length of one axi-stream burst|
|Burst pause|`0x0010` |RW|`uint_16`|Pause between bursts|

### Control register

|Bit number(s)|description|
|-|-|
|`0`|Start(`1`)/Stop(`0`)|
|`1`|Mode: `0`- one burst after start, `1` bursting until stop|
|`2`|Error flag if stream should come but the DMA block was not ready, resetting by writing `0`|