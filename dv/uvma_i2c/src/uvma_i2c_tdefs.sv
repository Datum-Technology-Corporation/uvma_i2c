// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_TDEFS_SV__
`define __UVMA_I2C_TDEFS_SV__


typedef bit   [ 1:0]  uvma_i2c_header_b_t; ///< Vector representing header data in bit type
typedef logic [ 1:0]  uvma_i2c_header_l_t; ///< Vector representing header data in logic type
typedef bit   [31:0]  uvma_i2c_data_b_t  ; ///< Vector representing 'payload' data in bit type
typedef logic [31:0]  uvma_i2c_data_l_t  ; ///< Vector representing 'payload' data in logi type
typedef bit   [ 1:0]  uvma_i2c_tail_b_t  ; ///< Vector representing tail data in bit type
typedef logic [ 1:0]  uvma_i2c_tail_l_t  ; ///< Vector representing tail data in logic type

/**
 * Enumerates all operational modes when uvma_i2c_agent_c is active.
 */
typedef enum {
   UVMA_I2C_DRV_MODE_CTLR, ///< TODO Describe ctlr
   UVMA_I2C_DRV_MODE_TAGT  ///< TODO Describe tagt
} uvma_i2c_mode_enum;

/**
 * Labels for data paths.
 */
typedef enum {
   UVMA_I2C_DIRECTION_C2T, ///< TODO Describe c2t
   UVMA_I2C_DIRECTION_T2C  ///< TODO Describe t2c
} uvma_i2c_direction_enum;

/**
 * States for monitor's Finite State Machine.
 */
typedef enum {
   UVMA_I2C_MON_FSM_INIT    , ///< Immediate state upon reset
   UVMA_I2C_MON_FSM_TRAINING, ///< Looking for training sequence
   UVMA_I2C_MON_FSM_SYNCING , ///< Looking for headers at constant interval
   UVMA_I2C_MON_FSM_SYNCED    ///< Locked onto data stream
} uvma_i2c_mon_fsm_enum;

/**
 * Transaction types.
 */
typedef enum bit [1:0] {
   UVMA_I2C_HEADER_IDLE = 2'b01, ///< Contents are to be discarded
   UVMA_I2C_HEADER_DATA = 2'b10  ///< Contents is 'payload' data
} uvma_i2c_header_enum;


`endif // __UVMA_I2C_TDEFS_SV__