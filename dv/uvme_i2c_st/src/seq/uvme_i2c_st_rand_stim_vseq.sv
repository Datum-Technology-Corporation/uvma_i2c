// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_RAND_STIM_VSEQ_SV__
`define __UVME_I2C_ST_RAND_STIM_VSEQ_SV__


/**
 * Virtual Sequence sending a fixed number of completely random sequence items to ctlr and ctlr Virtual Sequencers.
 */
class uvme_i2c_st_rand_stim_vseq_c extends uvme_i2c_st_base_vseq_c;

   /// @defgroup Knobs
   /// @{
   rand int unsigned  num_c2t_seq_items; ///< Number of C2T Sequence Items to generate.
   rand int unsigned  num_t2c_seq_items; ///< Number of T2C Sequence Items to generate.
   /// @{


   `uvm_object_utils_begin(uvme_i2c_st_rand_stim_vseq_c)
       `uvm_field_int(num_c2t_seq_items, UVM_DEFAULT + UVM_DEC)
       `uvm_field_int(num_t2c_seq_items, UVM_DEFAULT + UVM_DEC)
   `uvm_object_utils_end


   /**
    * Sets safe defaults.
    */
   constraint defaults_cons {
      soft num_c2t_seq_items == uvme_i2c_st_rand_stim_default_num_seq_items;
      soft num_t2c_seq_items == uvme_i2c_st_rand_stim_default_num_seq_items;
   }


   /**
    * Default constructor.
    */
   extern function new(string name="uvme_i2c_st_rand_stim_vseq");

   /**
    * Generates Sequence Items in both directions.
    */
   extern virtual task body();

endclass : uvme_i2c_st_rand_stim_vseq_c


function uvme_i2c_st_rand_stim_vseq_c::new(string name="uvme_i2c_st_rand_stim_vseq");

   super.new(name);

endfunction : new


task uvme_i2c_st_rand_stim_vseq_c::body();

   uvma_i2c_seq_item_c  c2t_seq_item, t2c_seq_item;

   `uvm_info("I2C_ST_RAND_STIM_VSEQ", "Starting sequence", UVM_MEDIUM)
   fork
      begin
         `uvm_info("I2C_ST_RAND_STIM_VSEQ_C2T", "Starting stimulus", UVM_LOW)
         for (int unsigned ii=0; ii<num_c2t_seq_items; ii++) begin
            `uvm_info("I2C_ST_RAND_STIM_VSEQ_C2T", $sformatf("Starting item %0d/%0d", (ii+1), num_c2t_seq_items), UVM_HIGH)
            `uvm_do_on_pri_with(c2t_seq_item, p_sequencer.ctlr_vsequencer, uvme_i2c_st_rand_stim_sqr_priority, {
               header == UVMA_I2C_HEADER_DATA;
            })
            `uvm_info("I2C_ST_RAND_STIM_VSEQ_C2T", $sformatf("Finished item %0d/%0d", (ii+1), num_c2t_seq_items), UVM_HIGH)
         end
      end
      begin
         `uvm_info("I2C_ST_RAND_STIM_VSEQ_T2C", "Starting stimulus", UVM_LOW)
         for (int unsigned jj=0; jj<num_t2c_seq_items; jj++) begin
            `uvm_info("I2C_ST_RAND_STIM_VSEQ_T2C", $sformatf("Starting item %0d/%0d", (jj+1), num_t2c_seq_items), UVM_HIGH)
            `uvm_do_on_pri_with(t2c_seq_item, p_sequencer.tagt_vsequencer, uvme_i2c_st_rand_stim_sqr_priority, {
               header == UVMA_I2C_HEADER_DATA;
            })
            `uvm_info("I2C_ST_RAND_STIM_VSEQ_T2C", $sformatf("Finished item %0d/%0d", (jj+1), num_t2c_seq_items), UVM_HIGH)
         end
      end
   join

endtask : body


`endif // __UVME_I2C_ST_RAND_STIM_VSEQ_SV__