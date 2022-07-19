// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_BASE_VSEQ_SV__
`define __UVMA_I2C_BASE_VSEQ_SV__


/**
 * Abstract Virtual Sequence from which all other I2C Virtual Sequences must extend.
 * Classes extending this one must be run on I2C Virtual Sequencer (uvma_i2c_vsqr_c) instance.
 */
class uvma_i2c_base_vseq_c extends uvml_vseq_c #(
   .REQ(uvma_i2c_seq_item_c),
   .RSP(uvma_i2c_seq_item_c)
);

   /// @defgroup Agent handles
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c  cntxt; ///< Agent context handle
   /// @}


   `uvm_object_utils(uvma_i2c_base_vseq_c)
   `uvm_declare_p_sequencer(uvma_i2c_vsqr_c)


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_base_vseq");

   /**
    * Assigns cfg and cntxt handles from p_sequencer.
    */
   extern virtual task pre_start();

   /**
    * Gets the next #req for transport sequences.
    */
   extern task upstream_get_next_item(ref uvm_sequence_item req);

   /**
    * Signals to the upstream sequencer that we're done driving #req.
    */
   extern task upstream_item_done(ref uvm_sequence_item req);

   /**
    * Writes #trn to #p_sequencer's C2T analysis port.
    */
   extern task write_c2t_mon_trn(ref uvma_i2c_mon_trn_c trn);

   /**
    * Writes #trn to #p_sequencer's T2C analysis port.
    */
   extern task write_t2c_mon_trn(ref uvma_i2c_mon_trn_c trn);

   /**
    * Gets the next C2T Phy transaction from the Monitor.
    */
   extern task get_c2t_phy_mon_trn(output uvma_i2c_phy_mon_trn_c trn);

   /**
    * Gets the next T2C Phy transaction from the Monitor.
    */
   extern task get_t2c_phy_mon_trn(output uvma_i2c_phy_mon_trn_c trn);

   /**
   * Waits for the next virtual interface clock edge.
    */
   extern task wait_clk();

endclass : uvma_i2c_base_vseq_c


function uvma_i2c_base_vseq_c::new(string name="uvma_i2c_base_vseq");

   super.new(name);

endfunction : new


task uvma_i2c_base_vseq_c::pre_start();

   cfg   = p_sequencer.cfg;
   cntxt = p_sequencer.cntxt;

endtask : pre_start


task uvma_i2c_base_vseq_c::upstream_get_next_item(ref uvm_sequence_item req);

   p_sequencer.upstream_sqr_port.get_next_item(req);

endtask : upstream_get_next_item


task uvma_i2c_base_vseq_c::upstream_item_done(ref uvm_sequence_item req);

   p_sequencer.upstream_sqr_port.item_done(req);

endtask : upstream_item_done


task uvma_i2c_base_vseq_c::write_c2t_mon_trn(ref uvma_i2c_mon_trn_c trn);

   p_sequencer.c2t_mon_trn_ap.write(trn);

endtask : write_c2t_mon_trn


task uvma_i2c_base_vseq_c::write_t2c_mon_trn(ref uvma_i2c_mon_trn_c trn);

   p_sequencer.t2c_mon_trn_ap.write(trn);

endtask : write_t2c_mon_trn


task uvma_i2c_base_vseq_c::get_c2t_phy_mon_trn(output uvma_i2c_phy_mon_trn_c trn);

   p_sequencer.c2t_phy_mon_trn_fifo.get(trn);

endtask : get_c2t_phy_mon_trn


task uvma_i2c_base_vseq_c::get_t2c_phy_mon_trn(output uvma_i2c_phy_mon_trn_c trn);

   p_sequencer.t2c_phy_mon_trn_fifo.get(trn);

endtask : get_t2c_phy_mon_trn


task uvma_i2c_base_vseq_c::wait_clk();

   case (cfg.drv_mode)
      UVMA_I2C_DIRECTION_C2T : @(cntxt.vif.drv_c2t_cb);
      UVMA_I2C_DIRECTION_T2C : @(cntxt.vif.drv_t2c_cb);
   endcase

endtask : wait_clk


`endif // __UVMA_I2C_BASE_VSEQ_SV__