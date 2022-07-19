// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_CONSTANTS_SV__
`define __UVMA_I2C_CONSTANTS_SV__


const bit                       uvma_i2c_big_endian      =             1; ///< Endianness for bit ordering.
const int unsigned              uvma_i2c_training_length =            64; ///< Training sequence length (bits).
const int unsigned              uvma_i2c_syncing_length  =            32; ///< Syncing consecutive edge count.
const int unsigned              uvma_i2c_trn_length      =    32 + 2 + 2; ///< Full length of transaction (bits).
const uvma_i2c_tail_b_t  uvma_i2c_tail_symbol     =         2'b11; ///< Data for transaction tails.
const uvma_i2c_data_b_t  uvma_i2c_idle_data       = 32'h0000_0000; ///< Data for idle transaction 'payload'.


`endif // __UVMA_I2C_CONSTANTS_SV__