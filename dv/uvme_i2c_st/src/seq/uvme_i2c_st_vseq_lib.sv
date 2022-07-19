// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_VSEQ_LIB_SV__
`define __UVME_I2C_ST_VSEQ_LIB_SV__


`include "uvme_i2c_st_base_vseq.sv"
`include "uvme_i2c_st_rand_stim_vseq.sv"


/**
 * Object cataloging I2C self-test environment's virtual sequences.
 */
class uvme_i2c_st_vseq_lib_c extends uvml_seq_lib_c #(
   .REQ(uvm_sequence_item),
   .RSP(uvm_sequence_item)
);

   `uvm_object_utils          (uvme_i2c_st_vseq_lib_c)
   `uvm_sequence_library_utils(uvme_i2c_st_vseq_lib_c)

   /**
    * 1. Initializes sequence library
    * 2. Adds sequences to library
    */
   extern function new(string name="uvme_i2c_st_vseq_lib");

endclass : uvme_i2c_st_vseq_lib_c


function uvme_i2c_st_vseq_lib_c::new(string name="uvme_i2c_st_vseq_lib");

   super.new(name);
   init_sequence_library();
   add_sequence(uvme_i2c_st_rand_stim_vseq_c::get_type());

endfunction : new


`endif // __UVME_I2C_ST_VSEQ_LIB_SV__