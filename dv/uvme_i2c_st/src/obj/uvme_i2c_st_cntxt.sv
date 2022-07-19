// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_CNTXT_SV__
`define __UVME_I2C_ST_CNTXT_SV__


/**
 * Object encapsulating all state variables for I2C UVM Agent Self-Test Environment (uvme_i2c_st_env_c) components.
 */
class uvme_i2c_st_cntxt_c extends uvml_cntxt_c;

   /// @defgroup Agent Context Handles
   /// @{
   uvma_i2c_cntxt_c  ctlr_cntxt; ///< CTLR Agent context handle.
   uvma_i2c_cntxt_c  tagt_cntxt; ///< TAGT Agent context handle.
   uvma_i2c_cntxt_c  passive_cntxt; ///< Passive Agent context handle.
   /// @}

   /// @defgroup Scoreboard Context Handle
   /// @{
   uvml_sb_simplex_cntxt_c  sb_c2t_cntxt; ///< C2T Scoreboard context handle.
   uvml_sb_simplex_cntxt_c  sb_t2c_cntxt; ///< T2C Scoreboard context handle.
   uvml_sb_simplex_cntxt_c  sb_ctlr_cntxt; ///< CTLR Scoreboard context handle.
   uvml_sb_simplex_cntxt_c  sb_tagt_cntxt; ///< TAGT Scoreboard context handle.
   /// @}

   /// @defgroup Objects
   /// @{
   uvm_event  sample_cfg_e  ; ///< Triggers sampling of environment configuration by the functional coverage model.
   uvm_event  sample_cntxt_e; ///< Triggers sampling of environment context by the functional coverage model.
   /// @}


   `uvm_object_utils_begin(uvme_i2c_st_cntxt_c)
      `uvm_field_object(ctlr_cntxt, UVM_DEFAULT)
      `uvm_field_object(tagt_cntxt, UVM_DEFAULT)
      `uvm_field_object(passive_cntxt, UVM_DEFAULT)
      `uvm_field_object(sb_c2t_cntxt, UVM_DEFAULT)
      `uvm_field_object(sb_t2c_cntxt, UVM_DEFAULT)
      `uvm_field_object(sb_ctlr_cntxt, UVM_DEFAULT)
      `uvm_field_object(sb_tagt_cntxt, UVM_DEFAULT)
      `uvm_field_event(sample_cfg_e  , UVM_DEFAULT)
      `uvm_field_event(sample_cntxt_e, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Creates sub-context objects.
    */
   extern function new(string name="uvme_i2c_st_cntxt");

   /**
    * Forces all sub-context objects to reset.
    */
   extern function void reset();

endclass : uvme_i2c_st_cntxt_c


function uvme_i2c_st_cntxt_c::new(string name="uvme_i2c_st_cntxt");

   super.new(name);
   ctlr_cntxt = uvma_i2c_cntxt_c::type_id::create("ctlr_cntxt");
   tagt_cntxt = uvma_i2c_cntxt_c::type_id::create("tagt_cntxt");
   passive_cntxt = uvma_i2c_cntxt_c::type_id::create("passive_cntxt");
   sb_c2t_cntxt = uvml_sb_simplex_cntxt_c::type_id::create("sb_c2t_cntxt");
   sb_t2c_cntxt = uvml_sb_simplex_cntxt_c::type_id::create("sb_t2c_cntxt");
   sb_ctlr_cntxt = uvml_sb_simplex_cntxt_c::type_id::create("sb_ctlr_cntxt");
   sb_tagt_cntxt = uvml_sb_simplex_cntxt_c::type_id::create("sb_tagt_cntxt");
   sample_cfg_e   = new("sample_cfg_e"  );
   sample_cntxt_e = new("sample_cntxt_e");

endfunction : new


function void uvme_i2c_st_cntxt_c::reset();

   ctlr_cntxt.reset();
   tagt_cntxt.reset();
   passive_cntxt.reset();

endfunction : reset


`endif // __UVME_I2C_ST_CNTXT_SV__