// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_SEQ_ITEM_SV__
`define __UVMA_I2C_SEQ_ITEM_SV__


/**
 * Sequence Item created by I2C Sequences.
 */
class uvma_i2c_seq_item_c extends uvml_seq_item_c;

   uvma_i2c_cfg_c  cfg; ///< Agent configuration handle

   /// @defgroup Data
   /// @{
   rand uvma_i2c_header_enum  header; ///< Sync bits indicating IDLE or DATA contents.
   rand uvma_i2c_data_b_t     data  ; ///< 'Payload' data.
   rand uvma_i2c_tail_b_t     tail  ; ///< Bits indicating the end to the 'payload' data.
   /// @}



   `uvm_object_utils_begin(uvma_i2c_seq_item_c)
      `uvm_field_enum(uvma_i2c_header_enum, header, UVM_DEFAULT)
      `uvm_field_int(data , UVM_DEFAULT          )
      `uvm_field_int(tail , UVM_DEFAULT + UVM_BIN)
   `uvm_object_utils_end


   /**
    * Adds tail data and fills in IDLE data if needed.
    */
   constraint limits_cons {
      tail == uvma_i2c_tail_symbol;
      if (header == UVMA_I2C_HEADER_IDLE) {
         data == uvma_i2c_idle_data;
      }
   }


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_seq_item");

   /**
    * Describes transaction as metadata for uvml_logs_metadata_logger_c.
    */
   extern function uvml_metadata_t get_metadata();

endclass : uvma_i2c_seq_item_c


function uvma_i2c_seq_item_c::new(string name="uvma_i2c_seq_item");

   super.new(name);

endfunction : new


function uvml_metadata_t uvma_i2c_seq_item_c::get_metadata();

   string header_str = header.name();
   string tail_str = $sformatf("%b", tail);
   string data_str = $sformatf("%h", data);

   if (header != UVMA_I2C_HEADER_IDLE) begin
      if (header == UVMA_I2C_HEADER_DATA) begin
         header_str = "DATA";
      end
      else begin
         header_str = $sformatf("? %b", header);
      end
      get_metadata.push_back('{
         index     : 0,
         value     : header_str,
         col_name  : "header",
         col_width : header_str.len(),
         col_align : UVML_TEXT_ALIGN_RIGHT,
         data_type : UVML_FIELD_INT
      });
      get_metadata.push_back('{
         index     : 0,
         value     : tail_str,
         col_name  : "tail",
         col_width : tail_str.len(),
         col_align : UVML_TEXT_ALIGN_RIGHT,
         data_type : UVML_FIELD_INT
      });
      get_metadata.push_back('{
         index     : 0,
         value     : data_str,
         col_name  : "data",
         col_width : data_str.len(),
         col_align : UVML_TEXT_ALIGN_RIGHT,
         data_type : UVML_FIELD_INT
      });
   end

endfunction : get_metadata


`endif // __UVMA_I2C_SEQ_ITEM_SV__