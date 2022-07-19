// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_TRANSPORT_BASE_VSEQ_SV__
`define __UVMA_I2C_TRANSPORT_BASE_VSEQ_SV__


/**
 * Abstract Virtual Sequence from which other I2C transport sequences extend.
 */
class uvma_i2c_transport_base_vseq_c extends uvma_i2c_base_vseq_c;

   `uvm_object_utils(uvma_i2c_transport_base_vseq_c)

   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_transport_base_vseq");

   /**
    * Pulls upstream Sequence Items and calls #process_payload() for each.
    */
   extern virtual task body();

   /**
    * Hook for extending classes.  Pure virtual.
    */
   extern virtual task process_payload(uvm_sequence_item payload);

endclass : uvma_i2c_transport_base_vseq_c


function uvma_i2c_transport_base_vseq_c::new(string name="uvma_i2c_transport_base_vseq");

   super.new(name);

endfunction : new


task uvma_i2c_transport_base_vseq_c::body();

   uvm_sequence_item  payload;

   `uvm_info("I2C_TRANSPORT_BASE_VSEQ", "Transport base virtual sequence has started", UVM_HIGH)
   forever begin
      upstream_get_next_item(payload);
      process_payload       (payload);
      upstream_item_done    (payload);
   end

endtask : body


task uvma_i2c_transport_base_vseq_c::process_payload(uvm_sequence_item payload);



endtask : process_payload


`endif // __UVMA_I2C_TRANSPORT_BASE_VSEQ_SV__