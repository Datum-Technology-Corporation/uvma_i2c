// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_MON_FSM_CNTXT_SV__
`define __UVMA_I2C_MON_FSM_CNTXT_SV__


/**
 * TODO Describe uvma_i2c_mon_fsm_cntxt_c
 */
class uvma_i2c_mon_fsm_cntxt_c extends uvm_object;

   /// @defgroup Integrals
   /// @{
   uvma_i2c_mon_fsm_enum  state; ///< Current state for this FSM.
   int unsigned  training_count       ; ///< Count of correct consecutive bits of the training sequence observed.
   int unsigned  num_consecutive_edges; ///< Count of bit transitions seen at the correct intervals.
   realtime      trn_start            ; ///< Timestamp for bit 0 of currently sampled transaction.
   realtime      trn_end              ; ///< Timestamp for last bit of currently sampled transaction.
   /// @}

   /// @defgroup Data
   /// @{
   logic     data_q      [$]; ///< Queue of decoded bits obtained from monitor.
   realtime  timestamps_q[$]; ///< Timestamp for each bit in #data_q.
   bit       trn_data    [] ; ///< Data ready to be unpacked.
   /// @}


   `uvm_object_utils_begin(uvma_i2c_mon_fsm_cntxt_c)
      `uvm_field_enum(uvma_i2c_mon_fsm_enum, state, UVM_DEFAULT)
      `uvm_field_int(training_count       , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(num_consecutive_edges, UVM_DEFAULT + UVM_DEC)
      `uvm_field_real(trn_start    , UVM_DEFAULT)
      `uvm_field_real(trn_end      , UVM_DEFAULT)
      `uvm_field_queue_int(data_q  , UVM_DEFAULT)
      `uvm_field_array_int(trn_data, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_mon_fsm_cntxt");

   /**
    * Returns all state variables to initial values.
    */
   extern function void reset();

endclass : uvma_i2c_mon_fsm_cntxt_c


function uvma_i2c_mon_fsm_cntxt_c::new(string name="uvma_i2c_mon_fsm_cntxt");

   super.new(name);

endfunction : new


function void uvma_i2c_mon_fsm_cntxt_c::reset();

   state                 = UVMA_I2C_MON_FSM_INIT;
   training_count        = 0;
   num_consecutive_edges = 0;
   trn_start             = 0;
   trn_end               = 0;
   data_q      .delete();
   timestamps_q.delete();
   trn_data = new[uvma_i2c_trn_length];

endfunction : reset


`endif // __UVMA_I2C_MON_FSM_CNTXT_SV__