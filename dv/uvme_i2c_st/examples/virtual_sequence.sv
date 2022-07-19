// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 * This file contains sample code that demonstrates how to add a new Virtual Sequence to the I2C UVM Agent Self-Test Environment.
 */


`ifndef __UVME_I2C_MY_VSEQ_SV__
`define __UVME_I2C_MY_VSEQ_SV__


/**
 * Sample sequence that runs 5 (by default) fully random items in each direction.
 */
class uvme_i2c_st_my_vseq_c extends uvme_i2c_st_base_vseq_c;

   /// @defgroup Knobs
   /// @{
   rand int unsigned  num_items; ///< Number of sequence items to be generated.
   /// @}


   `uvm_object_utils_begin(uvme_i2c_st_my_vseq_c)
      `uvm_field_int(num_items, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Default values for random fields.
    */
   constraint defaults_cons {
      soft num_items == 5;
   }


   /**
    * Default constructor.
    */
   extern function new(string name="uvme_i2c_st_my_seq");

   /**
    * Generates #num_items of fully random reqs in each direction.
    */
   extern virtual task body();

endclass : uvme_i2c_st_my_vseq_c


function uvme_i2c_st_my_vseq_c::new(string name="uvme_i2c_st_my_seq");

   super.new(name);

endfunction : new


task uvme_i2c_st_my_vseq_c::body();

   fork
      begin
         repeat (num_items) begin
            `uvm_do_on(req, p_sequencer.ctlr_vsequencer)
         end
      end
      begin
         repeat (num_items) begin
            `uvm_do_on(req, p_sequencer.tagt_vsequencer)
         end
      end
   join

endtask : body


`endif __UVME_I2C_MY_VSEQ_SV__