// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_PKG_SV__
`define __UVME_I2C_ST_PKG_SV__


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvml_macros.svh"
`include "uvml_logs_macros.svh"
`include "uvml_sb_macros.svh"
`include "uvma_i2c_macros.svh"
`include "uvme_i2c_st_macros.svh"

// Interface(s)


 /**
 * Encapsulates all the types of the I2C UVM Agent Self-Test environment.
 */
package uvme_i2c_st_pkg;

   import uvm_pkg      ::*;
   import uvml_pkg     ::*;
   import uvml_logs_pkg::*;
   import uvml_sb_pkg  ::*;
   import uvma_i2c_pkg::*;

   // Constants / Structs / Enums
   `include "uvme_i2c_st_tdefs.sv"
   `include "uvme_i2c_st_constants.sv"

   // Objects
   `include "uvme_i2c_st_cfg.sv"
   `include "uvme_i2c_st_cntxt.sv"

   // Environment components
   `include "uvme_i2c_st_cov_model.sv"
   `include "uvme_i2c_st_prd.sv"
   `include "uvme_i2c_st_sb.sv"
   `include "uvme_i2c_st_vsqr.sv"
   `include "uvme_i2c_st_env.sv"

   // Sequences
   `include "uvme_i2c_st_vseq_lib.sv"

endpackage : uvme_i2c_st_pkg


// Module(s) / Checker(s)
`ifdef UVME_I2C_ST_INC_CHKR
`include "uvme_i2c_st_chkr.sv"
`endif


`endif // __UVME_I2C_ST_PKG_SV__