// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_CHKR_SV__
`define __UVMA_I2C_CHKR_SV__


/**
 * Encapsulates assertions targeting uvma_i2c_if.
 * This module must be bound to an interface in a test bench.
 */
module uvma_i2c_chkr(
   uvma_i2c_if  i2c_if ///< Target interface handle
);

   // TODO Add assertions to uvma_i2c_chkr

endmodule : uvma_i2c_chkr


`endif // __UVMA_I2C_CHKR_SV__