// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_PKG_SV__
`define __UVMA_I2C_PKG_SV__


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvml_macros.svh"
`include "uvml_logs_macros.svh"
`include "uvma_i2c_macros.svh"

// Interface(s)
`include "uvma_i2c_if.sv"


/**
 * Encapsulates all the types needed for an UVM agent capable of driving and/or monitoring I2C serial interface.
 */
package uvma_i2c_pkg;

   import uvm_pkg      ::*;
   import uvml_pkg     ::*;
   import uvml_logs_pkg::*;

   // Constants / Structs / Enums
   `include "uvma_i2c_tdefs.sv"
   `include "uvma_i2c_constants.sv"

   // Objects
   `include "uvma_i2c_cfg.sv"
   `include "uvma_i2c_mon_fsm_cntxt.sv"
   `include "uvma_i2c_cntxt.sv"

   // Transactions
   `include "uvma_i2c_mon_trn.sv"
   `include "uvma_i2c_phy_mon_trn.sv"
   `include "uvma_i2c_seq_item.sv"
   `include "uvma_i2c_phy_seq_item.sv"

   // Drivers
   `include "uvma_i2c_phy_drv.sv"

   // Sequencers
   `include "uvma_i2c_phy_sqr.sv"

   // Agent-Level Components
   `include "uvma_i2c_mon.sv"
   `include "uvma_i2c_drv.sv"
   `include "uvma_i2c_vsqr.sv"
   `include "uvma_i2c_logger.sv"
   `include "uvma_i2c_cov_model.sv"
   `include "uvma_i2c_agent.sv"

   // Sequences
   `include "uvma_i2c_base_vseq.sv"
   `include "uvma_i2c_mon_vseq.sv"
   `include "uvma_i2c_training_vseq.sv"
   `include "uvma_i2c_phy_drv_vseq.sv"
   `include "uvma_i2c_idle_vseq.sv"

endpackage : uvma_i2c_pkg


// Module(s) / Checker(s)
`ifdef UVMA_I2C_INC_CHKR
`include "uvma_i2c_if_chkr.sv"
`endif


`endif // __UVMA_I2C_PKG_SV__