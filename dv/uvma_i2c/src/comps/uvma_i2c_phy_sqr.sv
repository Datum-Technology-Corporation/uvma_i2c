// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_PHY_SQR_SV__
`define __UVMA_I2C_PHY_SQR_SV__


/**
 * Sequencer running Phy Sequence Items (uvma_i2c_phy}_seq_item_c).
 */
class uvma_i2c_phy_sqr_c extends uvml_sqr_c #(
   .REQ(uvma_i2c_phy_seq_item_c),
   .RSP(uvma_i2c_phy_seq_item_c)
);

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c  cntxt; ///< Agent context handle
   /// @}


   `uvm_component_utils_begin(uvma_i2c_phy_sqr_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_phy_sqr", uvm_component parent=null);

   /**
    * Ensures #cfg & #cntxt handles are not null
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Uses uvm_config_db to retrieve cfg.
    */
   extern function void get_cfg();

   /**
    * Uses uvm_config_db to retrieve cntxt.
    */
   extern function void get_cntxt();

endclass : uvma_i2c_phy_sqr_c


function uvma_i2c_phy_sqr_c::new(string name="uvma_i2c_phy_sqr", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_phy_sqr_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg  ();
   get_cntxt();

endfunction : build_phase


function void uvma_i2c_phy_sqr_c::get_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_PHY_SQR", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvma_i2c_phy_sqr_c::get_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_PHY_SQR", "Context handle is null")
   end

endfunction : get_cntxt


`endif // __UVMA_I2C_PHY_SQR_SV__