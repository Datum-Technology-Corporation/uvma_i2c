// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_MON_SV__
`define __UVMA_I2C_MON_SV__


/**
 * Monitor sampling Phy Monitor Transactions from I2C Interface (uvma_i2c_if).
 * Also observes reset and updates the reset state in #cntxt.
 */
class uvma_i2c_mon_c extends uvml_mon_c;

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c  cntxt; ///< Agent context handle
   /// @}

   /// @defgroup Virtual Interface handles
   /// @{
   virtual uvma_i2c_if.mon_c2t_mp  c2t_mp; ///< Handle to C2T modport
   virtual uvma_i2c_if.mon_t2c_mp  t2c_mp; ///< Handle to T2C modport
   /// @}

   /// @defgroup TLM
   /// @{
   uvm_analysis_port #(uvma_i2c_phy_mon_trn_c)  c2t_ap; ///< Port outputting C2T Phy Monitor transactions.
   uvm_analysis_port #(uvma_i2c_phy_mon_trn_c)  t2c_ap; ///< Port outputting T2C Phy Monitor transactions.
   /// @}


   `uvm_component_utils_begin(uvma_i2c_mon_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_mon", uvm_component parent=null);

   /**
    * 1. Ensures #cfg & #cntxt handles are not null.
    * 2. Builds TLM Ports.
    * 3. Retrieves modport handles from #cntxt.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Infinite loop sampling a Phy Monitor Transaction in each direction at each clock cycle.
    */
   extern virtual task run_phase(uvm_phase phase);

   /**
    * Uses uvm_config_db to retrieve cfg.
    */
   extern function void get_cfg();

   /**
    * Uses uvm_config_db to retrieve cntxt.
    */
   extern function void get_cntxt();

   /**
    * Creates #c2t_ap & #t2c_ap.
    */
   extern function void create_tlm_ports();

   /**
    * Retrieves #c2t_mp & #t2c_mp from #cntxt.
    */
   extern function void retrieve_modports();

   /**
    * Updates the context's reset state.
    */
   extern task mon_reset();

   /**
    * Synchronous reset thread.
    */
   extern task mon_reset_sync();

   /**
    * Asynchronous reset thread.
    */
   extern task mon_reset_async();

   /**
    * Infinite loop that monitors #c2t_mp during run_phase().
    */
   extern task mon_c2t();

   /**
    * Infinite loop that monitors #t2c_mp during run_phase().
    */
   extern task mon_t2c();

   /**
    * Waits out each C2T clock cycle before reset.
    */
   extern task mon_c2t_pre_reset();

   /**
    * Waits out each T2C clock cycle before reset.
    */
   extern task mon_t2c_pre_reset();

   /**
    * Waits out each C2T clock cycle during reset.
    */
   extern task mon_c2t_in_reset();

   /**
    * Waits out each T2C clock cycle during reset.
    */
   extern task mon_t2c_in_reset();

   /**
    * Samples #c2t_mp after reset.
    */
   extern task mon_c2t_post_reset();

   /**
    * Samples #t2c_mp after reset.
    */
   extern task mon_t2c_post_reset();

   /**
    * Creates C2T Phy Monitor Transaction by sampling #c2t_mp signals.
    */
   extern task sample_c2t_trn(output uvma_i2c_phy_mon_trn_c trn);

   /**
    * Creates T2C Phy Monitor Transaction by sampling #t2c_mp signals.
    */
   extern task sample_t2c_trn(output uvma_i2c_phy_mon_trn_c trn);

   /**
    * Appends #cfg to #trn and prints it out.
    */
   extern function void process_c2t_trn(ref uvma_i2c_phy_mon_trn_c trn);

   /**
    * Appends #cfg to #trn and prints it out.
    */
   extern function void process_t2c_trn(ref uvma_i2c_phy_mon_trn_c trn);

endclass : uvma_i2c_mon_c


function uvma_i2c_mon_c::new(string name="uvma_i2c_mon", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_mon_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg          ();
   get_cntxt        ();
   create_tlm_ports ();
   retrieve_modports();

endfunction : build_phase


task uvma_i2c_mon_c::run_phase(uvm_phase phase);

   super.run_phase(phase);
   if (cfg.enabled) begin
      fork
         mon_reset();
         mon_c2t();
         mon_t2c();
      join_none
   end

endtask : run_phase


function void uvma_i2c_mon_c::get_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_MON", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvma_i2c_mon_c::get_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_MON", "Context handle is null")
   end

endfunction : get_cntxt


function void uvma_i2c_mon_c::create_tlm_ports();

   c2t_ap = new("c2t_ap", this);
   t2c_ap = new("t2c_ap", this);

endfunction : create_tlm_ports


function void uvma_i2c_mon_c::retrieve_modports();

   c2t_mp = cntxt.vif.mon_c2t_mp;
   t2c_mp = cntxt.vif.mon_t2c_mp;

endfunction : retrieve_modports


task uvma_i2c_mon_c::mon_reset();

   case (cfg.reset_type)
      UVML_RESET_TYPE_SYNCHRONOUS : mon_reset_sync ();
      UVML_RESET_TYPE_ASYNCHRONOUS: mon_reset_async();
      default: begin
         `uvm_fatal("I2C_MON", $sformatf("Illegal cfg.reset_type: %s", cfg.reset_type.name()))
      end
   endcase

endtask : mon_reset


task uvma_i2c_mon_c::mon_reset_sync();

   forever begin
      while (cntxt.vif.reset_n !== 1'b0) begin
         fork
            begin
               wait (cntxt.vif.c2t_clk === 0);
               wait (cntxt.vif.c2t_clk === 1);
            end
            begin
               wait (cntxt.vif.t2c_clk === 0);
               wait (cntxt.vif.t2c_clk === 1);
            end
         join
      end
      cntxt.reset_state = UVML_RESET_STATE_IN_RESET;
      `uvm_info("I2C_MON", "Entered IN_RESET state", UVM_MEDIUM)
      cntxt.reset();
      while (cntxt.vif.reset_n !== 1'b1) begin
         fork
            begin
               wait (cntxt.vif.c2t_clk === 0);
               wait (cntxt.vif.c2t_clk === 1);
            end
            begin
               wait (cntxt.vif.t2c_clk === 0);
               wait (cntxt.vif.t2c_clk === 1);
            end
         join
      end
      cntxt.reset_state = UVML_RESET_STATE_POST_RESET;
      `uvm_info("I2C_MON", "Entered POST_RESET state", UVM_MEDIUM)
   end

endtask : mon_reset_sync


task uvma_i2c_mon_c::mon_reset_async();

   forever begin
      wait (cntxt.vif.reset_n === 0);
      cntxt.reset_state = UVML_RESET_STATE_IN_RESET;
      `uvm_info("I2C_MON", "Entered IN_RESET state", UVM_MEDIUM)
      cntxt.reset();
      wait (cntxt.vif.reset_n === 1);
      cntxt.reset_state = UVML_RESET_STATE_POST_RESET;
      `uvm_info("I2C_MON", "Entered POST_RESET state", UVM_MEDIUM)
   end

endtask : mon_reset_async


task uvma_i2c_mon_c::mon_c2t();

   forever begin
      case (cntxt.reset_state)
         UVML_RESET_STATE_PRE_RESET : mon_c2t_pre_reset ();
         UVML_RESET_STATE_IN_RESET  : mon_c2t_in_reset  ();
         UVML_RESET_STATE_POST_RESET: mon_c2t_post_reset();
      endcase
   end

endtask : mon_c2t


task uvma_i2c_mon_c::mon_t2c();

   forever begin
      case (cntxt.reset_state)
         UVML_RESET_STATE_PRE_RESET : mon_t2c_pre_reset ();
         UVML_RESET_STATE_IN_RESET  : mon_t2c_in_reset  ();
         UVML_RESET_STATE_POST_RESET: mon_t2c_post_reset();
      endcase
   end

endtask : mon_t2c


task uvma_i2c_mon_c::mon_c2t_pre_reset();
   @(c2t_mp.mon_c2t_cb);
endtask : mon_c2t_pre_reset


task uvma_i2c_mon_c::mon_t2c_pre_reset();
   @(t2c_mp.mon_t2c_cb);
endtask : mon_t2c_pre_reset


task uvma_i2c_mon_c::mon_c2t_in_reset();
   @(c2t_mp.mon_c2t_cb);
endtask : mon_c2t_in_reset


task uvma_i2c_mon_c::mon_t2c_in_reset();
   @(t2c_mp.mon_t2c_cb);
endtask : mon_t2c_in_reset


task uvma_i2c_mon_c::mon_c2t_post_reset();

   uvma_i2c_phy_mon_trn_c  trn;

   sample_c2t_trn (trn);
   process_c2t_trn(trn);
   c2t_ap.write   (trn);

endtask : mon_c2t_post_reset


task uvma_i2c_mon_c::mon_t2c_post_reset();

   uvma_i2c_phy_mon_trn_c  trn;

   sample_t2c_trn (trn);
   process_t2c_trn(trn);
   t2c_ap.write   (trn);

endtask : mon_t2c_post_reset


task uvma_i2c_mon_c::sample_c2t_trn(output uvma_i2c_phy_mon_trn_c trn);

   @(c2t_mp.mon_c2t_cb);
   `uvm_info("I2C_MON_C2T", "Sampling Phy transaction", UVM_DEBUG)
   trn = uvma_i2c_phy_mon_trn_c::type_id::create("trn");
   trn.dp = c2t_mp.mon_c2t_cb.c2tp;
   trn.dn = c2t_mp.mon_c2t_cb.c2tn;

endtask : sample_c2t_trn


task uvma_i2c_mon_c::sample_t2c_trn(output uvma_i2c_phy_mon_trn_c trn);

   @(t2c_mp.mon_t2c_cb);
   `uvm_info("I2C_MON_T2C", "Sampling Phy transaction", UVM_DEBUG)
   trn = uvma_i2c_phy_mon_trn_c::type_id::create("trn");
   trn.dp = t2c_mp.mon_t2c_cb.t2cp;
   trn.dn = t2c_mp.mon_t2c_cb.t2cn;

endtask : sample_t2c_trn


function void uvma_i2c_mon_c::process_c2t_trn(ref uvma_i2c_phy_mon_trn_c trn);

   trn.cfg = cfg;
   trn.set_initiator(this);
   trn.set_timestamp_end($realtime());
   `uvm_info("I2C_MON_C2T", $sformatf("Sampled Phy transaction from the virtual interface:\n%s", trn.sprint()), UVM_DEBUG)

endfunction : process_c2t_trn


function void uvma_i2c_mon_c::process_t2c_trn(ref uvma_i2c_phy_mon_trn_c trn);

   trn.cfg = cfg;
   trn.set_initiator(this);
   trn.set_timestamp_end($realtime());
   `uvm_info("I2C_MON_T2C", $sformatf("Sampled Phy transaction from the virtual interface:\n%s", trn.sprint()), UVM_DEBUG)

endfunction : process_t2c_trn


`endif // __UVMA_I2C_MON_SV__