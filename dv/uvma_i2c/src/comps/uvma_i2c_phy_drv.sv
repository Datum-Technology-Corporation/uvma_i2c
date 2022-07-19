// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_PHY_DRV_SV__
`define __UVMA_I2C_PHY_DRV_SV__


/**
 * Driver driving I2C Virtual Interface (uvma_i2c_if) in either direction.
 */
class uvma_i2c_phy_drv_c extends uvml_drv_c #(
   .REQ(uvma_i2c_phy_seq_item_c),
   .RSP(uvma_i2c_phy_seq_item_c)
);

   virtual uvma_i2c_if.drv_c2t_mp  c2t_mp; ///< Handle to Virtual Interface C2T modport
   virtual uvma_i2c_if.drv_t2c_mp  t2c_mp; ///< Handle to Virtual Interface T2C modport

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c  cntxt; ///< Agent context handle
   /// @}

   /// @defgroup TLM Ports
   /// @{
   uvm_analysis_port#(uvma_i2c_phy_seq_item_c)  ap; ///< Port outputting Phy Sequence Items after they've been used to drive the Virtual Interface.
   /// @}


   `uvm_component_utils_begin(uvma_i2c_phy_drv_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_t2c_drv", uvm_component parent=null);

   /**
    * 1. Ensures #cfg & #cntxt handles are not null.
    * 2. Builds TLM Ports.
    * 3. Retrieves modport handles from #cntxt.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Infinite loop taking in #req and driving #mp on each clock cycle.
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
    * Creates #ap.
    */
   extern function void create_tlm_ports();

   /**
    * Retrieves #mp from #cntxt.
    */
   extern function void retrieve_modports();

   /**
    * Appends #cfg to #req and prints it out.
    */
   extern virtual function void process_req(ref uvma_i2c_phy_seq_item_c req);

   /**
    * Drives #mp signals using #req's contents on the next clock cycle.
    */
   extern virtual task drv_req(ref uvma_i2c_phy_seq_item_c req);

endclass : uvma_i2c_phy_drv_c


function uvma_i2c_phy_drv_c::new(string name="uvma_i2c_t2c_drv", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_phy_drv_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_cfg          ();
   get_cntxt        ();
   create_tlm_ports ();
   retrieve_modports();

endfunction : build_phase


task uvma_i2c_phy_drv_c::run_phase(uvm_phase phase);

   super.run_phase(phase);
   if (cfg.enabled && cfg.is_active) begin
      forever begin
         seq_item_port.get_next_item(req);
         process_req                (req);
         drv_req                    (req);
         ap.write                   (req);
         seq_item_port.item_done();
      end
   end

endtask : run_phase


function void uvma_i2c_phy_drv_c::get_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_PHY_DRV", "Configuration handle is null")
   end

endfunction : get_cfg


function void uvma_i2c_phy_drv_c::get_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_PHY_DRV", "Context handle is null")
   end

endfunction : get_cntxt


function void uvma_i2c_phy_drv_c::create_tlm_ports();

   ap = new("ap", this);

endfunction : create_tlm_ports


function void uvma_i2c_phy_drv_c::retrieve_modports();

   c2t_mp = cntxt.vif.drv_c2t_mp;
   t2c_mp = cntxt.vif.drv_t2c_mp;

endfunction : retrieve_modports


function void uvma_i2c_phy_drv_c::process_req(ref uvma_i2c_phy_seq_item_c req);

   req.cfg = cfg;
   `uvm_info("I2C_T2C_PHY_DRV", $sformatf("Got new req from the sequencer:\n%s", req.sprint()), UVM_DEBUG)

endfunction : process_req


task uvma_i2c_phy_drv_c::drv_req(ref uvma_i2c_phy_seq_item_c req);

      case (cfg.drv_mode)
      UVMA_I2C_DRV_MODE_CTLR: begin
         @(c2t_mp.drv_c2t_cb);
         c2t_mp.drv_c2t_cb.c2tp <= req.dp;
         c2t_mp.drv_c2t_cb.c2tn <= req.dn;
      end
      UVMA_I2C_DRV_MODE_TAGT: begin
         @(t2c_mp.drv_t2c_cb);
         t2c_mp.drv_t2c_cb.t2cp <= req.dp;
         t2c_mp.drv_t2c_cb.t2cn <= req.dn;
      end
   endcase

endtask : drv_req


`endif // __UVMA_I2C_PHY_DRV_SV__