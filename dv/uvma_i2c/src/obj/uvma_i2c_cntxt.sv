// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_CNTXT_SV__
`define __UVMA_I2C_CNTXT_SV__


/**
 * Object encapsulating all state variables for all I2C Agent (uvma_i2c_agent_c) components.
 */
class uvma_i2c_cntxt_c extends uvm_object;

   virtual uvma_i2c_if  vif; ///< Handle to agent interface.

   /// @defgroup Integrals
   /// @{
   uvml_reset_state_enum  reset_state; ///< Reset state as observed by monitor (uvma_i2c_mon_c).
   /// @}

   /// @defgroup Objects
   /// @{
   uvm_event  sample_cfg_e  ; ///< Triggers sampling of the agent configuration by the functional coverage model.
   uvm_event  sample_cntxt_e; ///< Triggers sampling of the agent context by the functional coverage model.
   /// @}

   /// @defgroup Sequences
   /// @{
   uvm_sequence_base  mon_vseq   ; ///< Monitor Virtual Sequence instance.
   uvm_sequence_base  idle_vseq  ; ///< Idle Generating Virtual Sequence instance.
   uvm_sequence_base  c2t_drv_vseq; ///< C2T Driver Phy Virtual Sequence instance.
   uvm_sequence_base  t2c_drv_vseq; ///< T2C Driver Phy Virtual Sequence instance.
   /// @}

   /// @defgroup FSM
   /// @{
   uvma_i2c_mon_fsm_cntxt_c  c2t_mon_fsm_cntxt; ///< Monitor C2T FSM data.
   uvma_i2c_mon_fsm_cntxt_c  t2c_mon_fsm_cntxt; ///< Monitor T2C FSM data.
   /// @}


   `uvm_object_utils_begin(uvma_i2c_cntxt_c)
      `uvm_field_enum(uvml_reset_state_enum, reset_state, UVM_DEFAULT)
      `uvm_field_event(sample_cfg_e  , UVM_DEFAULT)
      `uvm_field_event(sample_cntxt_e, UVM_DEFAULT)
      `uvm_field_object(c2t_mon_fsm_cntxt, UVM_DEFAULT)
      `uvm_field_object(t2c_mon_fsm_cntxt, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Builds objects.
    */
   extern function new(string name="uvma_i2c_cntxt");

   /**
    * Returns all state variables to initial values.
    * Called by monitor (uvma_${name}_mon_c) when it observes a reset pulse.
    */
   extern function void reset();

endclass : uvma_i2c_cntxt_c


function uvma_i2c_cntxt_c::new(string name="uvma_i2c_cntxt");

   super.new(name);
   reset_state = UVML_RESET_STATE_PRE_RESET;
   c2t_mon_fsm_cntxt = uvma_i2c_mon_fsm_cntxt_c::type_id::create("c2t_mon_fsm_cntxt");
   t2c_mon_fsm_cntxt = uvma_i2c_mon_fsm_cntxt_c::type_id::create("t2c_mon_fsm_cntxt");
   sample_cfg_e   = new("sample_cfg_e"  );
   sample_cntxt_e = new("sample_cntxt_e");

endfunction : new


function void uvma_i2c_cntxt_c::reset();

   c2t_mon_fsm_cntxt.reset();
   t2c_mon_fsm_cntxt.reset();

endfunction : reset


`endif // __UVMA_I2C_CNTXT_SV__