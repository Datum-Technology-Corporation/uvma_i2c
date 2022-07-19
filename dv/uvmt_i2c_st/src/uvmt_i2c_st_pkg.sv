// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_I2C_ST_PKG_SV__
`define __UVMT_I2C_ST_PKG_SV__


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvml_macros.svh"
`include "uvml_logs_macros.svh"
`include "uvml_sb_macros.svh"
`include "uvma_i2c_macros.svh"
`include "uvme_i2c_st_macros.svh"
`include "uvmt_i2c_st_macros.svh"

// Time units and precision for this test bench
timeunit       1ns;
timeprecision  1ps;

// Interface(s)
`include "uvmt_i2c_st_clknrst_gen_if.sv"


/**
 * Encapsulates the test library of the I2C UVM Agent Self-Test Bench.
 */
package uvmt_i2c_st_pkg;

   import uvm_pkg      ::*;
   import uvml_pkg     ::*;
   import uvml_logs_pkg::*;
   import uvml_sb_pkg  ::*;
   import uvma_i2c_pkg   ::*;
   import uvme_i2c_st_pkg::*;

   // Constants / Structs / Enums
   `include "uvmt_i2c_st_tdefs.sv"
   `include "uvmt_i2c_st_constants.sv"

   // Base test
   `include "uvmt_i2c_st_test_cfg.sv"
   `include "uvmt_i2c_st_base_test.sv"

   // Funtional Tests
   `include "uvmt_i2c_st_rand_stim_test.sv"

endpackage : uvmt_i2c_st_pkg


// Module(s) / Checker(s)
`include "uvmt_i2c_st_dut_wrap.sv"
`include "uvmt_i2c_st_dut_chkr.sv"
`include "uvmt_i2c_st_tb.sv"


`endif // __UVMT_I2C_ST_PKG_SV__