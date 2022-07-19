// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_I2C_ST_RAND_STIM_TEST_SV__
`define __UVMT_I2C_ST_RAND_STIM_TEST_SV__


/**
 * Test running uvme_${name}_st_rand_stim_vseq_c with default parameters and scoreboarding enabled.
 */
class uvmt_i2c_st_rand_stim_test_c extends uvmt_i2c_st_base_test_c;

   rand uvme_i2c_st_rand_stim_vseq_c  rand_stim_vseq; ///< Virtual Sequence to be run during #main_phase()


   `uvm_component_utils(uvmt_i2c_st_rand_stim_test_c)


   /**
    * Overrides number of stimulus items to drive with CLI argument (if present).
    */
   constraint rand_stim_vseq_cons {
      if (test_cfg.cli_num_seq_items_override) {
         rand_stim_vseq.num_c2t_seq_items == test_cfg.cli_num_seq_items_parsed;
         rand_stim_vseq.num_t2c_seq_items == test_cfg.cli_num_seq_items_parsed;
      }
   }


   /**
    * Creates rand_stim_vseq.
    */
   extern function new(string name="uvmt_i2c_st_rand_stim_test", uvm_component parent=null);

   /**
    * Runs rand_stim_vseq on vsequencer.
    */
   extern virtual task main_phase(uvm_phase phase);

   /**
    * Checks that all scoreboards have number of matches equal to number of Sequence Items specified to be generated.
    */
   extern virtual function void check_phase(uvm_phase phase);

endclass : uvmt_i2c_st_rand_stim_test_c


function uvmt_i2c_st_rand_stim_test_c::new(string name="uvmt_i2c_st_rand_stim_test", uvm_component parent=null);

   super.new(name, parent);
   rand_stim_vseq = uvme_i2c_st_rand_stim_vseq_c::type_id::create("rand_stim_vseq");

endfunction : new


task uvmt_i2c_st_rand_stim_test_c::main_phase(uvm_phase phase);

   super.main_phase(phase);
   phase.raise_objection(this);
   `uvm_info("TEST", $sformatf("Starting rand_stim virtual sequence:\n%s", rand_stim_vseq.sprint()), UVM_NONE)
   rand_stim_vseq.start(vsequencer);
   `uvm_info("TEST", $sformatf("Finished rand_stim virtual sequence:\n%s", rand_stim_vseq.sprint()), UVM_NONE)
   phase.drop_objection(this);

endtask : main_phase


function void uvmt_i2c_st_rand_stim_test_c::check_phase(uvm_phase phase);

   super.check_phase(phase);
   if (env_cfg.scoreboarding_enabled) begin
      if (env_cntxt.sb_c2t_cntxt.match_count < rand_stim_vseq.num_c2t_seq_items) begin
         `uvm_error("TEST", $sformatf("C2T scoreboard saw less than %0d matches: %0d", rand_stim_vseq.num_c2t_seq_items, env_cntxt.sb_c2t_cntxt.match_count))
      end
      if (env_cntxt.sb_t2c_cntxt.match_count < rand_stim_vseq.num_t2c_seq_items) begin
         `uvm_error("TEST", $sformatf("T2C scoreboard saw less than %0d matches: %0d", rand_stim_vseq.num_t2c_seq_items, env_cntxt.sb_t2c_cntxt.match_count))
      end
      if (env_cntxt.sb_ctlr_cntxt.match_count < rand_stim_vseq.num_c2t_seq_items) begin
         `uvm_error("TEST", $sformatf("CTLR scoreboard saw less than %0d matches: %0d", rand_stim_vseq.num_c2t_seq_items, env_cntxt.sb_ctlr_cntxt.match_count))
      end
      if (env_cntxt.sb_tagt_cntxt.match_count < rand_stim_vseq.num_t2c_seq_items) begin
         `uvm_error("TEST", $sformatf("TAGT scoreboard saw less than %0d matches: %0d", rand_stim_vseq.num_t2c_seq_items, env_cntxt.sb_tagt_cntxt.match_count))
      end
   end

endfunction : check_phase


`endif // __UVMT_I2C_ST_RAND_STIM_TEST_SV__