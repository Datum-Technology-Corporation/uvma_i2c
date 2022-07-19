// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This file contains sample code that demonstrates how to add a new sequence to the I2C UVM Agent.


`ifndef __UVMA__MY_SEQ_SV__
`define __UVMA__MY_SEQ_SV__


/**
 * Sample sequence that runs 5 fully random items by default.
 */
class uvma_i2c_my_seq_c extends uvma_i2c_base_vseq_c;

   /// @defgroup Knobs
   /// @{
   rand int unsigned  num_items; ///< Number of sequence items to be generated.
   /// @ }}


   `uvm_object_utils_begin(uvma_i2c_my_seq_c)
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
   extern function new(string name="uvma_i2c_my_seq");

   /**
    * Generates num_items of fully random reqs.
    */
   extern virtual task body();

endclass : uvma_i2c_my_seq_c


function uvma_i2c_my_seq_c::new(string name="uvma_i2c_my_seq");

   super.new(name);

endfunction : new


task uvma_i2c_my_seq_c::body();

   repeat (num_items) begin
      `uvm_do(req)
   end

endtask : body


`endif __UVMA__MY_SEQ_SV__