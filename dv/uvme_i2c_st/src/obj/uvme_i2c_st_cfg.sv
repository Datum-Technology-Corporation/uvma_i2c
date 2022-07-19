// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_CFG_SV__
`define __UVME_I2C_ST_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running I2C UVM Agent Self-Testing
 * Environment (uvme_i2c_st_env_c) components.
 */
class uvme_i2c_st_cfg_c extends uvml_cfg_c;

   /// @defgroup Integrals
   /// @{
   rand bit                      enabled              ; ///< Enables/disables creation of all sub-components.
   rand uvm_active_passive_enum  is_active            ; ///< Sets all agents as active/passive.
   rand uvml_reset_type_enum     reset_type           ; ///< Sets the type of reset the agent is sensitive to.
   rand bit                      scoreboarding_enabled; ///< Enables/disables creation of predictor and scoreboard.
   rand bit                      cov_model_enabled    ; ///< Enables/disables functional coverage models.
   rand bit                      trn_log_enabled      ; ///< Enables/disables transaction logging.
   /// @}

   /// @defgroup Objects
   /// @{
   rand uvma_i2c_cfg_c  ctlr_cfg  ; ///< CTLR Agent configuration handle.
   rand uvma_i2c_cfg_c  tagt_cfg  ; ///< TAGT Agent configuration handle.
   rand uvma_i2c_cfg_c  passive_cfg  ; ///< Passive Agent configuration handle.
   rand uvml_sb_simplex_cfg_c  sb_c2t_cfg; ///< C2T Scoreboard configuration handle.
   rand uvml_sb_simplex_cfg_c  sb_t2c_cfg; ///< T2C Scoreboard configuration handle.
   rand uvml_sb_simplex_cfg_c  sb_ctlr_cfg; ///< CTLR Scoreboard configuration handle.
   rand uvml_sb_simplex_cfg_c  sb_tagt_cfg; ///< TAGT Scoreboard configuration handle.
   /// @}


   `uvm_object_utils_begin(uvme_i2c_st_cfg_c)
      `uvm_field_int (                         enabled              , UVM_DEFAULT)
      `uvm_field_enum(uvm_active_passive_enum, is_active            , UVM_DEFAULT)
      `uvm_field_enum(uvml_reset_type_enum   , reset_type           , UVM_DEFAULT)
      `uvm_field_int (                         scoreboarding_enabled, UVM_DEFAULT)
      `uvm_field_int (                         cov_model_enabled    , UVM_DEFAULT)
      `uvm_field_int (                         trn_log_enabled      , UVM_DEFAULT)
      `uvm_field_object(ctlr_cfg  , UVM_DEFAULT)
      `uvm_field_object(tagt_cfg  , UVM_DEFAULT)
      `uvm_field_object(passive_cfg  , UVM_DEFAULT)
      `uvm_field_object(sb_c2t_cfg, UVM_DEFAULT)
      `uvm_field_object(sb_t2c_cfg, UVM_DEFAULT)
      `uvm_field_object(sb_ctlr_cfg, UVM_DEFAULT)
      `uvm_field_object(sb_tagt_cfg, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Sets safe defaults.
    */
   constraint defaults_cons {
      soft enabled                == 0;
      soft is_active              == UVM_PASSIVE;
      soft scoreboarding_enabled  == 1;
      soft cov_model_enabled      == 0;
      soft trn_log_enabled        == 1;
   }

   /**
    * Sets all configuration fields for CTLR agent.
    */
   constraint agent_ctlr_cfg_cons {
      ctlr_cfg.drv_mode == UVMA_I2C_DRV_MODE_CTLR;
      ctlr_cfg.bypass_mode == 0;
      ctlr_cfg.reset_type == reset_type;
      if (enabled) {
         ctlr_cfg.enabled == 1;
      }
      else {
         ctlr_cfg.enabled == 0;
      }
      if (is_active == UVM_ACTIVE) {
         ctlr_cfg.is_active == UVM_ACTIVE;
      }
      else {
         ctlr_cfg.is_active == UVM_PASSIVE;
      }
      if (cov_model_enabled) {
         ctlr_cfg.cov_model_enabled == 1;
      }
      else {
         ctlr_cfg.cov_model_enabled == 0;
      }
      if (trn_log_enabled) {
         ctlr_cfg.trn_log_enabled == 1;
      }
      else {
         ctlr_cfg.trn_log_enabled == 0;
      }
   }

   /**
    * Sets all configuration fields for TAGT agent.
    */
   constraint agent_tagt_cfg_cons {
      tagt_cfg.drv_mode == UVMA_I2C_DRV_MODE_TAGT;
      tagt_cfg.bypass_mode == 0;
      tagt_cfg.reset_type == reset_type;
      if (enabled) {
         tagt_cfg.enabled == 1;
      }
      else {
         tagt_cfg.enabled == 0;
      }
      if (is_active == UVM_ACTIVE) {
         tagt_cfg.is_active == UVM_ACTIVE;
      }
      else {
         tagt_cfg.is_active == UVM_PASSIVE;
      }
      if (cov_model_enabled) {
         tagt_cfg.cov_model_enabled == 1;
      }
      else {
         tagt_cfg.cov_model_enabled == 0;
      }
      if (trn_log_enabled) {
         tagt_cfg.trn_log_enabled == 1;
      }
      else {
         tagt_cfg.trn_log_enabled == 0;
      }
   }

   /**
    * Sets all configuration fields for passive agent.
    */
   constraint agent_passive_cfg_cons {
      passive_cfg.bypass_mode == 0;
      passive_cfg.reset_type  == reset_type;
      passive_cfg.is_active   == UVM_PASSIVE;
      if (enabled) {
         passive_cfg.enabled == 1;
      }
      else {
         passive_cfg.enabled == 0;
      }
      if (cov_model_enabled) {
         passive_cfg.cov_model_enabled == 1;
      }
      else {
         passive_cfg.cov_model_enabled == 0;
      }
      if (trn_log_enabled) {
         passive_cfg.trn_log_enabled == 1;
      }
      else {
         passive_cfg.trn_log_enabled == 0;
      }
   }

   /**
    * Sets all scoreboard configuration fields.
    */
   constraint sb_cfg_cons {
      sb_c2t_cfg.mode == UVML_SB_MODE_IN_ORDER;
      sb_t2c_cfg.mode == UVML_SB_MODE_IN_ORDER;
      sb_ctlr_cfg.mode == UVML_SB_MODE_IN_ORDER;
      sb_tagt_cfg.mode == UVML_SB_MODE_IN_ORDER;
      if (scoreboarding_enabled) {
         sb_c2t_cfg.enabled == 1;
         sb_t2c_cfg.enabled == 1;
         sb_ctlr_cfg.enabled == 1;
         sb_tagt_cfg.enabled == 1;
      }
      else {
         sb_c2t_cfg.enabled == 0;
         sb_t2c_cfg.enabled == 0;
         sb_ctlr_cfg.enabled == 0;
         sb_tagt_cfg.enabled == 0;
      }
   }


   /**
    * Creates sub-configuration objects.
    */
   extern function new(string name="uvme_i2c_st_cfg");

endclass : uvme_i2c_st_cfg_c


function uvme_i2c_st_cfg_c::new(string name="uvme_i2c_st_cfg");

   super.new(name);
   ctlr_cfg = uvma_i2c_cfg_c::type_id::create("ctlr_cfg");
   tagt_cfg = uvma_i2c_cfg_c::type_id::create("tagt_cfg");
   passive_cfg = uvma_i2c_cfg_c::type_id::create("passive_cfg");
   sb_c2t_cfg = uvml_sb_simplex_cfg_c::type_id::create("sb_c2t_cfg");
   sb_t2c_cfg = uvml_sb_simplex_cfg_c::type_id::create("sb_t2c_cfg");
   sb_ctlr_cfg = uvml_sb_simplex_cfg_c::type_id::create("sb_ctlr_cfg");
   sb_tagt_cfg = uvml_sb_simplex_cfg_c::type_id::create("sb_tagt_cfg");

endfunction : new


`endif // __UVME_I2C_ST_CFG_SV__