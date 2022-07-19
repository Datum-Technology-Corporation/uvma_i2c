// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 * This file contains sample code that demonstrates how to add a new test to the I2C UVM Agent Self-Test
// Bench and UVM Test Library.
 */


`ifndef __UVMT_I2C_ST_MY_TEST_SV__
`define __UVMT_I2C_ST_MY_TEST_SV__


/**
 * Test which runs virtual sequence 'my_vseq' for 100 items of stimulus.
 */
class uvmt_i2c_st_my_test_c extends uvmt_i2c_st_base_test_c;

   rand uvme_i2c_st_my_vseq_c  my_vseq; ///< Virtual Sequence to be run.


   `uvm_component_utils(uvmt_i2c_st_my_test_c)


   /**
    * Overrides default num_items.
    */
   constraint my_vseq_cons {
      my_vseq.num_items == 100;
   }


   /**
    * Creates #my_vseq.
    */
   extern function new(string name="uvmt_i2c_st_my_test", uvm_component parent=null);

   /**
    * Runs #my_vseq on #vsequencer.
    */
   extern virtual task main_phase(uvm_phase phase);

endclass : uvmt_i2c_st_my_test_c


function uvmt_i2c_st_my_test_c::new(string name="uvmt_i2c_st_my_test", uvm_component parent=null);

   super.new(name, parent);
   my_vseq = uvme_i2c_st_my_vseq_c::type_id::create("my_vseq");

endfunction : new


task uvmt_i2c_st_my_test_c::main_phase(uvm_phase phase);

   super.main_phase(phase);

   phase.raise_objection(this);
   `uvm_info("TEST", $sformatf("Starting my_vseq Virtual Sequence:\n%s", my_vseq.sprint()), UVM_NONE)
   my_vseq.start(vsequencer);
   `uvm_info("TEST", $sformatf("Finished my_vseq Virtual Sequence:\n%s", my_vseq.sprint()), UVM_NONE)
   phase.drop_objection(this);

endtask : main_phase


`endif // __UVMT_I2C_ST_MY_TEST_SV__