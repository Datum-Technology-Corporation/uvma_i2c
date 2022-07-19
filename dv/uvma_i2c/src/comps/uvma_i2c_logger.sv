// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_LOGGER_SV__
`define __UVMA_I2C_LOGGER_SV__


/**
 * Component which logs to disk information of the transactions generated and monitored by uvma_i2c_agent_c.
 */
class uvma_i2c_logger_c extends uvm_component;

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c  cntxt; ///< Agent context handle
   /// @}

   /// @defgroup Components
   /// @{
   uvml_logs_metadata_logger_c #(uvma_i2c_seq_item_c)  seq_item_logger; ///< Logs DATA Sequence Items from vsequencer.
   uvml_logs_metadata_logger_c #(uvma_i2c_mon_trn_c )  c2t_mon_trn_logger; ///< Logs C2T DATA Monitor Transactions from vsequencer.
   uvml_logs_metadata_logger_c #(uvma_i2c_mon_trn_c )  t2c_mon_trn_logger; ///< Logs T2C DATA Monitor Transactions from vsequencer.
   uvml_logs_metadata_logger_c #(uvma_i2c_phy_seq_item_c)  c2t_phy_seq_item_logger ; ///< Logs Phy Sequence Items from C2T Driver.
   uvml_logs_metadata_logger_c #(uvma_i2c_phy_seq_item_c)  t2c_phy_seq_item_logger ; ///< Logs Phy Sequence Items from T2C Driver.
   uvml_logs_metadata_logger_c #(uvma_i2c_phy_mon_trn_c )  c2t_phy_mon_trn_logger  ; ///< Logs C2T Phy Monitor Transactions from Monitor.
   uvml_logs_metadata_logger_c #(uvma_i2c_phy_mon_trn_c )  t2c_phy_mon_trn_logger  ; ///< Logs T2C Phy Monitor Transactions from Monitor.
   /// @}

   /// @defgroup TLM
   /// @{
   uvm_analysis_export #(uvma_i2c_seq_item_c)  seq_item_export   ; ///< Port for #seq_item_logger.
   uvm_analysis_export #(uvma_i2c_mon_trn_c )  c2t_mon_trn_export ; ///< Port for #seq_item_logger.
   uvm_analysis_export #(uvma_i2c_mon_trn_c )  t2c_mon_trn_export ; ///< Port for #seq_item_logger.
   uvm_analysis_export #(uvma_i2c_phy_seq_item_c)  c2t_phy_seq_item_export; ///< Port for #c2t_phy_seq_item_logger.
   uvm_analysis_export #(uvma_i2c_phy_seq_item_c)  t2c_phy_seq_item_export; ///< Port for #t2c_phy_seq_item_logger.
   uvm_analysis_export #(uvma_i2c_phy_mon_trn_c )  c2t_phy_mon_trn_export ; ///< Port for #c2t_phy_mon_trn_logger.
   uvm_analysis_export #(uvma_i2c_phy_mon_trn_c )  t2c_phy_mon_trn_export ; ///< Port for #t2c_phy_mon_trn_logger.
   /// @}


   `uvm_component_utils_begin(uvma_i2c_logger_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_logger", uvm_component parent=null);

   /**
    * 1. Ensures #cfg & #cntxt handles are not null.
    * 2. Builds loggers.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Connects TLM ports.
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
    * Creates logger components.
    */
   extern function void create_components();

   /**
    * Sets filenames for logger components.
    */
   extern function void configure_loggers();

   /**
    * Connects TLM ports to logger components.
    */
   extern function void connect_loggers();

endclass : uvma_i2c_logger_c


function uvma_i2c_logger_c::new(string name="uvma_i2c_logger", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_logger_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg  ();
   get_cntxt();
   create_components();

endfunction : build_phase


function void uvma_i2c_logger_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   configure_loggers();
   connect_loggers  ();

endfunction : connect_phase


function void uvma_i2c_logger_c::get_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_LOGGER", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvma_i2c_logger_c::get_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_LOGGER", "Context handle is null")
   end

endfunction : get_cntxt


function void uvma_i2c_logger_c::create_components();

   seq_item_logger = uvml_logs_metadata_logger_c #(uvma_i2c_seq_item_c)::type_id::create("seq_item_logger", this);
   c2t_mon_trn_logger = uvml_logs_metadata_logger_c #(uvma_i2c_mon_trn_c)::type_id::create("c2t_mon_trn_logger", this);
   t2c_mon_trn_logger = uvml_logs_metadata_logger_c #(uvma_i2c_mon_trn_c)::type_id::create("t2c_mon_trn_logger", this);
   c2t_phy_seq_item_logger = uvml_logs_metadata_logger_c #(uvma_i2c_phy_seq_item_c)::type_id::create("c2t_phy_seq_item_logger", this);
   t2c_phy_seq_item_logger = uvml_logs_metadata_logger_c #(uvma_i2c_phy_seq_item_c)::type_id::create("t2c_phy_seq_item_logger", this);
   c2t_phy_mon_trn_logger  = uvml_logs_metadata_logger_c #(uvma_i2c_phy_mon_trn_c )::type_id::create("c2t_phy_mon_trn_logger" , this);
   t2c_phy_mon_trn_logger  = uvml_logs_metadata_logger_c #(uvma_i2c_phy_mon_trn_c )::type_id::create("t2c_phy_mon_trn_logger" , this);

endfunction : create_components


function void uvma_i2c_logger_c::configure_loggers();

   seq_item_logger.set_file_name({get_parent().get_full_name(), ".seq_item"});
   c2t_mon_trn_logger     .set_file_name({get_parent().get_full_name(), ".c2t_mon_trn"     });
   t2c_mon_trn_logger     .set_file_name({get_parent().get_full_name(), ".t2c_mon_trn"     });
   c2t_phy_seq_item_logger.set_file_name({get_parent().get_full_name(), ".c2t_phy_seq_item"});
   t2c_phy_seq_item_logger.set_file_name({get_parent().get_full_name(), ".t2c_phy_seq_item"});
   c2t_phy_mon_trn_logger .set_file_name({get_parent().get_full_name(), ".c2t_phy_mon_trn" });
   t2c_phy_mon_trn_logger .set_file_name({get_parent().get_full_name(), ".t2c_phy_mon_trn" });

endfunction : configure_loggers


function void uvma_i2c_logger_c::connect_loggers();

   seq_item_export = seq_item_logger.analysis_export;
   c2t_mon_trn_export      = c2t_mon_trn_logger     .analysis_export;
   t2c_mon_trn_export      = t2c_mon_trn_logger     .analysis_export;
   c2t_phy_seq_item_export = c2t_phy_seq_item_logger.analysis_export;
   t2c_phy_seq_item_export = t2c_phy_seq_item_logger.analysis_export;
   c2t_phy_mon_trn_export  = c2t_phy_mon_trn_logger .analysis_export;
   t2c_phy_mon_trn_export  = t2c_phy_mon_trn_logger .analysis_export;

endfunction : connect_loggers


`endif // __UVMA_I2C_LOGGER_SV__