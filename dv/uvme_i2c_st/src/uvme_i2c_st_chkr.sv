// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_CHKR_SV__
`define __UVME_I2C_ST_CHKR_SV__


/**
 * Encapsulates assertions targeting uvme_${name}_st interfaces.
 * This module must be bound to interfaces in a test bench.
 */
module uvme_i2c_st_chkr (
      uvma_i2c_if  ctlr_if, ///<  CTLR Agent interface
      uvma_i2c_if  tagt_if, ///<  TAGT Agent interface
      uvma_i2c_if  passive_if       ///< Passive Agent interface.
);

   // TODO Add assertions to uvme_i2c_st_chkr

endmodule : uvme_i2c_st_chkr


`endif // __UVME_I2C_ST_CHKR_SV__