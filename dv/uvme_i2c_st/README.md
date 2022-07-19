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

It is recommended to first go through the README for the Agent IP itself (`uvma_i2c`). Only a few changes are needed at
the environment level:

## 1. Modify the logical transaction definition
### 1.1 Predictor - `uvme_i2c_st_prd_c`
Modify the transaction cloning to match protocol frame definition.


# Datum Technology Corporation I2C UVM Agent Self-Test Environment

# About
This IP contains the Datum Technology Corporation I2C UVM Agent Self-Test Environment.

# Block Diagram
![alt text](./docs/env_block_diagram.svg "I2C UVM Agent Self-Test Environment")

# Directory Structure
* `bin` - Scripts, metadata and other miscellaneous files
* `docs` - Documents describing the I2C UVM Agent Self-Test Environment
* `examples` - Code samples for using and extending this environment
* `src` - Source code


# Dependencies
It IP is dependent on the following packages:

* `uvm_pkg`
* `uvml_pkg`
* `uvml_logs_pkg`
* `uvma_i2c_pkg`