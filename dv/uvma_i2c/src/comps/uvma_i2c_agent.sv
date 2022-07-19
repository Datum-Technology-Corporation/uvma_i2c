// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_AGENT_SV__
`define __UVMA_I2C_AGENT_SV__


/**
 * Top-level component that encapsulates, builds and connects all others.  Capable of driving/monitoring the I2C.
 */
class uvma_i2c_agent_c extends uvml_agent_c;

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Configuration handle.  Must be provided by component instantiating this Agent.
   uvma_i2c_cntxt_c  cntxt; ///< Context handle.  Can be provided by component instantiating this Agent.
   /// @}

   /// @defgroup Components
   /// @{
   uvma_i2c_vsqr_c       vsequencer; ///< Provides sequence items for #driver.
   uvma_i2c_drv_c        driver    ; ///< Drives Virtual Interface (uvma_i2c_if) with stimulus obtained from #sequencer.
   uvma_i2c_mon_c        monitor   ; ///< Samples transactions from Virtual Interface (uvma_i2c_if).
   uvma_i2c_cov_model_c  cov_model ; ///< Functional coverage model sampling #cfg, #cntxt and all transactions.
   uvma_i2c_logger_c     logger    ; ///< Transaction logger for #vsequencer, #driver and #monitor.
   /// @}

   /// @defgroup TLM
   /// @{
   uvm_seq_item_pull_port #(uvm_sequence_item)  upstream_sqr_port; ///< Upstream Sequencer Port for transport sequences.
   uvm_analysis_port  #(uvma_i2c_seq_item_c)  seq_item_ap  ; ///< Port outputting DATA Sequence Items.
   uvm_analysis_port  #(uvma_i2c_mon_trn_c )  c2t_mon_trn_ap; ///< Port outputting C2T Monitor Transactions.
   uvm_analysis_port  #(uvma_i2c_mon_trn_c )  t2c_mon_trn_ap; ///< Port outputting T2C Monitor Transactions.
   uvm_analysis_port  #(uvma_i2c_phy_seq_item_c)  c2t_phy_seq_item_ap; ///< Port outputting C2T Phy Sequence Items from #driver.
   uvm_analysis_port  #(uvma_i2c_phy_seq_item_c)  t2c_phy_seq_item_ap; ///< Port outputting T2C Phy Sequence Items from #driver.
   uvm_analysis_port  #(uvma_i2c_phy_mon_trn_c )  c2t_phy_mon_trn_ap; ///< Port outputting C2T Phy Monitor Transactions from #monitor.
   uvm_analysis_port  #(uvma_i2c_phy_mon_trn_c )  t2c_phy_mon_trn_ap; ///< Port outputting T2C Phy Monitor Transactions from #monitor.
   /// @}


   `uvm_component_utils_begin(uvma_i2c_agent_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_agent", uvm_component parent=null);

   /**
    * 1. Ensures cfg & cntxt handles are not null
    * 2. Builds all components
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * 1. Links agent's analysis ports to sub-components'
    * 2. Connects coverage models and loggers
    */
   extern virtual function void connect_phase(uvm_phase phase);

   /**
    * Starts Virtual Sequences on #vsequencer vital both for driving and monitoring.
    */
   extern virtual task run_phase(uvm_phase phase);

   /**
    * Uses uvm_config_db to retrieve cfg and hand out to sub-components.
    */
   extern function void get_and_set_cfg();

   /**
    * Uses uvm_config_db to retrieve cntxt and hand out to sub-components.
    */
   extern function void get_and_set_cntxt();

   /**
    * Uses uvm_config_db to retrieve the Virtual Interface (vif) assigned to this agent.
    */
   extern function void retrieve_vif();

   /**
    * Creates sub-components.
    */
   extern function void create_components();

   /**
    * Connects #vsequencer to #monitor and #driver's TLM ports.
    */
   extern function void connect_sequencer;

   /**
    * Connects agent's TLM ports to #driver's and #monitor's.
    */
   extern function void connect_analysis_ports();

   /**
    * Connects #cov_model to #monitor and #driver's analysis ports.
    */
   extern function void connect_cov_model();

   /**
    * Connects #logger to #monitor and #driver's analysis ports.
    */
   extern function void connect_logger();

   /**
    * Starts Monitoring Virtual Sequence.
    */
   extern task start_mon_vseq();

   /**
    * Starts IDLE Generating Virtual Sequence.
    */
   extern task start_idle_vseq();

   /**
    * Starts C2T Driver Virtual Sequence.
    */
   extern task start_drv_vseq_ctlr();

   /**
    * Starts T2C Driver Virtual Sequence.
    */
   extern task start_drv_vseq_tagt();

endclass : uvma_i2c_agent_c


function uvma_i2c_agent_c::new(string name="uvma_i2c_agent", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_agent_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_and_set_cfg  ();
   get_and_set_cntxt();
   retrieve_vif     ();
   create_components();

endfunction : build_phase


function void uvma_i2c_agent_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   connect_sequencer();
   connect_analysis_ports();
   if (cfg.cov_model_enabled) begin
      connect_cov_model();
   end
   if (cfg.trn_log_enabled) begin
      connect_logger();
   end

endfunction: connect_phase


task uvma_i2c_agent_c::run_phase(uvm_phase phase);

   super.run_phase(phase);
   if (cfg.enabled) begin
      start_mon_vseq();
      if (cfg.is_active) begin
         start_idle_vseq();
         case (cfg.drv_mode)
            UVMA_I2C_DRV_MODE_CTLR: start_drv_vseq_ctlr();
            UVMA_I2C_DRV_MODE_TAGT: start_drv_vseq_tagt();
            default: begin
               `uvm_fatal("I2C_AGENT", $sformatf("Invalid cfg.drv_mode: %s", cfg.drv_mode.name()))
            end
         endcase
      end
   end

endtask : run_phase


function void uvma_i2c_agent_c::get_and_set_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_AGENT", "Configuration handle is null")
   end
   else begin
      `uvm_info("I2C_AGENT", $sformatf("Found configuration handle:\n%s", cfg.sprint()), UVM_DEBUG)
      uvm_config_db#(uvma_i2c_cfg_c)::set(this, "*", "cfg", cfg);
   end

endfunction : get_and_set_cfg


function void uvma_i2c_agent_c::get_and_set_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_info("I2C_AGENT", "Context handle is null; creating.", UVM_DEBUG)
      cntxt = uvma_i2c_cntxt_c::type_id::create("cntxt");
   end
   uvm_config_db#(uvma_i2c_cntxt_c)::set(this, "*", "cntxt", cntxt);

endfunction : get_and_set_cntxt


function void uvma_i2c_agent_c::retrieve_vif();

   if (!uvm_config_db#(virtual uvma_i2c_if)::get(this, "", "vif", cntxt.vif)) begin
      `uvm_fatal("I2C_AGENT", $sformatf("Could not find vif handle of type %s in uvm_config_db", $typename(cntxt.vif)))
   end
   else begin
      `uvm_info("I2C_AGENT", $sformatf("Found vif handle of type %s in uvm_config_db", $typename(cntxt.vif)), UVM_DEBUG)
   end

endfunction : retrieve_vif


function void uvma_i2c_agent_c::create_components();

   vsequencer = uvma_i2c_vsqr_c     ::type_id::create("vsequencer", this);
   driver     = uvma_i2c_drv_c      ::type_id::create("driver"    , this);
   monitor    = uvma_i2c_mon_c      ::type_id::create("monitor"   , this);
   cov_model  = uvma_i2c_cov_model_c::type_id::create("cov_model" , this);
   logger     = uvma_i2c_logger_c   ::type_id::create("logger"    , this);

endfunction : create_components


function void uvma_i2c_agent_c::connect_sequencer();

   vsequencer.set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
   vsequencer.c2t_sequencer.set_arbitration(UVM_SEQ_ARB_FIFO);
   vsequencer.t2c_sequencer.set_arbitration(UVM_SEQ_ARB_FIFO);
   if (!cfg.bypass_mode) begin
      driver .c2t_driver.seq_item_port.connect(vsequencer.c2t_sequencer.seq_item_export);
      driver .t2c_driver.seq_item_port.connect(vsequencer.t2c_sequencer.seq_item_export);
      monitor.c2t_ap.connect(vsequencer.c2t_phy_mon_trn_export);
      monitor.t2c_ap.connect(vsequencer.t2c_phy_mon_trn_export);
   end

endfunction : connect_sequencer


function void uvma_i2c_agent_c::connect_analysis_ports();

   upstream_sqr_port = vsequencer.upstream_sqr_port;
   seq_item_ap       = vsequencer.seq_item_ap;
   c2t_mon_trn_ap      = vsequencer.c2t_mon_trn_ap;
   t2c_mon_trn_ap      = vsequencer.t2c_mon_trn_ap;
   c2t_phy_seq_item_ap = driver .c2t_ap;
   t2c_phy_seq_item_ap = driver .t2c_ap;
   c2t_phy_mon_trn_ap  = monitor.c2t_ap;
   t2c_phy_mon_trn_ap  = monitor.t2c_ap;

endfunction : connect_analysis_ports


function void uvma_i2c_agent_c::connect_cov_model();

   seq_item_ap.connect(cov_model.seq_item_export);
   c2t_mon_trn_ap     .connect(cov_model.c2t_mon_trn_export     );
   t2c_mon_trn_ap     .connect(cov_model.t2c_mon_trn_export     );
   c2t_phy_seq_item_ap.connect(cov_model.c2t_phy_seq_item_export);
   t2c_phy_seq_item_ap.connect(cov_model.t2c_phy_seq_item_export);
   c2t_phy_mon_trn_ap .connect(cov_model.c2t_phy_mon_trn_export );
   t2c_phy_mon_trn_ap .connect(cov_model.t2c_phy_mon_trn_export );

endfunction : connect_cov_model


function void uvma_i2c_agent_c::connect_logger();

   seq_item_ap.connect(logger.seq_item_export);
   c2t_mon_trn_ap     .connect(logger.c2t_mon_trn_export     );
   t2c_mon_trn_ap     .connect(logger.t2c_mon_trn_export     );
   c2t_phy_seq_item_ap.connect(logger.c2t_phy_seq_item_export);
   t2c_phy_seq_item_ap.connect(logger.t2c_phy_seq_item_export);
   c2t_phy_mon_trn_ap .connect(logger.c2t_phy_mon_trn_export );
   t2c_phy_mon_trn_ap .connect(logger.t2c_phy_mon_trn_export );

endfunction : connect_logger


task uvma_i2c_agent_c::start_mon_vseq();

   uvm_coreservice_t cs = uvm_coreservice_t::get();
   uvm_factory       f  = cs.get_factory();
   uvm_object        temp_obj;

   temp_obj = f.create_object_by_type(cfg.mon_vseq_type, get_full_name(), cfg.mon_vseq_type.get_type_name());
   if (!$cast(cntxt.mon_vseq, temp_obj)) begin
      `uvm_fatal("I2C_AGENT", $sformatf("Could not cast 'temp_obj' (%s) to 'cntxt.mon_vseq' (%s)", $typename(temp_obj), $typename(cntxt.mon_vseq)))
   end
   if (!cntxt.mon_vseq.randomize()) begin
      `uvm_fatal("I2C_AGENT", "Failed to randomize cntxt.mon_vseq")
   end
   fork
      cntxt.mon_vseq.start(vsequencer);
   join_none

endtask : start_mon_vseq


task uvma_i2c_agent_c::start_idle_vseq();

   uvm_coreservice_t cs = uvm_coreservice_t::get();
   uvm_factory       f  = cs.get_factory();
   uvm_object        temp_obj;

   temp_obj = f.create_object_by_type(cfg.idle_vseq_type, get_full_name(), cfg.idle_vseq_type.get_type_name());
   if (!$cast(cntxt.idle_vseq, temp_obj)) begin
      `uvm_fatal("I2C_AGENT", $sformatf("Could not cast 'temp_obj' (%s) to 'cntxt.idle_vseq' (%s)", $typename(temp_obj), $typename(cntxt.idle_vseq)))
   end
   if (!cntxt.idle_vseq.randomize()) begin
      `uvm_fatal("I2C_AGENT", "Failed to randomize cntxt.idle_vseq")
   end
   fork
      cntxt.idle_vseq.start(vsequencer);
   join_none

endtask : start_idle_vseq


task uvma_i2c_agent_c::start_drv_vseq_ctlr();

   uvm_coreservice_t cs = uvm_coreservice_t::get();
   uvm_factory       f  = cs.get_factory();
   uvm_object        temp_obj;

   temp_obj = f.create_object_by_type(cfg.c2t_drv_vseq_type, get_full_name(), cfg.c2t_drv_vseq_type.get_type_name());
   if (!$cast(cntxt.c2t_drv_vseq, temp_obj)) begin
      `uvm_fatal("I2C_AGENT", $sformatf("Could not cast 'temp_obj' (%s) to 'cntxt.c2t_drv_vseq' (%s)", $typename(temp_obj), $typename(cntxt.c2t_drv_vseq)))
   end
   if (!cntxt.c2t_drv_vseq.randomize()) begin
      `uvm_fatal("I2C_AGENT", "Failed to randomize cntxt.c2t_drv_vseq")
   end
   fork
      cntxt.c2t_drv_vseq.start(vsequencer);
   join_none

endtask : start_drv_vseq_ctlr


task uvma_i2c_agent_c::start_drv_vseq_tagt();

   uvm_coreservice_t cs = uvm_coreservice_t::get();
   uvm_factory       f  = cs.get_factory();
   uvm_object        temp_obj;

   temp_obj = f.create_object_by_type(cfg.t2c_drv_vseq_type, get_full_name(), cfg.t2c_drv_vseq_type.get_type_name());
   if (!$cast(cntxt.t2c_drv_vseq, temp_obj)) begin
      `uvm_fatal("I2C_AGENT", $sformatf("Could not cast 'temp_obj' (%s) to 'cntxt.t2c_drv_vseq' (%s)", $typename(temp_obj), $typename(cntxt.t2c_drv_vseq)))
   end
   if (!cntxt.t2c_drv_vseq.randomize()) begin
      `uvm_fatal("I2C_AGENT", "Failed to randomize cntxt.t2c_drv_vseq")
   end
   fork
      cntxt.t2c_drv_vseq.start(vsequencer);
   join_none

endtask : start_drv_vseq_tagt


`endif // __UVMA_I2C_AGENT_SV__