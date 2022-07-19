// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_I2C_ST_TDEFS_SV__
`define __UVME_I2C_ST_TDEFS_SV__


/**
 * Scoreboard specialization for I2C Monitor Transactions.
 */
typedef uvml_sb_simplex_c #(
   .T_ACT_TRN(uvma_i2c_mon_trn_c)
) uvme_i2c_st_sb_simplex_c;


`endif // __UVME_I2C_ST_TDEFS_SV__