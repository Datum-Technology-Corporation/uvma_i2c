// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_COV_MODEL_SV__
`define __UVME_I2C_ST_COV_MODEL_SV__


/**
 * Component encapsulating  UVM Agent Self-Test Functional Coverage Model.
 */
class uvme_i2c_st_cov_model_c extends uvma_i2c_cov_model_c;


   `uvm_component_utils(uvme_i2c_st_cov_model_c)


   /**
    * Agent configuration functional coverage.
    */
   covergroup i2c_st_cfg_cg;
      bypass_mode_cpt     : coverpoint cfg.bypass_mode    ;
      is_active_cpt       : coverpoint cfg.is_active      ;
      reset_type_cpt      : coverpoint cfg.reset_type     ;
      trn_log_enabled_cpt : coverpoint cfg.trn_log_enabled;
      drv_mode_cpt        : coverpoint cfg.drv_mode       ;
   endgroup : i2c_st_cfg_cg

   /**
    * Agent context functional coverage.
    */
   covergroup i2c_st_cntxt_cg;
      c2t_cntxt_state_cpt : coverpoint cntxt.c2t_mon_fsm_cntxt.state;
      t2c_cntxt_state_cpt : coverpoint cntxt.t2c_mon_fsm_cntxt.state;
   endgroup : i2c_st_cntxt_cg

   /**
    * Sequence item functional coverage.
    */
   covergroup i2c_st_seq_item_cg;
      header_cpt : coverpoint seq_item.header;
   endgroup : i2c_st_seq_item_cg

   /**
    * C2T Monitor Transaction functional coverage.
    */
   covergroup i2c_st_c2t_mon_trn_cg;
      header_cpt : coverpoint c2t_mon_trn.header;
   endgroup : i2c_st_c2t_mon_trn_cg

   /**
    * T2C Monitor Transaction functional coverage.
    */
   covergroup i2c_st_t2c_mon_trn_cg;
      header_cpt : coverpoint t2c_mon_trn.header;
   endgroup : i2c_st_t2c_mon_trn_cg

   /**
    * C2T Phy Sequence Item functional coverage.
    */
   covergroup i2c_st_c2t_phy_seq_item_cg;
      // TODO Implement i2c_st_c2t_phy_seq_item_cg
      //      Ex: abc_cpt : coverpoint c2t_phy_seq_item.abc;
      //          xyz_cpt : coverpoint c2t_phy_seq_item.xyz;
   endgroup : i2c_st_c2t_phy_seq_item_cg

   /**
    * T2C Phy Sequence Item functional coverage.
    */
   covergroup i2c_st_t2c_phy_seq_item_cg;
      // TODO Implement i2c_st_c2t_phy_seq_item_cg
      //      Ex: abc_cpt : coverpoint t2c_phy_seq_item.abc;
      //          xyz_cpt : coverpoint t2c_phy_seq_item.xyz;
   endgroup : i2c_st_t2c_phy_seq_item_cg

   /**
    * C2T Phy Monitor Transaction functional coverage.
    */
   covergroup i2c_st_c2t_phy_mon_trn_cg;
      // TODO Implement i2c_st_c2t_phy_mon_trn_cg
      //      Ex: abc_cpt : coverpoint c2t_phy_mon_trn.abc;
      //          xyz_cpt : coverpoint c2t_phy_mon_trn.xyz;
   endgroup : i2c_st_c2t_phy_mon_trn_cg

   /**
    * T2C Phy Monitor Transaction functional coverage.
    */
   covergroup i2c_st_t2c_phy_mon_trn_cg;
      // TODO Implement i2c_st_c2t_phy_mon_trn_cg
      //      Ex: abc_cpt : coverpoint t2c_phy_mon_trn.abc;
      //          xyz_cpt : coverpoint t2c_phy_mon_trn.xyz;
   endgroup : i2c_st_t2c_phy_mon_trn_cg


   /**
    * Default constructor.
    */
   extern function new(string name="uvme_i2c_st_cov_model", uvm_component parent=null);

   /**
    * Samples #cfg.
    */
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);

   /**
    * Samples i2c_st_cfg_cg.
    */
   extern virtual function void sample_cfg();

   /**
    * Samples i2c_st_cntxt_cg.
    */
   extern virtual function void sample_cntxt();

   /**
    * Samples i2c_st_seq_item_cg.
    */
   extern virtual function void sample_seq_item();

   /**
    * Samples i2c_st_c2t_mon_trn_cg.
    */
   extern virtual function void sample_c2t_mon_trn();

   /**
    * Samples i2c_st_t2c_mon_trn_cg.
    */
   extern virtual function void sample_t2c_mon_trn();

   /**
    * Samples i2c_st_c2t_phy_seq_item_cg.
    */
   extern virtual function void sample_c2t_phy_seq_item();

   /**
    * Samples i2c_st_t2c_phy_seq_item_cg.
    */
   extern virtual function void sample_t2c_phy_seq_item();

   /**
    * Samples i2c_st_c2t_phy_mon_trn_cg.
    */
   extern virtual function void sample_c2t_phy_mon_trn();

   /**
    * Samples i2c_st_t2c_phy_mon_trn_cg.
    */
   extern virtual function void sample_t2c_phy_mon_trn();

endclass : uvme_i2c_st_cov_model_c


function uvme_i2c_st_cov_model_c::new(string name="uvme_i2c_st_cov_model", uvm_component parent=null);

   super.new(name, parent);
   i2c_st_cfg_cg      = new();
   i2c_st_cntxt_cg    = new();
   i2c_st_seq_item_cg = new();
   i2c_st_c2t_mon_trn_cg      = new();
   i2c_st_t2c_mon_trn_cg      = new();
   i2c_st_c2t_phy_seq_item_cg = new();
   i2c_st_t2c_phy_seq_item_cg = new();
   i2c_st_c2t_phy_mon_trn_cg  = new();
   i2c_st_t2c_phy_mon_trn_cg  = new();

endfunction : new


function void uvme_i2c_st_cov_model_c::end_of_elaboration_phase(uvm_phase phase);

   super.end_of_elaboration_phase(phase);
   sample_cfg();

endfunction : end_of_elaboration_phase


function void uvme_i2c_st_cov_model_c::sample_cfg();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling Configuration:\n%s", cfg.sprint()), UVM_DEBUG)
  i2c_st_cfg_cg.sample();

endfunction : sample_cfg


function void uvme_i2c_st_cov_model_c::sample_cntxt();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling Context:\n%s", cntxt.sprint()), UVM_DEBUG)
   i2c_st_cntxt_cg.sample();

endfunction : sample_cntxt


function void uvme_i2c_st_cov_model_c::sample_seq_item();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling Sequence Item:\n%s", seq_item.sprint()), UVM_DEBUG)
   i2c_st_seq_item_cg.sample();

endfunction : sample_seq_item


function void uvme_i2c_st_cov_model_c::sample_c2t_mon_trn();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling C2T Monitor Transaction:\n%s", c2t_mon_trn.sprint()), UVM_DEBUG)
   i2c_st_c2t_mon_trn_cg.sample();

endfunction : sample_c2t_mon_trn


function void uvme_i2c_st_cov_model_c::sample_t2c_mon_trn();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling T2C Monitor Transaction:\n%s", t2c_mon_trn.sprint()), UVM_DEBUG)
   i2c_st_t2c_mon_trn_cg.sample();

endfunction : sample_t2c_mon_trn


function void uvme_i2c_st_cov_model_c::sample_c2t_phy_seq_item();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling C2T Phy Sequence Item:\n%s", c2t_phy_seq_item.sprint()), UVM_DEBUG)
   i2c_st_c2t_phy_seq_item_cg.sample();

endfunction : sample_c2t_phy_seq_item


function void uvme_i2c_st_cov_model_c::sample_t2c_phy_seq_item();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling T2C Phy Sequence Item:\n%s", t2c_phy_seq_item.sprint()), UVM_DEBUG)
   i2c_st_t2c_phy_seq_item_cg.sample();

endfunction : sample_t2c_phy_seq_item


function void uvme_i2c_st_cov_model_c::sample_c2t_phy_mon_trn();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling C2T Phy Monitor Transaction:\n%s", c2t_phy_mon_trn.sprint()), UVM_DEBUG)
   i2c_st_c2t_phy_mon_trn_cg.sample();

endfunction : sample_c2t_phy_mon_trn


function void uvme_i2c_st_cov_model_c::sample_t2c_phy_mon_trn();

   `uvm_info("UVME_I2C_ST_COV_MODEL", $sformatf("Sampling T2C Phy Monitor Transaction:\n%s", t2c_phy_mon_trn.sprint()), UVM_DEBUG)
   i2c_st_t2c_phy_mon_trn_cg.sample();

endfunction : sample_t2c_phy_mon_trn


`endif // __UVME_I2C_ST_COV_MODEL_SV__