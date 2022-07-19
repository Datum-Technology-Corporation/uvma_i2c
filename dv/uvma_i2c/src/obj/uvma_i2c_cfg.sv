// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_CFG_SV__
`define __UVMA_I2C_CFG_SV__


// Default sequences
typedef class uvma_i2c_mon_vseq_c   ;
typedef class uvma_i2c_idle_vseq_c  ;
typedef class uvma_i2c_phy_drv_vseq_c;


/**
 * Object encapsulating all parameters for creating, connecting and running all I2C agent
 * (uvma_i2c_agent_c) components.
 */
class uvma_i2c_cfg_c extends uvm_object;

   /// @defgroup Generic options
   /// @{
   rand bit                      enabled          ; ///< Sub-components are not created if '0'.
   rand bit                      bypass_mode      ; ///< Does not drive interface when '1' (only TLM).
   rand uvm_active_passive_enum  is_active        ; ///< Driver is not created if 'UVM_PASSIVE'.
   rand uvml_reset_type_enum     reset_type       ; ///< Sets whether the monitor is sensitive to a/synchronous reset.
   rand bit                      cov_model_enabled; ///< Gates the creation of the functional coverage model.
   rand bit                      trn_log_enabled  ; ///< Gates the creation of the transaction logger.
   /// @}

   /// @defgroup Protocol Options
   /// @{
   rand uvma_i2c_mode_enum  drv_mode; ///< Specifies which data stream to drive when in active mode.
   /// @}

   /// @defgroup Objects
   /// @{
   uvm_object_wrapper  mon_vseq_type   ; ///< Type for Monitor Virtual Sequence to be started by agent at start of run_phase().
   uvm_object_wrapper  idle_vseq_type  ; ///< Type for Idle Virtual Sequence to be started by agent at start of run_phase().
   uvm_object_wrapper  c2t_drv_vseq_type; ///< Type for C2T Driver Virtual Sequence to be started by agent at start of run_phase().
   uvm_object_wrapper  t2c_drv_vseq_type; ///< Type for T2C Driver Virtual Sequence to be started by agent at start of run_phase().
   /// @}


   `uvm_object_utils_begin(uvma_i2c_cfg_c)
      `uvm_field_int (                         enabled          , UVM_DEFAULT)
      `uvm_field_int (                         bypass_mode      , UVM_DEFAULT)
      `uvm_field_enum(uvm_active_passive_enum, is_active        , UVM_DEFAULT)
      `uvm_field_enum(uvml_reset_type_enum   , reset_type       , UVM_DEFAULT)
      `uvm_field_int (                         cov_model_enabled, UVM_DEFAULT)
      `uvm_field_int (                         trn_log_enabled  , UVM_DEFAULT)
      `uvm_field_enum(uvma_i2c_mode_enum, drv_mode, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Sets usual values for generic options.
    */
   constraint defaults_cons {
      soft enabled           == 1;
      soft bypass_mode       == 0;
      soft is_active         == UVM_PASSIVE;
      soft reset_type        == UVML_RESET_TYPE_SYNCHRONOUS;
      soft cov_model_enabled == 0;
      soft trn_log_enabled   == 1;
   }


   /**
    * Creates objects.
    */
   extern function new(string name="uvma_i2c_cfg");

endclass : uvma_i2c_cfg_c


function uvma_i2c_cfg_c::new(string name="uvma_i2c_cfg");

   super.new(name);
   mon_vseq_type    = uvma_i2c_mon_vseq_c   ::get_type();
   idle_vseq_type   = uvma_i2c_idle_vseq_c  ::get_type();
   c2t_drv_vseq_type = uvma_i2c_phy_drv_vseq_c::get_type();
   t2c_drv_vseq_type = uvma_i2c_phy_drv_vseq_c::get_type();

endfunction : new


`endif // __UVMA_I2C_CFG_SV__