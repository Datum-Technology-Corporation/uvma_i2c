// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_SB_SV__
`define __UVME_I2C_ST_SB_SV__


/**
 * Component encapsulating scoreboarding components for I2C UVM Agent Self-Testing Environment.
 */
class uvme_i2c_st_sb_c extends uvm_component;

   /// @defgroup Objects
   /// @{
   uvme_i2c_st_cfg_c    cfg  ; ///< Environment configuration handle
   uvme_i2c_st_cntxt_c  cntxt; ///< Environment context handle
   /// @}

   /// @defgroup Components
   /// @{
   uvme_i2c_st_sb_simplex_c  sb_c2t; ///< C2T Scoreboard.
   uvme_i2c_st_sb_simplex_c  sb_t2c; ///< T2C Scoreboard.
   uvme_i2c_st_sb_simplex_c  sb_ctlr; ///< CTLR Scoreboard.
   uvme_i2c_st_sb_simplex_c  sb_tagt; ///< TAGT Scoreboard.
   /// @}

   /// @defgroup TLM
   /// @{
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  c2t_act_export; ///< Port for #sb_c2t Actual Transactions.
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  c2t_exp_export; ///< Port for #sb_c2t Expected Transactions.
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  t2c_act_export; ///< Port for #sb_t2c Actual Transactions.
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  t2c_exp_export; ///< Port for #sb_t2c Expected Transactions.
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  ctlr_act_export; ///< Port for #sb_ctlr Actual Transactions.
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  ctlr_exp_export; ///< Port for #sb_ctlr Expected Transactions.
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  tagt_act_export; ///< Port for #sb_tagt Actual Transactions.
   uvm_analysis_export #(uvma_i2c_mon_trn_c)  tagt_exp_export; ///< Port for #sb_tagt Expected Transactions.
   /// @}


   `uvm_component_utils_begin(uvme_i2c_st_sb_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvme_i2c_st_sb", uvm_component parent=null);

   /**
    * Ensures #cfg & #cntxt handles are not null.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Connects exports to scoreboards'.
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
    * Creates scoreboard components.
    */
   extern function void create_components();

   /**
    * Connects scoreboard TLM ports.
    */
   extern function void connect_ports();

endclass : uvme_i2c_st_sb_c


function uvme_i2c_st_sb_c::new(string name="uvme_i2c_st_sb", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvme_i2c_st_sb_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg          ();
   get_cntxt        ();
   assign_cfg       ();
   assign_cntxt     ();
   create_components();

endfunction : build_phase


function void uvme_i2c_st_sb_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   connect_ports();

endfunction : connect_phase


function void uvme_i2c_st_sb_c::get_cfg();

   void'(uvm_config_db#(uvme_i2c_st_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_ST_SB", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvme_i2c_st_sb_c::get_cntxt();

   void'(uvm_config_db#(uvme_i2c_st_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_ST_SB", "Context handle is null")
   end

endfunction : get_cntxt


function void uvme_i2c_st_sb_c::assign_cfg();

   uvm_config_db#(uvml_sb_simplex_cfg_c)::set(this, "sb_c2t", "cfg", cfg.sb_c2t_cfg);
   uvm_config_db#(uvml_sb_simplex_cfg_c)::set(this, "sb_t2c", "cfg", cfg.sb_t2c_cfg);
   uvm_config_db#(uvml_sb_simplex_cfg_c)::set(this, "sb_ctlr", "cfg", cfg.sb_ctlr_cfg);
   uvm_config_db#(uvml_sb_simplex_cfg_c)::set(this, "sb_tagt", "cfg", cfg.sb_tagt_cfg);

endfunction: assign_cfg


function void uvme_i2c_st_sb_c::assign_cntxt();

   uvm_config_db#(uvml_sb_simplex_cntxt_c)::set(this, "sb_c2t", "cntxt", cntxt.sb_c2t_cntxt);
   uvm_config_db#(uvml_sb_simplex_cntxt_c)::set(this, "sb_t2c", "cntxt", cntxt.sb_t2c_cntxt);
   uvm_config_db#(uvml_sb_simplex_cntxt_c)::set(this, "sb_ctlr", "cntxt", cntxt.sb_ctlr_cntxt);
   uvm_config_db#(uvml_sb_simplex_cntxt_c)::set(this, "sb_tagt", "cntxt", cntxt.sb_tagt_cntxt);

endfunction: assign_cntxt


function void uvme_i2c_st_sb_c::create_components();

   sb_c2t = uvme_i2c_st_sb_simplex_c::type_id::create("sb_c2t", this);
   sb_t2c = uvme_i2c_st_sb_simplex_c::type_id::create("sb_t2c", this);
   sb_ctlr = uvme_i2c_st_sb_simplex_c::type_id::create("sb_ctlr", this);
   sb_tagt = uvme_i2c_st_sb_simplex_c::type_id::create("sb_tagt", this);

endfunction: create_components


function void uvme_i2c_st_sb_c::connect_ports();

   c2t_act_export = sb_c2t.act_export;
   c2t_exp_export = sb_c2t.exp_export;
   t2c_act_export = sb_t2c.act_export;
   t2c_exp_export = sb_t2c.exp_export;
   ctlr_act_export = sb_ctlr.act_export;
   ctlr_exp_export = sb_ctlr.exp_export;
   tagt_act_export = sb_tagt.act_export;
   tagt_exp_export = sb_tagt.exp_export;

endfunction: connect_ports


`endif // __UVME_I2C_ST_SB_SV__