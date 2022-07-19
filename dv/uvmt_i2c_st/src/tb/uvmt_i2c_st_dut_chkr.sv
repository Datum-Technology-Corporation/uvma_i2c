// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_I2C_ST_DUT_CHKR_SV__
`define __UVMT_I2C_ST_DUT_CHKR_SV__


/**
 * Module encapsulating assertions for I2C Self-Test DUT wrapper (uvmt_i2c_st_dut_wrap).
 */
module uvmt_i2c_st_dut_chkr (
   uvma_i2c_if  ctlr_if, ///< CTLR Agent interface
   uvma_i2c_if  tagt_if, ///< TAGT Agent interface
   uvma_i2c_if  passive_if       ///< Passive Agent interface
);

   // TODO Add assertions to uvmt_i2c_st_dut_chkr

endmodule : uvmt_i2c_st_dut_chkr


`endif // __UVMT_I2C_ST_DUT_CHKR_SV__