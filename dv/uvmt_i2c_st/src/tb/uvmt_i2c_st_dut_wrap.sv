// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_I2C_ST_DUT_WRAP_SV__
`define __UVMT_I2C_ST_DUT_WRAP_SV__


/**
 * "DUT" wrapper connecting I2C Agent Self-Test Bench interfaces.
 * All ports are SV interfaces.
 */
module uvmt_i2c_st_dut_wrap(
   uvma_i2c_if  ctlr_if, ///< CTLR Agent interface
   uvma_i2c_if  tagt_if, ///< TAGT Agent interface
   uvma_i2c_if  passive_if       ///< Passive Agent interface
);

   /// @defgroup C2T
   /// @{
   reg c2tp;
   reg c2tn;

   assign tagt_if.c2tp = c2tp;
   assign tagt_if.c2tn = c2tn;
   assign passive_if.c2tp = c2tp;
   assign passive_if.c2tn = c2tn;

   always @(posedge ctlr_if.c2t_clk) begin
      c2tp <= ctlr_if.c2tp;
      c2tn <= ctlr_if.c2tn;
   end
   /// @}


   /// @defgroup T2C
   /// @{
   reg t2cp;
   reg t2cn;

   assign ctlr_if.t2cp = t2cp;
   assign ctlr_if.t2cn = t2cn;
   assign passive_if.t2cp = t2cp;
   assign passive_if.t2cn = t2cn;

   always @(posedge ctlr_if.t2c_clk) begin
      t2cp <= tagt_if.t2cp;
      t2cn <= tagt_if.t2cn;
   end
   /// @}

endmodule : uvmt_i2c_st_dut_wrap


`endif // __UVMT_I2C_ST_DUT_WRAP_SV__