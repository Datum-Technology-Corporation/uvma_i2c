// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_I2C_ST_TB_SV__
`define __UVMT_I2C_ST_TB_SV__


/**
 * Module encapsulating the I2C UVM Agent Self-Test "DUT" wrapper, agents and clock generating interfaces.
 */
module uvmt_i2c_st_tb;

   import uvm_pkg::*;
   import uvmt_i2c_st_pkg::*;

   /**
    * Clocking & Reset
    */
   uvmt_i2c_st_clknrst_gen_if  clknrst_gen_if();

   /**
    * CTLR Agent interface
    */
   uvma_i2c_if ctlr_if(
      .c2t_clk(clknrst_gen_if.clk),
      .t2c_clk(clknrst_gen_if.clk),
      .reset_n (clknrst_gen_if.reset_n)
   );

   /**
    * TAGT Agent interface
    */
   uvma_i2c_if tagt_if(
      .c2t_clk(clknrst_gen_if.clk),
      .t2c_clk(clknrst_gen_if.clk),
      .reset_n (clknrst_gen_if.reset_n)
   );

   /**
    * Passive Agent interface
    */
   uvma_i2c_if passive_if(
      .c2t_clk(clknrst_gen_if.clk),
      .t2c_clk(clknrst_gen_if.clk),
      .reset_n(clknrst_gen_if.reset_n)
   );

   /**
    * "DUT" instance
    */
   uvmt_i2c_st_dut_wrap  dut_wrap(.*);


   /**
    * Test bench entry point.
    */
   initial begin
      // Specify time format for simulation
      $timeformat(
         .units_number       (   -9),
         .precision_number   (    3),
         .suffix_string      (" ns"),
         .minimum_field_width(   18)
      );

      // Add interfaces to uvm_config_db
      uvm_config_db #(virtual uvmt_i2c_st_clknrst_gen_if)::set(null, "*", "clknrst_gen_vif", clknrst_gen_if);
      uvm_config_db #(virtual uvma_i2c_if)::set(null, "*.env.ctlr_agent", "vif", ctlr_if);
      uvm_config_db #(virtual uvma_i2c_if)::set(null, "*.env.tagt_agent", "vif", tagt_if);
      uvm_config_db #(virtual uvma_i2c_if)::set(null, "*.env.passive_agent", "vif", passive_if);

      // Run test
      uvm_top.enable_print_topology = 0;
      uvm_top.finish_on_completion  = 1;
      uvm_top.run_test();
   end

endmodule : uvmt_i2c_st_tb


`endif // __UVMT_I2C_ST_TB_SV__