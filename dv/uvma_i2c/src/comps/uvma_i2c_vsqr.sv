// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_VSQR_SV__
`define __UVMA_I2C_VSQR_SV__


/**
 * Virtual Sequencer running I2C Virtual Sequences extending uvma_i2c_base_vseq_c.
 */
class uvma_i2c_vsqr_c extends uvml_vsqr_c #(
   .REQ(uvma_i2c_seq_item_c),
   .RSP(uvma_i2c_seq_item_c)
);

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c  cntxt; ///< Agent context handle
   /// @}

   /// @defgroup Components
   /// @{
   uvma_i2c_phy_sqr_c  c2t_sequencer; ///< Sequencer handle for C2T Driver.
   uvma_i2c_phy_sqr_c  t2c_sequencer; ///< Sequencer handle for T2C Driver.
   /// @}

   /// @defgroup TLM
   /// @{
   uvm_seq_item_pull_port #(uvm_sequence_item)  upstream_sqr_port; ///< Upstream Sequencer Port for transport sequences.
   uvm_analysis_port      #(uvma_i2c_seq_item_c)  seq_item_ap ; ///< Port outputting DATA Sequence Items.
   uvm_analysis_port      #(uvma_i2c_mon_trn_c )  c2t_mon_trn_ap; ///< Port outputting C2T Monitor Transactions.
   uvm_analysis_port      #(uvma_i2c_mon_trn_c )  t2c_mon_trn_ap; ///< Port outputting T2C Monitor Transactions.
   uvm_tlm_analysis_fifo  #(uvma_i2c_phy_mon_trn_c)  c2t_phy_mon_trn_fifo  ; ///< FIFO of C2T Phy Monitor Transactions obtained from uvma_i2c_mon_c.
   uvm_tlm_analysis_fifo  #(uvma_i2c_phy_mon_trn_c)  t2c_phy_mon_trn_fifo  ; ///< FIFO of T2C Phy Monitor Transactions obtained from uvma_i2c_mon_c.
   uvm_analysis_export    #(uvma_i2c_phy_mon_trn_c)  c2t_phy_mon_trn_export; ///< Port for C2T Phy Monitor Transactions obtained from uvma_i2c_mon_c.
   uvm_analysis_export    #(uvma_i2c_phy_mon_trn_c)  t2c_phy_mon_trn_export; ///< Port for T2C Phy Monitor Transactions obtained from uvma_i2c_mon_c.
   /// @}


   `uvm_component_utils_begin(uvma_i2c_vsqr_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_vsqr", uvm_component parent=null);

   /**
    * Ensures #cfg & #cntxt handles are not null
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Connects TLM Objects.
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
    * Creates sub-Components.
    */
   extern function void create_components();

   /**
    * Creates TLM Ports.
    */
   extern function void create_ports();

   /**
    * Connects TLM Ports to FIFOs.
    */
   extern function void connect_fifos();

endclass : uvma_i2c_vsqr_c


function uvma_i2c_vsqr_c::new(string name="uvma_i2c_vsqr", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_vsqr_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg          ();
   get_cntxt        ();
   create_components();
   create_ports     ();

endfunction : build_phase


function void uvma_i2c_vsqr_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   connect_fifos();

endfunction : connect_phase


function void uvma_i2c_vsqr_c::get_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_VSQR", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvma_i2c_vsqr_c::get_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_VSQR", "Context handle is null")
   end

endfunction : get_cntxt


function void uvma_i2c_vsqr_c::create_components();

   c2t_sequencer = uvma_i2c_phy_sqr_c::type_id::create("c2t_sequencer", this);
   t2c_sequencer = uvma_i2c_phy_sqr_c::type_id::create("t2c_sequencer", this);

endfunction : create_components


function void uvma_i2c_vsqr_c::create_ports();

   upstream_sqr_port = new("upstream_sqr_port", this);
   seq_item_ap       = new("seq_item_ap", this);
   c2t_mon_trn_ap         = new("c2t_mon_trn_ap"        , this);
   t2c_mon_trn_ap         = new("t2c_mon_trn_ap"        , this);
   c2t_phy_mon_trn_fifo   = new("c2t_phy_mon_trn_fifo"  , this);
   t2c_phy_mon_trn_fifo   = new("t2c_phy_mon_trn_fifo"  , this);
   c2t_phy_mon_trn_export = new("c2t_phy_mon_trn_export", this);
   t2c_phy_mon_trn_export = new("t2c_phy_mon_trn_export", this);

endfunction : create_ports


function void uvma_i2c_vsqr_c::connect_fifos();

   c2t_phy_mon_trn_export.connect(c2t_phy_mon_trn_fifo.analysis_export);
   t2c_phy_mon_trn_export.connect(t2c_phy_mon_trn_fifo.analysis_export);

endfunction : connect_fifos


`endif // __UVMA_I2C_VSQR_SV__