// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_PRD_SV__
`define __UVME_I2C_ST_PRD_SV__


/**
 * Component implementing transaction-based prediction for ${name_normal_case} UVM Agent Self-Testing Environment.
 * Predicts how the Passive Agent will observe stimulus from CTLR & TAGT Agents.
 */
class uvme_i2c_st_prd_c extends uvm_component;

   /// @defgroup Objects
   /// @{
   uvme_i2c_st_cfg_c    cfg  ; ///< Environment configuration handle
   uvme_i2c_st_cntxt_c  cntxt; ///< Environment context handle
   /// @}

   /// @defgroup TLM
   /// @{
   uvm_analysis_export   #(uvma_i2c_mon_trn_c )  c2t_in_export; ///< Port for Monitor Transactions from CTLR Agent C2T.
   uvm_analysis_export   #(uvma_i2c_mon_trn_c )  t2c_in_export; ///< Port for Monitor Transactions from TAGT Agent T2C.
   uvm_analysis_export   #(uvma_i2c_seq_item_c)  ctlr_in_export; ///< Port for Sequence Items from CTLR Agent C2T.
   uvm_analysis_export   #(uvma_i2c_seq_item_c)  tagt_in_export; ///<  Port for Sequence Items from TAGT Agent T2C.
   uvm_tlm_analysis_fifo #(uvma_i2c_mon_trn_c )  c2t_in_fifo; ///< FIFO of Monitor Transactions from CTLR Agent C2T.
   uvm_tlm_analysis_fifo #(uvma_i2c_mon_trn_c )  t2c_in_fifo; ///< FIFO of Monitor Transactions from TAGT Agent T2C.
   uvm_tlm_analysis_fifo #(uvma_i2c_seq_item_c)  ctlr_in_fifo; ///< FIFO of Sequence Items from CTLR Agent C2T.
   uvm_tlm_analysis_fifo #(uvma_i2c_seq_item_c)  tagt_in_fifo; ///< FIFO of Sequence Items from TAGT Agent T2C.
   uvm_analysis_port     #(uvma_i2c_mon_trn_c )  c2t_out_ap; ///< Port outputting Monitor Transactions for Scoreboard C2T Expected.
   uvm_analysis_port     #(uvma_i2c_mon_trn_c )  t2c_out_ap; ///< Port outputting Monitor Transactions for Scoreboard T2C Expected.
   uvm_analysis_port     #(uvma_i2c_mon_trn_c )  ctlr_out_ap; ///< Port outputting Monitor Transactions for Scoreboard CTLR Expected.
   uvm_analysis_port     #(uvma_i2c_mon_trn_c )  tagt_out_ap; ///< Port outputting Monitor Transactions for Scoreboard TAGT Expected.
   /// @}


   `uvm_component_utils_begin(uvme_i2c_st_prd_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvme_i2c_st_prd", uvm_component parent=null);

   /**
    * 1. Ensures #cfg & #cntxt handles are not null
    * 2. Creates TLM objects
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Connects Exports to FIFOs.
    */
   extern virtual function void connect_phase(uvm_phase phase);

   /**
    * Forks all processing tasks.
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
    * Creates TLM FIFOs and Analysis Ports.
    */
   extern function void create_tlm_objects();

   /**
    * Connects Exports to FIFOs.
    */
   extern function void connect_ports();

   /**
    * Predicts C2T data path.
    */
   extern task process_c2t();

   /**
    * Predicts T2C data path.
    */
   extern task process_t2c();

   /**
    * Predicts CTLR data path.
    */
   extern task process_ctlr();

   /**
    * Predicts CTLR data path.
    */
   extern task process_tagt();

endclass : uvme_i2c_st_prd_c


function uvme_i2c_st_prd_c::new(string name="uvme_i2c_st_prd", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvme_i2c_st_prd_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg           ();
   get_cntxt         ();
   create_tlm_objects();

endfunction : build_phase


function void uvme_i2c_st_prd_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   connect_ports();

endfunction : connect_phase


task uvme_i2c_st_prd_c::run_phase(uvm_phase phase);

   super.run_phase(phase);
   fork
      process_c2t();
      process_t2c();
      process_ctlr();
      process_tagt();
   join_none

endtask : run_phase


function void uvme_i2c_st_prd_c::get_cfg();

   void'(uvm_config_db#(uvme_i2c_st_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_ST_PRD", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvme_i2c_st_prd_c::get_cntxt();

   void'(uvm_config_db#(uvme_i2c_st_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_ST_PRD", "Context handle is null")
   end

endfunction : get_cntxt


function void uvme_i2c_st_prd_c::create_tlm_objects();

   c2t_in_fifo = new("c2t_in_fifo", this);
   t2c_in_fifo = new("t2c_in_fifo", this);
   ctlr_in_fifo = new("ctlr_in_fifo", this);
   tagt_in_fifo = new("tagt_in_fifo", this);
   c2t_out_ap = new("c2t_out_ap", this);
   t2c_out_ap = new("t2c_out_ap", this);
   ctlr_out_ap = new("ctlr_out_ap", this);
   tagt_out_ap = new("tagt_out_ap", this);

endfunction : create_tlm_objects


function void uvme_i2c_st_prd_c::connect_ports();

   c2t_in_export = c2t_in_fifo.analysis_export;
   t2c_in_export = t2c_in_fifo.analysis_export;
   ctlr_in_export = ctlr_in_fifo.analysis_export;
   tagt_in_export = tagt_in_fifo.analysis_export;

endfunction : connect_ports


task uvme_i2c_st_prd_c::process_c2t();

   uvma_i2c_mon_trn_c  c2t_in_trn, c2t_out_trn;
   forever begin
      c2t_in_fifo.get(c2t_in_trn);
      c2t_out_trn = uvma_i2c_mon_trn_c::type_id::create("c2t_out_trn");
      c2t_out_trn.copy(c2t_in_trn);
      c2t_out_trn.set_initiator(this);
      if (c2t_out_trn.header == UVMA_I2C_HEADER_DATA) begin
         if (cntxt.ctlr_cntxt.reset_state != UVML_RESET_STATE_POST_RESET) begin
            c2t_out_trn.set_may_drop(1);
         end
         if (c2t_in_trn.has_error()) begin
            c2t_out_trn.set_may_drop(1);
         end
         c2t_out_ap.write(c2t_out_trn);
      end
   end

endtask : process_c2t


task uvme_i2c_st_prd_c::process_t2c();

   uvma_i2c_mon_trn_c  t2c_in_trn, t2c_out_trn;
   forever begin
      t2c_in_fifo.get(t2c_in_trn);
      t2c_out_trn = uvma_i2c_mon_trn_c::type_id::create("t2c_out_trn");
      t2c_out_trn.copy(t2c_in_trn);
      t2c_out_trn.set_initiator(this);
      if (t2c_out_trn.header == UVMA_I2C_HEADER_DATA) begin
         if (cntxt.tagt_cntxt.reset_state != UVML_RESET_STATE_POST_RESET) begin
            t2c_out_trn.set_may_drop(1);
         end
         if (t2c_in_trn.has_error()) begin
            t2c_out_trn.set_may_drop(1);
         end
         t2c_out_ap.write(t2c_out_trn);
      end
   end

endtask : process_t2c


task uvme_i2c_st_prd_c::process_ctlr();

   uvma_i2c_seq_item_c  ctlr_in_trn ;
   uvma_i2c_mon_trn_c   ctlr_out_trn;
   forever begin
      ctlr_in_fifo.get(ctlr_in_trn);
      ctlr_out_trn = uvma_i2c_mon_trn_c::type_id::create("ctlr_out_trn");
      ctlr_out_trn.header = ctlr_in_trn.header;
      ctlr_out_trn.data   = ctlr_in_trn.data  ;
      ctlr_out_trn.tail   = ctlr_in_trn.tail  ;
      ctlr_out_trn.set_initiator(this);
      if (ctlr_out_trn.header == UVMA_I2C_HEADER_DATA) begin
         if (cntxt.passive_cntxt.reset_state != UVML_RESET_STATE_POST_RESET) begin
            ctlr_out_trn.set_may_drop(1);
         end
         if (ctlr_in_trn.has_error()) begin
            ctlr_out_trn.set_may_drop(1);
         end
         ctlr_out_ap.write(ctlr_out_trn);
      end
   end

endtask : process_ctlr


task uvme_i2c_st_prd_c::process_tagt();

   uvma_i2c_seq_item_c  tagt_in_trn ;
   uvma_i2c_mon_trn_c   tagt_out_trn;
   forever begin
      tagt_in_fifo.get(tagt_in_trn);
      tagt_out_trn = uvma_i2c_mon_trn_c::type_id::create("tagt_out_trn");
      tagt_out_trn.header = tagt_in_trn.header;
      tagt_out_trn.data   = tagt_in_trn.data  ;
      tagt_out_trn.tail   = tagt_in_trn.tail  ;
      tagt_out_trn.set_initiator(this);
      if (tagt_out_trn.header == UVMA_I2C_HEADER_DATA) begin
         if (cntxt.passive_cntxt.reset_state != UVML_RESET_STATE_POST_RESET) begin
            tagt_out_trn.set_may_drop(1);
         end
         if (tagt_in_trn.has_error()) begin
            tagt_out_trn.set_may_drop(1);
         end
         tagt_out_ap.write(tagt_out_trn);
      end
   end

endtask : process_tagt


`endif // __UVME_I2C_ST_PRD_SV__