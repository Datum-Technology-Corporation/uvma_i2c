// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_PHY_DRV_VSEQ_SV__
`define __UVMA_I2C_PHY_DRV_VSEQ_SV__


/**
 * Virtual Sequence taking in uvma_i2c_seq_item_c instances and driving uvma_i2c_phy_drv_c with Phy Sequence Items
 * (uvma_i2c_phy_seq_item_c) in either direction.
 */
class uvma_i2c_phy_drv_vseq_c extends uvma_i2c_base_vseq_c;

   `uvm_object_utils(uvma_i2c_phy_drv_vseq_c)

   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_phy_drv_vseq");

   /**
    * Infinite loop maintaining two threads:
    * 1. Main sequence: wait for reset, link training, drive traffic
    * 2. Reset trigger for mid-sim reset which resets the main sequence.
    */
   extern virtual task body();

   /**
    * Wait for reset state change in #cntxt.
    */
   extern task wait_for_reset();

   /**
    * Waits for monitor to be ready for bitstream.
    */
   extern task post_reset_init();

   /**
    * Infinite loop taking in and converting uvma_i2c_seq_item_c instances to uvma_i2c_phy_seq_item_c.
    */
   extern task drv_loop();

   /**
    * Waits for mid-sim reset state change in #cntxt.
    */
   extern task reset_trigger();

   /**
    * Modifies #seq_item before packing it.
    */
   extern function void process_seq_item(ref uvma_i2c_seq_item_c seq_item);

   /**
    * Packs #seq_item and produces a uvma_i2c_phy_seq_item_c instance for each packed bit.
    */
   extern virtual task drive(ref uvma_i2c_seq_item_c seq_item);

endclass : uvma_i2c_phy_drv_vseq_c


function uvma_i2c_phy_drv_vseq_c::new(string name="uvma_i2c_phy_drv_vseq");

   super.new(name);

endfunction : new


task uvma_i2c_phy_drv_vseq_c::body();

   `uvm_info("I2C_PHY_DRV_VSEQ", "Phy Driver Virtual Sequence has started", UVM_HIGH)
   forever begin
      fork
         begin : main
            wait_for_reset ();
            post_reset_init();
            drv_loop       ();
         end
         begin : reset
            reset_trigger();
         end
      join_any
      disable fork;
   end

endtask : body


task uvma_i2c_phy_drv_vseq_c::wait_for_reset();

   `uvm_info("I2C_PHY_DRV_VSEQ", "Waiting for post_reset", UVM_HIGH)
   wait (cntxt.reset_state == UVML_RESET_STATE_POST_RESET);
   `uvm_info("I2C_PHY_DRV_VSEQ", "Done waiting for post_reset", UVM_HIGH)

endtask : wait_for_reset


task uvma_i2c_phy_drv_vseq_c::post_reset_init();

    uvma_i2c_training_vseq_c  training_vseq;
   `uvm_info("I2C_PHY_DRV_VSEQ", {"Starting training sequence:\n", training_vseq.sprint()}, UVM_HIGH)
   `uvm_do_on(training_vseq, p_sequencer)
   `uvm_info("I2C_PHY_DRV_VSEQ", {"Finished training sequence:\n", training_vseq.sprint()}, UVM_HIGH)
   `uvm_info("I2C_PHY_DRV_VSEQ", "Waiting for SYNCING state", UVM_HIGH)
   case (cfg.drv_mode)
      UVMA_I2C_DIRECTION_C2T : begin
         wait (cntxt.c2t_mon_fsm_cntxt.state == UVMA_I2C_MON_FSM_SYNCING);
      end
      UVMA_I2C_DIRECTION_T2C : begin
         wait (cntxt.t2c_mon_fsm_cntxt.state == UVMA_I2C_MON_FSM_SYNCING);
      end
   endcase
   `uvm_info("I2C_PHY_DRV_VSEQ", "Done waiting for SYNCING state", UVM_HIGH)

endtask : post_reset_init


task uvma_i2c_phy_drv_vseq_c::drv_loop();

   uvma_i2c_seq_item_c  seq_item;

   forever begin
      `uvm_info("I2C_PHY_DRV_VSEQ", "Waiting for next seq_item", UVM_DEBUG)
      p_sequencer.get_next_item    (seq_item);
      `uvm_info("I2C_PHY_DRV_VSEQ", $sformatf("Received seq_item:\n%s", seq_item.sprint()), UVM_DEBUG)
      process_seq_item             (seq_item);
      drive                        (seq_item);
      p_sequencer.seq_item_ap.write(seq_item);
      `uvm_info("I2C_PHY_DRV_VSEQ", {"Done with seq_item:\n", seq_item.sprint()}, UVM_DEBUG)
      p_sequencer.item_done();
   end

endtask : drv_loop


task uvma_i2c_phy_drv_vseq_c::reset_trigger();

   wait (cntxt.reset_state == UVML_RESET_STATE_POST_RESET);
   wait (cntxt.reset_state != UVML_RESET_STATE_POST_RESET);
   `uvm_info("I2C_PHY_DRV_VSEQ", "Mid-sim reset detected. Resetting main loop, this may kill some sequences.", UVM_NONE)

endtask : reset_trigger


function void uvma_i2c_phy_drv_vseq_c::process_seq_item(ref uvma_i2c_seq_item_c seq_item);

   seq_item.cfg = cfg;
   `uvm_info("I2C_PHY_DRV_VSEQ", $sformatf("Processed seq_item:\n%s", seq_item.sprint()), UVM_DEBUG)
   if (seq_item.header == UVMA_I2C_HEADER_DATA) begin
      `uvml_hrtbt_owner(p_sequencer)
   end

endfunction : process_seq_item


task uvma_i2c_phy_drv_vseq_c::drive(ref uvma_i2c_seq_item_c seq_item);

   uvma_i2c_phy_seq_item_c  req;
   bit           seq_item_bits[];
   int unsigned  num_seq_item_bits;

   uvm_default_packer.big_endian = uvma_i2c_big_endian;
   num_seq_item_bits = seq_item.pack(seq_item_bits);
   `uvm_info("I2C_PHY_DRV_VSEQ", $sformatf("Driving %0d bits of serial data", num_seq_item_bits), UVM_DEBUG)
   for (int unsigned ii=0; ii<num_seq_item_bits; ii++) begin
      case (cfg.drv_mode)
         UVMA_I2C_DIRECTION_C2T : begin
            `uvm_create_on(req, p_sequencer.c2t_sequencer)
            `uvm_rand_send_pri_with(req, `UVMA_I2C_C2T_DRV_SEQ_ITEM_PRI, {
               dp == seq_item_bits[ii];
            })
         end
         UVMA_I2C_DIRECTION_T2C : begin
            `uvm_create_on(req, p_sequencer.t2c_sequencer)
            `uvm_rand_send_pri_with(req, `UVMA_I2C_T2C_DRV_SEQ_ITEM_PRI, {
               dp == seq_item_bits[ii];
            })
         end
      endcase
   end
   `uvm_info("I2C_PHY_DRV_VSEQ", $sformatf("Finished driving %0d bits of serial data", num_seq_item_bits), UVM_DEBUG)

endtask : drive


`endif // __UVMA_I2C_PHY_DRV_VSEQ_SV__