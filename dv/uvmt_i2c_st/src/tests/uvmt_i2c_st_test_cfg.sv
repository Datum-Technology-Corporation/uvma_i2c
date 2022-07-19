// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_I2C_ST_TEST_CFG_SV__
`define __UVMT_I2C_ST_TEST_CFG_SV__


/**
 * Object encapsulating common configuration parameters for i2c UVM Agent Self-Tests.
 */
class uvmt_i2c_st_test_cfg_c extends uvml_test_cfg_c;

   /// @defgroup Knobs
   /// @{
   rand int unsigned  clk_period        ; ///< Test bench clock period (ps)
   rand int unsigned  reset_period      ; ///< Test bench reset pulse duration (ns)
   rand int unsigned  startup_timeout   ; ///< Timer ending test if no heartbeat is detected from start of simulation (ns)
   rand int unsigned  heartbeat_period  ; ///< Timer ending phase if no heartbeat is detected from start of a phase (ns)
   rand int unsigned  simulation_timeout; ///< Timer ending simulation (ns)
   /// @}

   /// @defgroup Command line arguments
   /// @{
   bit           cli_num_seq_items_override = 0; ///< Set to '1' if argument was found for #num_seq_items.
   int unsigned  cli_num_seq_items_parsed; ///< Parsed integer value from the CLI for #num_seq_items.
   /// @}


   `uvm_object_utils_begin(uvmt_i2c_st_test_cfg_c)
      `uvm_field_int(clk_period        , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(reset_period      , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(startup_timeout   , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(heartbeat_period  , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(simulation_timeout, UVM_DEFAULT + UVM_DEC)

      `uvm_field_int(cli_num_seq_items_override, UVM_DEFAULT          )
      `uvm_field_int(cli_num_seq_items_parsed  , UVM_DEFAULT + UVM_DEC)
   `uvm_object_utils_end


   /**
    * Sets safe defaults for all simulation timing parameters.
    */
   constraint defaults_cons {
      clk_period         == uvmt_i2c_st_default_clk_period        ;
      reset_period       == uvmt_i2c_st_default_reset_period      ;
      startup_timeout    == uvmt_i2c_st_default_startup_timeout   ;
      heartbeat_period   == uvmt_i2c_st_default_heartbeat_period  ;
      simulation_timeout == uvmt_i2c_st_default_simulation_timeout;
   }


   /**
    * Default constructor.
    */
   extern function new(string name="uvmt_i2c_st_test_cfg");

   /**
    * Processes command line interface arguments.
    */
   extern function void process_cli_args();

endclass : uvmt_i2c_st_test_cfg_c


function uvmt_i2c_st_test_cfg_c::new(string name="uvmt_i2c_st_test_cfg");

   super.new(name);

endfunction : new


function void uvmt_i2c_st_test_cfg_c::process_cli_args();

   string  cli_num_seq_items_parsed_str  = "";

   if ($value$plusargs("NUM_SEQ_ITEMS=", cli_num_seq_items_parsed_str)) begin
      if (cli_num_seq_items_parsed_str != "") begin
         cli_num_seq_items_override = 1;
         cli_num_seq_items_parsed = cli_num_seq_items_parsed_str.atoi();
      end
      else begin
         cli_num_seq_items_override = 0;
      end
   end
   else begin
      cli_num_seq_items_override = 0;
   end

endfunction : process_cli_args


`endif // __UVMT_I2C_ST_TEST_CFG_SV__