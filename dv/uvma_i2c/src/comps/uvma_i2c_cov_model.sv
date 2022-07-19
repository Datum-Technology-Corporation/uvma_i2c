// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_COV_MODEL_SV__
`define __UVMA_I2C_COV_MODEL_SV__


/**
 * Abstract component providing a base for I2C Agent functional coverage models.
 */
class uvma_i2c_cov_model_c extends uvm_component;

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c       cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c     cntxt; ///< Agent context handle
   /// @}

   /// @defgroup Covergroup Variables
   /// @{
   uvma_i2c_seq_item_c     seq_item    ; ///< Sequence Item currently being sampled.
   uvma_i2c_mon_trn_c      c2t_mon_trn  ; ///< C2T Monitor Transaction currently being sampled.
   uvma_i2c_mon_trn_c      t2c_mon_trn  ; ///< T2C Monitor Transaction currently being sampled.
   uvma_i2c_phy_seq_item_c  c2t_phy_seq_item ; ///< C2T Phy Sequence Item currently being sampled.
   uvma_i2c_phy_seq_item_c  t2c_phy_seq_item ; ///< T2C Phy Sequence Item currently being sampled.
   uvma_i2c_phy_mon_trn_c   c2t_phy_mon_trn  ; ///< C2T Phy Monitor Transaction currently being sampled.
   uvma_i2c_phy_mon_trn_c   t2c_phy_mon_trn  ; ///< T2C Phy Monitor Transaction currently being sampled.
   /// @}

   /// @defgroup TLM FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_i2c_seq_item_c   )  seq_item_fifo    ; ///< FIFO of Sequence Items to be sampled.
   uvm_tlm_analysis_fifo #(uvma_i2c_mon_trn_c    )  c2t_mon_trn_fifo  ; ///< FIFO of C2T Monitor Transactions to be sampled.
   uvm_tlm_analysis_fifo #(uvma_i2c_mon_trn_c    )  t2c_mon_trn_fifo  ; ///< FIFO of T2C Monitor Transactions to be sampled.
   uvm_tlm_analysis_fifo #(uvma_i2c_phy_seq_item_c)  c2t_phy_seq_item_fifo ; ///< FIFO of C2T Phy Sequence Items to be sampled.
   uvm_tlm_analysis_fifo #(uvma_i2c_phy_seq_item_c)  t2c_phy_seq_item_fifo ; ///< FIFO of T2C Phy Sequence Item to be sampled.
   uvm_tlm_analysis_fifo #(uvma_i2c_phy_mon_trn_c )  c2t_phy_mon_trn_fifo  ; ///< FIFO of C2T Phy Monitor Transactions to be sampled.
   uvm_tlm_analysis_fifo #(uvma_i2c_phy_mon_trn_c )  t2c_phy_mon_trn_fifo  ; ///< FIFO of T2C Phy Monitor Transactions to be sampled.
   /// @}

   /// @defgroup TLM Exports
   /// @{
   uvm_analysis_export #(uvma_i2c_seq_item_c)  seq_item_export   ; ///< Port for Sequence Items to be sampled.
   uvm_analysis_export #(uvma_i2c_mon_trn_c )  c2t_mon_trn_export ; ///< Port for C2T Monitor Transactions to be sampled.
   uvm_analysis_export #(uvma_i2c_mon_trn_c )  t2c_mon_trn_export ; ///< Port for T2C Monitor Transactions to be sampled.
   uvm_analysis_export #(uvma_i2c_phy_seq_item_c)  c2t_phy_seq_item_export; ///< Port for C2T Phy Sequence Items to be sampled.
   uvm_analysis_export #(uvma_i2c_phy_seq_item_c)  t2c_phy_seq_item_export; ///< Port for T2C Phy Sequence Items to be sampled.
   uvm_analysis_export #(uvma_i2c_phy_mon_trn_c )  c2t_phy_mon_trn_export ; ///< Port for C2T Phy Monitor Transactions to be sampled.
   uvm_analysis_export #(uvma_i2c_phy_mon_trn_c )  t2c_phy_mon_trn_export ; ///< Port for T2C Phy Monitor Transactions to be sampled.
   /// @}


   `uvm_component_utils_begin(uvma_i2c_cov_model_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_cov_model", uvm_component parent=null);

   /**
    * 1. Ensures #cfg & #cntxt handles are not null.
    * 2. Builds FIFOs.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Connects TLM Objects.
    */
   extern virtual function void connect_phase(uvm_phase phase);

   /**
    * Forks all sampling loops.
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
    * Creates Exports and FIFOs.
    */
   extern function void create_tlm_objects();

   /**
    * Connects Exports to FIFOs.
    */
   extern function void connect_fifos();

   /**
    * User hook for sampling #cfg.
    * Pure virtual.
    */
   extern virtual function void sample_cfg();

   /**
    * User hook for sampling #cntxt.
    * Pure virtual.
    */
   extern virtual function void sample_cntxt();

   /**
    * User hook for sampling #seq_item.
    * Pure virtual.
    */
   extern virtual function void sample_seq_item();

   /**
    * User hook for sampling #c2t_mon_trn.
    * Pure virtual.
    */
   extern virtual function void sample_c2t_mon_trn();

   /**
    * User hook for sampling #t2c_mon_trn.
    * Pure virtual.
    */
   extern virtual function void sample_t2c_mon_trn();

   /**
    * User hook for sampling #c2t_phy_seq_item.
    * Pure virtual.
    */
   extern virtual function void sample_c2t_phy_seq_item();

   /**
    * User hook for sampling #t2c_phy_seq_item.
    * Pure virtual.
    */
   extern virtual function void sample_t2c_phy_seq_item();

   /**
    * User hook for sampling #c2t_phy_mon_trn.
    * Pure virtual.
    */
   extern virtual function void sample_c2t_phy_mon_trn();

   /**
    * User hook for sampling #t2c_phy_mon_trn.
    * Pure virtual.
    */
   extern virtual function void sample_t2c_phy_mon_trn();

endclass : uvma_i2c_cov_model_c


function uvma_i2c_cov_model_c::new(string name="uvma_i2c_cov_model", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_cov_model_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg           ();
   get_cntxt         ();
   create_tlm_objects();

endfunction : build_phase


function void uvma_i2c_cov_model_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   connect_fifos();

endfunction : connect_phase


task uvma_i2c_cov_model_c::run_phase(uvm_phase phase);

   super.run_phase(phase);
   if (cfg.enabled && cfg.cov_model_enabled) begin
      fork
         forever begin
            cntxt.sample_cfg_e.wait_trigger();
            sample_cfg();
         end
         forever begin
            cntxt.sample_cntxt_e.wait_trigger();
            sample_cntxt();
         end
         forever begin
            seq_item_fifo.get(seq_item);
            sample_seq_item();
         end
         forever begin
            c2t_mon_trn_fifo.get(c2t_mon_trn);
            sample_c2t_mon_trn();
         end
         forever begin
            t2c_mon_trn_fifo.get(t2c_mon_trn);
            sample_t2c_mon_trn();
         end
         forever begin
            c2t_phy_seq_item_fifo.get(c2t_phy_seq_item);
            sample_c2t_phy_seq_item();
         end
         forever begin
            t2c_phy_seq_item_fifo.get(t2c_phy_seq_item);
            sample_t2c_phy_seq_item();
         end
         forever begin
            c2t_phy_mon_trn_fifo.get(c2t_phy_mon_trn);
            sample_c2t_phy_mon_trn();
         end
         forever begin
            t2c_phy_mon_trn_fifo.get(t2c_phy_mon_trn);
            sample_t2c_phy_mon_trn();
         end
      join_none
   end

endtask : run_phase


function void uvma_i2c_cov_model_c::get_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_COV_MODEL", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvma_i2c_cov_model_c::get_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_COV_MODEL", "Context handle is null")
   end

endfunction : get_cntxt


function void uvma_i2c_cov_model_c::create_tlm_objects();

   seq_item_fifo = new("seq_item_fifo", this);
   c2t_mon_trn_fifo      = new("c2t_mon_trn_fifo"     , this);
   t2c_mon_trn_fifo      = new("t2c_mon_trn_fifo"     , this);
   c2t_phy_seq_item_fifo = new("c2t_phy_seq_item_fifo", this);
   t2c_phy_seq_item_fifo = new("t2c_phy_seq_item_fifo", this);
   c2t_phy_mon_trn_fifo  = new("c2t_phy_mon_trn_fifo" , this);
   t2c_phy_mon_trn_fifo  = new("t2c_phy_mon_trn_fifo" , this);

endfunction : create_tlm_objects


function void uvma_i2c_cov_model_c::connect_fifos();

   seq_item_export = seq_item_fifo.analysis_export;
   c2t_mon_trn_export      = c2t_mon_trn_fifo     .analysis_export;
   t2c_mon_trn_export      = t2c_mon_trn_fifo     .analysis_export;
   c2t_phy_seq_item_export = c2t_phy_seq_item_fifo.analysis_export;
   t2c_phy_seq_item_export = t2c_phy_seq_item_fifo.analysis_export;
   c2t_phy_mon_trn_export  = c2t_phy_mon_trn_fifo .analysis_export;
   t2c_phy_mon_trn_export  = t2c_phy_mon_trn_fifo .analysis_export;

endfunction : connect_fifos


function void uvma_i2c_cov_model_c::sample_cfg();
endfunction : sample_cfg


function void uvma_i2c_cov_model_c::sample_cntxt();
endfunction : sample_cntxt


function void uvma_i2c_cov_model_c::sample_seq_item();
endfunction : sample_seq_item


function void uvma_i2c_cov_model_c::sample_c2t_mon_trn();
endfunction : sample_c2t_mon_trn


function void uvma_i2c_cov_model_c::sample_t2c_mon_trn();
endfunction : sample_t2c_mon_trn


function void uvma_i2c_cov_model_c::sample_c2t_phy_seq_item();
endfunction : sample_c2t_phy_seq_item


function void uvma_i2c_cov_model_c::sample_t2c_phy_seq_item();
endfunction : sample_t2c_phy_seq_item


function void uvma_i2c_cov_model_c::sample_c2t_phy_mon_trn();
endfunction : sample_c2t_phy_mon_trn


function void uvma_i2c_cov_model_c::sample_t2c_phy_mon_trn();
endfunction : sample_t2c_phy_mon_trn


`endif // __UVMA_I2C_COV_MODEL_SV__