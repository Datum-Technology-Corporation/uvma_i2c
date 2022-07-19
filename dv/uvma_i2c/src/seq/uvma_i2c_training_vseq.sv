// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_TRAINING_VSEQ_SV__
`define __UVMA_I2C_TRAINING_VSEQ_SV__


/**
 * Virtual Sequence generating the I2C link Phy training data.
 */
class uvma_i2c_training_vseq_c extends uvma_i2c_base_vseq_c;

   `uvm_object_utils(uvma_i2c_training_vseq_c)

   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_training_vseq");

   /**
    * Calls do_training_<x>().
    */
   extern virtual task body();

   /**
    * Generates training data Sequence Items for C2T.
    */
   extern task do_training_c2t();

   /**
    * Generates training data Sequence Items for T2C.
    */
   extern task do_training_t2c();

endclass : uvma_i2c_training_vseq_c


function uvma_i2c_training_vseq_c::new(string name="uvma_i2c_training_vseq");

   super.new(name);

endfunction : new


task uvma_i2c_training_vseq_c::body();

   `uvm_info("I2C_TRAINING_VSEQ", "Training Virtual Sequence has started", UVM_HIGH)
   case (cfg.drv_mode)
      UVMA_I2C_DRV_MODE_CTLR: do_training_c2t();
      UVMA_I2C_DRV_MODE_TAGT: do_training_t2c();
   endcase

endtask : body


task uvma_i2c_training_vseq_c::do_training_c2t();

   uvma_i2c_phy_seq_item_c  c2t_seq_item;

   do begin
      `uvm_create_on(c2t_seq_item, p_sequencer.c2t_sequencer)
      `uvm_rand_send_pri_with(c2t_seq_item, `UVMA_I2C_C2T_DRV_SEQ_ITEM_PRI, {
         dp == 0;
      })
   end while (cntxt.c2t_mon_fsm_cntxt.state != UVMA_I2C_MON_FSM_SYNCING);

endtask : do_training_c2t


task uvma_i2c_training_vseq_c::do_training_t2c();

   uvma_i2c_phy_seq_item_c  t2c_seq_item;

   do begin
      `uvm_create_on(t2c_seq_item, p_sequencer.t2c_sequencer)
      `uvm_rand_send_pri_with(t2c_seq_item, `UVMA_I2C_T2C_DRV_SEQ_ITEM_PRI, {
         dp == 0;
      })
   end while (cntxt.t2c_mon_fsm_cntxt.state != UVMA_I2C_MON_FSM_SYNCING);

endtask : do_training_t2c


`endif // __UVMA_I2C_TRAINING_VSEQ_SV__