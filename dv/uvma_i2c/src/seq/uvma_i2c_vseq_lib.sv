// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_VSEQ_LIB_SV__
`define __UVMA_I2C_VSEQ_LIB_SV__


`include "uvma_i2c_transport_base_vseq.sv"


/**
 * Object holding traffic sequence library for I2C agent.
 */
class uvma_i2c_vseq_lib_c extends uvml_vseq_lib_c #(
   .REQ(uvma_i2c_seq_item_c),
   .RSP(uvma_i2c_seq_item_c)
);

   `uvm_object_utils          (uvma_i2c_vseq_lib_c)
   `uvm_sequence_library_utils(uvma_i2c_vseq_lib_c)


   /**
    * Initializes sequence library.
    */
   extern function new(string name="uvma_i2c_vseq_lib");

endclass : uvma_i2c_vseq_lib_c


function uvma_i2c_vseq_lib_c::new(string name="uvma_i2c_vseq_lib");

   super.new(name);
   init_sequence_library();
   // Register sequences here
   // Ex: add_sequence(uvma_i2c_my_vseq_c::get_type());

endfunction : new


`endif // __UVMA_I2C_VSEQ_LIB_SV__