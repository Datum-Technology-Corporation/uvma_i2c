// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_IDLE_VSEQ_SV__
`define __UVMA_I2C_IDLE_VSEQ_SV__


/**
 * Virtual Sequence generating IDLE Sequence Items at the lowest sequencer priority possible.
 */
class uvma_i2c_idle_vseq_c extends uvma_i2c_base_vseq_c;

   `uvm_object_utils(uvma_i2c_idle_vseq_c)

   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_idle_vseq");

   /**
    * Launches #idle_loop().
    */
   extern virtual task body();

   /**
    * Infinite loop generating IDLE Sequence Items.
    */
   extern task idle_loop();

endclass : uvma_i2c_idle_vseq_c


function uvma_i2c_idle_vseq_c::new(string name="uvma_i2c_idle_vseq");

   super.new(name);

endfunction : new


task uvma_i2c_idle_vseq_c::body();

   `uvm_info("I2C_IDLE_VSEQ", "Idle virtual sequence has started", UVM_HIGH)
   idle_loop();

endtask : body


task uvma_i2c_idle_vseq_c::idle_loop();

   uvma_i2c_seq_item_c  idle_seq_item;
   forever begin
      `uvm_create_on(idle_seq_item, p_sequencer)
      `uvm_rand_send_pri_with(idle_seq_item, `UVMA_I2C_IDLE_SEQ_ITEM_PRI, {
         header == UVMA_I2C_HEADER_IDLE;
      })
   end

endtask : idle_loop


`endif // __UVMA_I2C_IDLE_VSEQ_SV__