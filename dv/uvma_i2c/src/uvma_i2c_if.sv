// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_IF_SV__
`define __UVMA_I2C_IF_SV__


/**
 * Encapsulates all signals and clocking of the I2C.
 */
interface uvma_i2c_if (
   input  c2t_clk , ///< All C2T signal timings are related to the rising edge of this signal.
   input  t2c_clk , ///< All T2C signal timings are related to the rising edge of this signal.
   input  reset_n  ///< Active LOW reset signal.
);

   /// @defgroup Signals
   /// @{
   wire  c2tp; ///< Positive C2T differential signal
   wire  c2tn; ///< Negative C2T differential signal
   wire  t2cp; ///< Positive T2C differential signal
   wire  t2cn; ///< Negative T2C differential signal
   /// @}


   /**
    * Used by CTLR DUT C2T.
    */
   clocking dut_ctlr_c2t_cb @(posedge c2t_clk);
      output  c2tp,
              c2tn;
   endclocking : dut_ctlr_c2t_cb

   /**
    * Used by CTLR DUT T2C.
    */
   clocking dut_ctlr_t2c_cb @(posedge t2c_clk);
      input  t2cp,
             t2cn;
   endclocking : dut_ctlr_t2c_cb

   /**
    * Used by TAGT DUT C2T.
    */
   clocking dut_tagt_c2t_cb @(posedge c2t_clk);
      input  c2tp,
             c2tn;
   endclocking : dut_tagt_c2t_cb

   /**
    * Used by TAGT DUT T2C.
    */
   clocking dut_tagt_t2c_cb @(posedge t2c_clk);
      output  t2cp,
              t2cn;
   endclocking : dut_tagt_t2c_cb

   /**
    * Used by uvma_i2c_drv_c2t_c.
    */
   clocking drv_c2t_cb @(posedge c2t_clk);
      output  c2tp,
              c2tn;
   endclocking : drv_c2t_cb

   /**
    * Used by uvma_i2c_drv_t2c_c.
    */
   clocking drv_t2c_cb @(posedge t2c_clk);
      output t2cp,
             t2cn;

   endclocking : drv_t2c_cb

   /**
    * Used by uvma_i2c_mon_c C2T.
    */
   clocking mon_c2t_cb @(posedge c2t_clk);
      input  c2tp,
             c2tn;
   endclocking : mon_c2t_cb

   /**
    * Used by uvma_i2c_mon_c T2C.
    */
   clocking mon_t2c_cb @(posedge t2c_clk);
      input  t2cp,
             t2cn;

   endclocking : mon_t2c_cb


   /**
    * Used by CTLR DUT C2T.
    */
   modport dut_ctlr_c2t_mp (
      clocking dut_ctlr_c2t_cb,
      input    reset_n
   );

   /**
    * Used by CTLR DUT T2C.
    */
   modport dut_ctlr_t2c_mp (
      clocking dut_ctlr_t2c_cb,
      input    reset_n
   );

   /**
    * Used by TAGT DUT C2T.
    */
   modport dut_tagt_c2t_mp (
      clocking dut_tagt_c2t_cb,
      input    reset_n
   );

   /**
    * Used by TAGT DUT T2C.
    */
   modport dut_tagt_t2c_mp (
      clocking dut_tagt_t2c_cb,
      input    reset_n
   );

   /**
    * Used by uvma_i2c_drv_c2t_c.
    */
   modport drv_c2t_mp (
      clocking drv_c2t_cb,
      input    reset_n
   );

   /**
    * Used by uvma_i2c_drv_t2c_c.
    */
   modport drv_t2c_mp (
      clocking drv_t2c_cb,
      input    reset_n
   );

   /**
    * Used by uvma_i2c_mon_c C2T.
    */
   modport mon_c2t_mp (
      clocking mon_c2t_cb,
      input    reset_n
   );

   /**
    * Used by uvma_i2c_mon_c T2C.
    */
   modport mon_t2c_mp (
      clocking mon_t2c_cb,
      input    reset_n
   );

endinterface : uvma_i2c_if


`endif // __UVMA_I2C_IF_SV__