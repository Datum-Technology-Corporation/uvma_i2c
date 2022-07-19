// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_DRV_SV__
`define __UVMA_I2C_DRV_SV__


/**
 * Component driving I2C Interface (uvma_i2c_if) in either direction.
 */
class uvma_i2c_drv_c extends uvm_component;

   /// @defgroup Objects
   /// @{
   uvma_i2c_cfg_c    cfg  ; ///< Agent configuration handle
   uvma_i2c_cntxt_c  cntxt; ///< Agent context handle
   // @}

   /// @defgroup Components
   /// @{
   uvma_i2c_phy_drv_c  c2t_driver; ///< Drives Virtual Interface with C2T Phy Sequence Items
   uvma_i2c_phy_drv_c  t2c_driver; ///< Drives Virtual Interface with T2C Phy Sequence Items
   /// @}

   /// @defgroup TLM Ports
   /// @{
   uvm_analysis_port#(uvma_i2c_phy_seq_item_c)  c2t_ap; ///< Port outputting C2T Phy Sequence Items after they've been driven
   uvm_analysis_port#(uvma_i2c_phy_seq_item_c)  t2c_ap; ///< Port outputting T2C Phy Sequence Items after they've been driven
   /// @}

   `uvm_component_utils_begin(uvma_i2c_drv_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_drv", uvm_component parent=null);

   /**
    * 1. Ensures #cfg & #cntxt handles are not null.
    * 2. Creates sub-components.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Connects TLM Ports.
    */
   extern virtual function void connect_phase(uvm_phase phase);

   /**
    * Uses uvm_config_db to retrieve cfg and hand out to sub-components.
    */
   extern function void get_and_set_cfg();

   /**
    * Uses uvm_config_db to retrieve cntxt and hand out to sub-components.
    */
   extern function void get_and_set_cntxt();

   /**
    * Creates sub-drivers.
    */
   extern function void create_components();

   /**
    * Connects analysis ports to sub-drivers.
    */
   extern function void connect_ports();

endclass : uvma_i2c_drv_c


function uvma_i2c_drv_c::new(string name="uvma_i2c_drv", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_i2c_drv_c::build_phase(uvm_phase phase);

   super.build_phase(phase);
   get_and_set_cfg  ();
   get_and_set_cntxt();
   create_components();

endfunction : build_phase


function void uvma_i2c_drv_c::connect_phase(uvm_phase phase);

   super.connect_phase(phase);
   connect_ports();

endfunction : connect_phase


function void uvma_i2c_drv_c::get_and_set_cfg();

   void'(uvm_config_db#(uvma_i2c_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("I2C_DRV", "Configuration handle is null")
   end
   uvm_config_db#(uvma_i2c_cfg_c)::set(this, "*", "cfg", cfg);

endfunction : get_and_set_cfg


function void uvma_i2c_drv_c::get_and_set_cntxt();

   void'(uvm_config_db#(uvma_i2c_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("I2C_DRV", "Context handle is null")
   end
   uvm_config_db#(uvma_i2c_cntxt_c)::set(this, "*", "cntxt", cntxt);

endfunction : get_and_set_cntxt


function void uvma_i2c_drv_c::create_components();

   c2t_driver = uvma_i2c_phy_drv_c::type_id::create("c2t_driver", this);
   t2c_driver = uvma_i2c_phy_drv_c::type_id::create("t2c_driver", this);

endfunction : create_components


function void uvma_i2c_drv_c::connect_ports();

   c2t_ap = c2t_driver.ap;
   t2c_ap = t2c_driver.ap;

endfunction : connect_ports


`endif // __UVMA_I2C_DRV_SV__