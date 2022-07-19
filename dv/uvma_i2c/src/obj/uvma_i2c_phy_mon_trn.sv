// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_PHY_MON_TRN_SV__
`define __UVMA_I2C_PHY_MON_TRN_SV__


/**
 * Phy Monitor Transaction sampled by monitor (uvma_i2c_mon_c).
 * Analog of uvma_i2c_phy_seq_item_c.
 */
class uvma_i2c_phy_mon_trn_c extends uvml_mon_trn_c;

   uvma_i2c_cfg_c  cfg; ///< Agent configuration handle

   /// @defgroup Data
   /// @{
   logic  dp; ///< Positive differential signal
   logic  dn; ///< Negative differential signal
   /// @}


   `uvm_object_utils_begin(uvma_i2c_phy_mon_trn_c)
      `uvm_field_int(dp, UVM_DEFAULT)
      `uvm_field_int(dn, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_phy_mon_trn");

   /**
    * Describes transaction as metadata for uvml_logs_metadata_logger_c.
    */
   extern function uvml_metadata_t get_metadata();

endclass : uvma_i2c_phy_mon_trn_c


function uvma_i2c_phy_mon_trn_c::new(string name="uvma_i2c_phy_mon_trn");

   super.new(name);

endfunction : new


function uvml_metadata_t uvma_i2c_phy_mon_trn_c::get_metadata();

   string dp_str = $sformatf("%b", dp);
   string dn_str = $sformatf("%b", dn);

   get_metadata.push_back('{
      index     : 0,
      value     : dp_str,
      col_name  : "dp",
      col_width : dp_str.len(),
      col_align : UVML_TEXT_ALIGN_RIGHT,
      data_type : UVML_FIELD_INT
   });
   get_metadata.push_back('{
      index     : 0,
      value     : dn_str,
      col_name  : "dn",
      col_width : dn_str.len(),
      col_align : UVML_TEXT_ALIGN_RIGHT,
      data_type : UVML_FIELD_INT
   });

endfunction : get_metadata


`endif // __UVMA_I2C_PHY_MON_TRN_SV__