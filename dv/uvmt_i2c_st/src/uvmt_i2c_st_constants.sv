// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_I2C_ST_CONSTANTS_SV__
`define __UVMT_I2C_ST_CONSTANTS_SV__


const int unsigned uvmt_i2c_st_default_clk_period          =     10_000; ///< Default clock period in ps
const int unsigned uvmt_i2c_st_default_reset_period        =        100; ///< Default reset period in ns
const int unsigned uvmt_i2c_st_default_startup_timeout     =     10_000; ///< Default Heartbeat Monitor startup timeout in ns
const int unsigned uvmt_i2c_st_default_heartbeat_period    =      5_000; ///< Default Heartbeat Monitor period in ns
const int unsigned uvmt_i2c_st_default_simulation_timeout  =  1_000_000; ///< Default Watchdog Timer simulation timeout in ns


`endif // __UVMT_I2C_ST_CONSTANTS_SV__