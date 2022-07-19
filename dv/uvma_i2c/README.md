# A Word From Your Code Generator
Thank you for using the Moore.io Advanced UVM Agent Code Template for Serial protocols v1.0!

Your parameters are:
* Name: 'i2c'
* Full Name: 'I2C'
* Mode 1: 'ctlr'
* Mode 2: 'tagt'
* Direction 1: 'c2t'
* Direction 2: 't2c'
* Clocking: SDR
* Interface Symmetry: C2T and T2C are the same

If this is incorrect, it's recommended to delete the generated IP and re-generate with the correct parameters.

This code template is based on the ['Advanced' UVM methodology](https://www.linkedin.com/pulse/advanced-uvm-brian-hunter/).
This agent uses multiple sequencers and virtual sequences to harness the full power of UVM and elegantly implement serial
protocols.  It can also be combined with other Advanced UVM template instances to create VIP 'stacks'.

As opposed to most other Moore.io UVM code templates, this one has a protocol implemented out of the box.
This serial protocol is as simple as possible, while providing enough material to quickly get you angled towards your particular
protocol implementation challenges.  It has a simple "training sequence", an edge "syncing" stage which locks upon 36b
frames:  2b header/sync, 32b data, 2b tail.  There is error checking on the frame itself, but once a serial link is
synced, it does not lose sync again regardless of errors.

What follows is a task list to get you going as fast as possible:

 ## 1 - Modify the physical interface definitions
 1. - [ ] Physical Interface - `uvma_i2c_if` - Modify the signals to match your protocol's physical interface.
 1. - [ ] Phy Monitor Transaction - `uvma_i2c_phy_mon_trn_c` - Modify the fields to match your interface definition.
 1. - [ ] Phy Sequence Item - `uvma_i2c_phy_seq_item_c` - Modify the fields to match your interface definition.
 1. - [ ] Phy Driver - `uvma_i2c_phy_drv_c` - Modify the code driving the modport signals to match your interface definition.
 1. - [ ] Phy Driver Virtual Sequence - `uvma_i2c_c2t_phy_vseq_c` - Modify the sequence to match your interface definition.
 1. - [ ] Monitor - `uvma_i2c_mon_c` - Modify the code sampling the modports signals to match your interface definition.
 1. - [ ] Monitor Virtual Sequence - `uvma_i2c_mon_vseq_c` - Modify the code pushing data from Phy Monitor Transactions to match your new interface definition.

 ## 2 - Logical Transaction Model
 1. - [ ] Sequence Item - `uvma_i2c_seq_item_c` - Modify the fields to model your protocol frame structure for stimulus generation.
 1. - [ ] Monitor Transaction - `uvma_i2c_mon_trn_c` - Modify the fields to model your protocol frame structure for rebuilding from sampled data.

 ## 3 - Protocol Implementation
 1. - [ ] Configuration - `uvma_i2c_cfg_c` - Add parameters if needed to present the user with protocol options.
 1. - [ ] FSM Definition - `uvma_i2c_mon_fsm_cntxt_c` - Add fields and modify types if needed to store the Monitor Finite State Machine (FSM) data.
 1. - [ ] Monitor FSM - `uvma_i2c_mon_vseq_c` - Modify the code to implement your protocol's serial FSM.
 1. - [ ] IDLE Generation - `uvma_i2c_idle_vseq_c` - Modify the sequence to implement IDLE generation for your protocol.

## That's it!
The codebase is ready to roll alongside the other 2 IPs generated alongside this Agent:
* `uvme_i2c_st`
* `uvmt_i2c_st`




# Datum Technology Corporation (I2C) UVM Agent

# About
This IP contains the Datum Technology Corporation I2C UVM Agent.
TODO Describe I2C UVM Agent

# Block Diagram
![alt text](./docs/agent_block_diagram.png "I2C UVM Agent Block Diagram")

# Directory Structure
* `bin` - Scripts, metadata and other miscellaneous files
* `docs` - Documents describing the I2C UVM Agent
* `examples` - Code samples for using and extending this agent
* `src` - Source code


# Dependencies
It IP is dependent on the following packages:

* `uvm_pkg`
* `uvml_pkg`
* `uvml_logs_pkg`
* `uvml_mem_pkg`