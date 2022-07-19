// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_ENV_SV__
`define __UVME_I2C_ST_ENV_SV__


/**
 * Top-level component that encapsulates, builds and connects all other I2C UVM Agent Self-Test Environment
 * (uvme_${name}_st_env_c) components.
 */
class uvme_i2c_st_env_c extends uvml_env_c;

   /// @defgroup Objects
   /// @{
   uvme_i2c_st_cfg_c    cfg  ; ///< Configuration handle.  Must be provided by component instantiating this environment.
   uvme_i2c_st_cntxt_c  cntxt; ///< Context handle.  Can be provided by component instantiating this environment.
   /// @}

   /// @defgroup Agents
   /// @{
   uvma_i2c_agent_c  ctlr_agent; ///< CTLR Agent instance.
   uvma_i2c_agent_c  tagt_agent; ///< TAGT Agent instance.
   uvma_i2c_agent_c  passive_agent; ///< Passive Agent instance.
   /// @}

   /// @defgroup Components
   /// @{
   uvme_i2c_st_vsqr_c  vsequencer; ///< Virtual Sequencer on which Virtual Sequences are run.
   uvme_i2c_st_prd_c   predictor ; ///< Feeds #sb's expected ports with monitor transactions
   uvme_i2c_st_sb_c    sb        ; ///< Ensures that monitored transactions from data streams match.
   /// @}


   `uvm_component_utils_begin(uvme_i2c_st_env_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvme_i2c_st_env", uvm_component parent=null);

   /**
    * 1. Ensures #cfg & #cntxt handles are not null
    * 2. Assigns #cfg and #cntxt sub-handles via assign_cfg() & assign_cntxt()
    * 4. Builds all components via create_<x>()
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * 1. Connects agents to predictor via connect_predictor()
    * 2. Connects predictor & agents to scoreboard via connect_scoreboard()
    * 3. Assembles virtual sequencer handles via assemble_vsequencer()
    * 4. Connects agents to coverage model via connect_coverage_model()
    */
   extern virtual function void connect_phase(uvm_phase phase);

   /**
    * Uses uvm_config_db to retrieve cfg.
    */
   extern function void get_cfg();

   /**
    * Uses uvm_config_db to retrieve cntxt.
    */
   extern function void get_cntxt();

   /**
    * Assigns configuration handles to components using uvm_config_db.
    */
   extern function void assign_cfg();

   /**
    * Assigns context handles to components using uvm_config_db.
    */
   extern function void assign_cntxt();

   /**
    * Creates agent components.
    */
   extern function void create_agents();

   /**
    * Creates additional (non-agent) environment components (and objects).
    */
   extern function void create_env_components();

   /**
    * Creates Virtual Sequencer.
    */
   extern function void create_vsequencer();

   /**
    * Connects agents to predictor.
    */
   extern function void connect_predictor();

   /**
    * Connects scoreboards to agents/predictor.
    */
   extern function void connect_scoreboard();

   /**
    * Assembles virtual sequencer from agent sequencers.
    */
   extern function void assemble_vsequencer();

endclass : uvme_i2c_st_env_c


function uvme_i2c_st_env_c::new(string name="uvme_i2c_st_env", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvme_i2c_st_env_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg();
   if (cfg.enabled) begin
      get_cntxt            ();
      assign_cfg           ();
      assign_cntxt         ();
      create_agents        ();
      create_env_components();
      create_vsequencer    ();
   end

endfunction : build_phase


function void uvme_i2c_st_env_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   if (cfg.enabled) begin
      assemble_vsequencer();
      if (cfg.scoreboarding_enabled) begin
         connect_predictor ();
         connect_scoreboard();
      end
   end

endfunction: connect_phase


function void uvme_i2c_st_env_c::get_cfg();

   void'(uvm_config_db#(uvme_i2c_st_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_ST_ENV", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvme_i2c_st_env_c::get_cntxt();

   void'(uvm_config_db#(uvme_i2c_st_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_ST_ENV", "Context handle is null")
   end

endfunction : get_cntxt


function void uvme_i2c_st_env_c::assign_cfg();

   uvm_config_db#(uvme_i2c_st_cfg_c)::set(this, "*", "cfg", cfg);
   uvm_config_db#(uvma_i2c_cfg_c   )::set(this, "ctlr_agent", "cfg", cfg.ctlr_cfg);
   uvm_config_db#(uvma_i2c_cfg_c   )::set(this, "tagt_agent", "cfg", cfg.tagt_cfg);
   uvm_config_db#(uvma_i2c_cfg_c   )::set(this, "passive_agent", "cfg", cfg.passive_cfg);

endfunction: assign_cfg


function void uvme_i2c_st_env_c::assign_cntxt();

   uvm_config_db#(uvme_i2c_st_cntxt_c)::set(this, "*", "cntxt", cntxt);
   uvm_config_db#(uvma_i2c_cntxt_c   )::set(this, "ctlr_agent", "cntxt", cntxt.ctlr_cntxt);
   uvm_config_db#(uvma_i2c_cntxt_c   )::set(this, "tagt_agent", "cntxt", cntxt.tagt_cntxt);
   uvm_config_db#(uvma_i2c_cntxt_c   )::set(this, "passive_agent", "cntxt", cntxt.passive_cntxt);

endfunction: assign_cntxt


function void uvme_i2c_st_env_c::create_agents();

   set_type_override_by_type(uvma_i2c_cov_model_c::get_type(), uvme_i2c_st_cov_model_c::get_type());
   ctlr_agent = uvma_i2c_agent_c::type_id::create("ctlr_agent", this);
   tagt_agent = uvma_i2c_agent_c::type_id::create("tagt_agent", this);
   passive_agent = uvma_i2c_agent_c::type_id::create("passive_agent", this);

endfunction: create_agents


function void uvme_i2c_st_env_c::create_env_components();

   if (cfg.scoreboarding_enabled) begin
      predictor = uvme_i2c_st_prd_c::type_id::create("predictor", this);
      sb        = uvme_i2c_st_sb_c ::type_id::create("sb"       , this);
   end

endfunction: create_env_components


function void uvme_i2c_st_env_c::create_vsequencer();

   vsequencer = uvme_i2c_st_vsqr_c::type_id::create("vsequencer", this);

endfunction: create_vsequencer


function void uvme_i2c_st_env_c::connect_predictor();

   // Connect agent -> predictor
   ctlr_agent.c2t_mon_trn_ap.connect(predictor.c2t_in_export);
   tagt_agent.t2c_mon_trn_ap.connect(predictor.t2c_in_export);
   ctlr_agent.seq_item_ap.connect(predictor.ctlr_in_export);
   tagt_agent.seq_item_ap.connect(predictor.tagt_in_export);

endfunction: connect_predictor


function void uvme_i2c_st_env_c::connect_scoreboard();

   // Connect agent -> scoreboard
   tagt_agent.c2t_mon_trn_ap.connect(sb.c2t_act_export);
   ctlr_agent.t2c_mon_trn_ap.connect(sb.t2c_act_export);
   passive_agent.c2t_mon_trn_ap.connect(sb.ctlr_act_export);
   passive_agent.t2c_mon_trn_ap.connect(sb.tagt_act_export);
   // Connect predictor -> scoreboard
   predictor.c2t_out_ap.connect(sb.c2t_exp_export);
   predictor.t2c_out_ap.connect(sb.t2c_exp_export);
   predictor.ctlr_out_ap.connect(sb.ctlr_exp_export);
   predictor.tagt_out_ap.connect(sb.tagt_exp_export);

endfunction: connect_scoreboard


function void uvme_i2c_st_env_c::assemble_vsequencer();

   vsequencer.ctlr_vsequencer = ctlr_agent.vsequencer;
   vsequencer.tagt_vsequencer = tagt_agent.vsequencer;
   vsequencer.passive_vsequencer = passive_agent.vsequencer;

endfunction: assemble_vsequencer


`endif // __UVME_I2C_ST_ENV_SV__