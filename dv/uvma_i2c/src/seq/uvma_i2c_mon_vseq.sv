// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_I2C_MON_VSEQ_SV__
`define __UVMA_I2C_MON_VSEQ_SV__


/**
 * Virtual Sequence taking in Phy Monitor Transactions and creating I2C transactions (uvma_i2c_mon_trn_c).
 * Includes I2C monitor Finite State Machine implementation.
 */
class uvma_i2c_mon_vseq_c extends uvma_i2c_base_vseq_c;

   `uvm_object_utils(uvma_i2c_mon_vseq_c)

   /**
    * Default constructor.
    */
   extern function new(string name="uvma_i2c_mon_vseq");

   /**
    * Infinite loop maintaining 3 threads:
    * 1. C2T main sequence: wait for reset, link training, rebuild traffic from Phy transactions
    * 2. T2C main sequence: wait for reset, link training, rebuild traffic from Phy transactions
    * 3. Reset trigger for mid-sim reset which resets main sequences.
    */
   extern virtual task body();

   /**
    * Wait for reset state change in #cntxt.
    */
   extern task wait_for_reset_c2t();

   /**
    * Wait for reset state change in #cntxt.
    */
   extern task wait_for_reset_t2c();

   /**
    * Infinite loop taking in Phy Monitor Transactions and generating Monitor Transactions for C2T.
    */
   extern task monitor_c2t();

   /**
    * Infinite loop taking in Phy Monitor Transactions and generating Monitor Transactions for T2C.
    */
   extern task monitor_t2c();

   /**
    * Waits for mid-sim reset state change in #cntxt.
    */
   extern task reset_trigger();

   /**
    * Performs differential decoding on #p & #n.
    */
   extern function logic decode_bit(logic p, logic n);

   /**
    * Returns short string for use in `uvm_info() IDs.
    */
   extern function string get_direction_str(uvma_i2c_direction_enum direction);

   /**
    * Monitor Finite State Machine entry point. Returns '1' if enough data is present in #fsm_cntxt for a transaction.
    */
   extern function bit fsm(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction);

   /**
    * Unpacks Monitor Transaction from bits in C2T #cntxt.
    */
   extern function void unpack_c2t_trn(output uvma_i2c_mon_trn_c mon_trn);

   /**
    * Unpacks Monitor Transaction from bits in T2C #cntxt.
    */
   extern function void unpack_t2c_trn(output uvma_i2c_mon_trn_c mon_trn);

   /**
    * INIT FSM evaluation function.
    */
   extern function uvma_i2c_mon_fsm_enum fsm_init(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

   /**
    * TRAINING FSM evaluation function.
    */
   extern function uvma_i2c_mon_fsm_enum fsm_training(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

   /**
    * SYNCING FSM evaluation function.
    */
   extern function uvma_i2c_mon_fsm_enum fsm_syncing(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

   /**
    * SYNCED FSM evaluation function.
    */
   extern function uvma_i2c_mon_fsm_enum fsm_synced(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

endclass : uvma_i2c_mon_vseq_c


function uvma_i2c_mon_vseq_c::new(string name="uvma_i2c_mon_vseq");

   super.new(name);

endfunction : new


task uvma_i2c_mon_vseq_c::body();

   `uvm_info("I2C_MON_VSEQ", "Monitor virtual sequence has started", UVM_HIGH)
   forever begin
      fork
         begin
            wait_for_reset_c2t();
            monitor_c2t       ();
         end
         begin
            wait_for_reset_t2c();
            monitor_t2c       ();
         end
         begin
            reset_trigger();
         end
      join_any
      disable fork;
   end

endtask : body


task uvma_i2c_mon_vseq_c::wait_for_reset_c2t();

   `uvm_info("I2C_MON_VSEQ", "Waiting for post_reset on C2T", UVM_HIGH)
   wait (cntxt.reset_state == UVML_RESET_STATE_POST_RESET);
   `uvm_info("I2C_MON_VSEQ", "Done waiting for post_reset on C2T", UVM_HIGH)

endtask : wait_for_reset_c2t


task uvma_i2c_mon_vseq_c::wait_for_reset_t2c();

   `uvm_info("I2C_MON_VSEQ_T2C", "Waiting for post_reset on T2C", UVM_HIGH)
   wait (cntxt.reset_state == UVML_RESET_STATE_POST_RESET);
   `uvm_info("I2C_MON_VSEQ_T2C", "Done waiting for post_reset on T2C", UVM_HIGH)

endtask : wait_for_reset_t2c


task uvma_i2c_mon_vseq_c::monitor_c2t();

   uvma_i2c_phy_mon_trn_c  phy_trn;
   uvma_i2c_mon_trn_c  mon_trn;
   bit  unpack_trn;
   bit  trn_data[];

   forever begin
      get_c2t_phy_mon_trn(phy_trn);
      `uvm_info("I2C_MON_VSEQ_C2T", $sformatf("Got Phy Monitor Transaction:\n%s", phy_trn.sprint()), UVM_DEBUG)
      cntxt.c2t_mon_fsm_cntxt.data_q.push_back(decode_bit(phy_trn.dp, phy_trn.dn));
      cntxt.c2t_mon_fsm_cntxt.timestamps_q.push_back(phy_trn.get_timestamp_start());
      `uvm_info("I2C_MON_VSEQ_C2T", $sformatf("Monitor has accumulated %0d bits", cntxt.c2t_mon_fsm_cntxt.trn_data.size()), UVM_DEBUG)
      unpack_trn = fsm(cntxt.c2t_mon_fsm_cntxt, UVMA_I2C_DIRECTION_C2T);
      if (unpack_trn) begin
         unpack_c2t_trn(mon_trn);
         if (mon_trn.header != UVMA_I2C_HEADER_IDLE) begin
            `uvm_info("I2C_MON_VSEQ_C2T", $sformatf("Unpacked Data Monitor Transaction:\n%s", mon_trn.sprint()), UVM_HIGH)
            `uvml_hrtbt_owner(p_sequencer)
            write_c2t_mon_trn(mon_trn);
         end
      end
   end

endtask : monitor_c2t


task uvma_i2c_mon_vseq_c::monitor_t2c();

   uvma_i2c_phy_mon_trn_c  phy_trn;
   uvma_i2c_mon_trn_c  mon_trn;
   bit  unpack_trn;
   bit  trn_data[];

   forever begin
      get_t2c_phy_mon_trn(phy_trn);
      `uvm_info("I2C_MON_VSEQ_T2C", $sformatf("Got Phy Monitor Transaction:\n%s", phy_trn.sprint()), UVM_DEBUG)
      cntxt.t2c_mon_fsm_cntxt.data_q.push_back(decode_bit(phy_trn.dp, phy_trn.dn));
      cntxt.t2c_mon_fsm_cntxt.timestamps_q.push_back(phy_trn.get_timestamp_start());
      `uvm_info("I2C_MON_VSEQ_T2C", $sformatf("Monitor has accumulated %0d bits", cntxt.t2c_mon_fsm_cntxt.trn_data.size()), UVM_DEBUG)
      unpack_trn = fsm(cntxt.t2c_mon_fsm_cntxt, UVMA_I2C_DIRECTION_T2C);
      if (unpack_trn) begin
         unpack_t2c_trn(mon_trn);
         if (mon_trn.header != UVMA_I2C_HEADER_IDLE) begin
            `uvm_info("I2C_MON_VSEQ_T2C", $sformatf("Unpacked Data Monitor Transaction:\n%s", mon_trn.sprint()), UVM_HIGH)
            `uvml_hrtbt_owner(p_sequencer)
            write_t2c_mon_trn(mon_trn);
         end
      end
   end

endtask : monitor_t2c


task uvma_i2c_mon_vseq_c::reset_trigger();

   wait (cntxt.reset_state == UVML_RESET_STATE_POST_RESET);
   wait (cntxt.reset_state != UVML_RESET_STATE_POST_RESET);
   `uvm_info("I2C_MON_VSEQ", "Mid-sim reset detected. Resetting main loop.", UVM_NONE)

endtask : reset_trigger


function logic uvma_i2c_mon_vseq_c::decode_bit(logic p, logic n);

   case ({p,n})
      2'b10  : return 1'b1;
      2'b01  : return 1'b0;
      default: return 1'bx;
   endcase

endfunction : decode_bit


function string uvma_i2c_mon_vseq_c::get_direction_str(uvma_i2c_direction_enum direction);

   case (direction)
      UVMA_I2C_DIRECTION_C2T : return "C2T";
      UVMA_I2C_DIRECTION_T2C : return "T2C";
   endcase

endfunction : get_direction_str


function bit uvma_i2c_mon_vseq_c::fsm(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction);

   bit unpack_trn;
   uvma_i2c_mon_fsm_enum  next_state;
   case (fsm_cntxt.state)
      UVMA_I2C_MON_FSM_INIT    : next_state = fsm_init    (fsm_cntxt, direction, unpack_trn);
      UVMA_I2C_MON_FSM_TRAINING: next_state = fsm_training(fsm_cntxt, direction, unpack_trn);
      UVMA_I2C_MON_FSM_SYNCING : next_state = fsm_syncing (fsm_cntxt, direction, unpack_trn);
      UVMA_I2C_MON_FSM_SYNCED  : next_state = fsm_synced  (fsm_cntxt, direction, unpack_trn);
      default: begin
         `uvm_error({"I2C_MON_VSEQ_", get_direction_str(direction)}, $sformatf("%s - Invalid state, changing to INIT", fsm_cntxt.state.name()))
         next_state = UVMA_I2C_MON_FSM_INIT;
      end
   endcase
   fsm_cntxt.state = next_state;
   cntxt.sample_cntxt_e.trigger();
   return unpack_trn;

endfunction : fsm


function void uvma_i2c_mon_vseq_c::unpack_c2t_trn(output uvma_i2c_mon_trn_c mon_trn);

   `uvm_info("I2C_MON_VSEQ_C2T", $sformatf("Unpacking Monitor Transaction from %0d bits", cntxt.c2t_mon_fsm_cntxt.trn_data.size()), UVM_DEBUG)
   mon_trn = uvma_i2c_mon_trn_c::type_id::create("mon_trn");
   uvm_default_packer.big_endian = uvma_i2c_big_endian;
   void'(mon_trn.unpack(cntxt.c2t_mon_fsm_cntxt.trn_data));
   mon_trn.set_initiator(p_sequencer);
   mon_trn.direction = UVMA_I2C_DIRECTION_C2T;
   mon_trn.cfg = cfg;
   mon_trn.set_error(!mon_trn.self_check());
   mon_trn.set_timestamp_start(cntxt.c2t_mon_fsm_cntxt.trn_start);
   mon_trn.set_timestamp_end  (cntxt.c2t_mon_fsm_cntxt.trn_end  );

endfunction : unpack_c2t_trn


function void uvma_i2c_mon_vseq_c::unpack_t2c_trn(output uvma_i2c_mon_trn_c mon_trn);

   `uvm_info("I2C_MON_VSEQ_T2C", $sformatf("Unpacking Monitor Transaction from %0d bits", cntxt.t2c_mon_fsm_cntxt.trn_data.size()), UVM_DEBUG)
   mon_trn = uvma_i2c_mon_trn_c::type_id::create("mon_trn");
   uvm_default_packer.big_endian = uvma_i2c_big_endian;
   void'(mon_trn.unpack(cntxt.t2c_mon_fsm_cntxt.trn_data));
   mon_trn.set_initiator(p_sequencer);
   mon_trn.direction = UVMA_I2C_DIRECTION_T2C;
   mon_trn.cfg = cfg;
   mon_trn.set_error(!mon_trn.self_check());
   mon_trn.set_timestamp_start(cntxt.t2c_mon_fsm_cntxt.trn_start);
   mon_trn.set_timestamp_end  (cntxt.t2c_mon_fsm_cntxt.trn_end  );

endfunction : unpack_t2c_trn


function uvma_i2c_mon_fsm_enum uvma_i2c_mon_vseq_c::fsm_init(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

   uvma_i2c_mon_fsm_enum  next_state;
   string  direction_str = get_direction_str(direction);
   next_state = UVMA_I2C_MON_FSM_TRAINING;
   `uvm_info({"I2C_MON_VSEQ_", direction_str}, $sformatf("%s - Resetting state variables", fsm_cntxt.state.name()), UVM_DEBUG)
   fsm_cntxt.reset();
   unpack_trn = 0;
   return next_state;

endfunction : fsm_init


function uvma_i2c_mon_fsm_enum uvma_i2c_mon_vseq_c::fsm_training(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

   logic  new_bit;
   uvma_i2c_mon_fsm_enum  next_state;
   string direction_str = get_direction_str(direction);
   next_state = UVMA_I2C_MON_FSM_TRAINING;
   new_bit = fsm_cntxt.data_q.pop_front();
   void'(fsm_cntxt.timestamps_q.pop_front());
   if (new_bit === 0) begin
      fsm_cntxt.training_count++;
      `uvm_info({"I2C_MON_VSEQ_", direction_str}, $sformatf("%s - Seen %0d consecutive 1'b0", fsm_cntxt.state.name(), fsm_cntxt.training_count), UVM_DEBUG)
   end
   if (fsm_cntxt.training_count >= uvma_i2c_training_length) begin
      `uvm_info({"I2C_MON_VSEQ_", direction_str}, $sformatf("%s - Training complete after %0d consecutive 0s", fsm_cntxt.state.name(), fsm_cntxt.training_count), UVM_LOW)
      next_state = UVMA_I2C_MON_FSM_SYNCING;
   end
   unpack_trn = 0;
   return next_state;

endfunction : fsm_training


function uvma_i2c_mon_fsm_enum uvma_i2c_mon_vseq_c::fsm_syncing(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

   uvma_i2c_header_l_t    header_bits;
   uvma_i2c_mon_fsm_enum  next_state;
   string direction_str = get_direction_str(direction);
   next_state = UVMA_I2C_MON_FSM_SYNCING;
   if (fsm_cntxt.data_q.size() >= uvma_i2c_trn_length) begin
      header_bits = {fsm_cntxt.data_q[0],fsm_cntxt.data_q[1]};
      `uvm_info({"I2C_MON_VSEQ_", direction_str}, $sformatf("%s - New potential header bits: %b", fsm_cntxt.state.name(), header_bits), UVM_DEBUG)
      if (header_bits == UVMA_I2C_HEADER_IDLE) begin
         fsm_cntxt.num_consecutive_edges++;
         `uvm_info({"I2C_MON_VSEQ_", direction_str}, $sformatf("%s - New valid header bits: %b. #%0d/%0d consecutive observed", fsm_cntxt.state.name(), header_bits, fsm_cntxt.num_consecutive_edges, uvma_i2c_syncing_length), UVM_DEBUG)
         if (fsm_cntxt.num_consecutive_edges >= uvma_i2c_syncing_length) begin
            next_state = UVMA_I2C_MON_FSM_SYNCED;
            `uvm_info({"I2C_MON_VSEQ_", direction_str}, $sformatf("Synced to bitstream after %0d consecutive headers at %0d-bit intervals", fsm_cntxt.num_consecutive_edges, uvma_i2c_trn_length), UVM_LOW)
         end
         // Dump entire potentially valid frames until we're fully synced
         repeat (uvma_i2c_trn_length) begin
            void'(fsm_cntxt.data_q      .pop_front());
            void'(fsm_cntxt.timestamps_q.pop_front());
         end
      end
      else begin
         // Still hunting for that first edge of many
         fsm_cntxt.num_consecutive_edges = 0;
         void'(fsm_cntxt.data_q      .pop_front());
         void'(fsm_cntxt.timestamps_q.pop_front());
      end
   end
   unpack_trn = 0;
   return next_state;

endfunction : fsm_syncing


function uvma_i2c_mon_fsm_enum uvma_i2c_mon_vseq_c::fsm_synced(uvma_i2c_mon_fsm_cntxt_c fsm_cntxt, uvma_i2c_direction_enum direction, output bit unpack_trn);

   uvma_i2c_mon_fsm_enum  next_state;
   string direction_str = get_direction_str(direction);
   next_state = UVMA_I2C_MON_FSM_SYNCED;
   if (fsm_cntxt.data_q.size() >= uvma_i2c_trn_length) begin
      `uvm_info({"I2C_MON_VSEQ_", direction_str}, $sformatf("%s - Have enough bits (%0d) to unpack trn", fsm_cntxt.state.name(), fsm_cntxt.data_q.size()), UVM_DEBUG)
      unpack_trn = 1;
      fsm_cntxt.trn_start = fsm_cntxt.timestamps_q[0];
      for (int unsigned ii=0; ii<uvma_i2c_trn_length; ii++) begin
         fsm_cntxt.trn_data[ii] = fsm_cntxt.data_q      .pop_front();
         fsm_cntxt.trn_end      = fsm_cntxt.timestamps_q.pop_front();
      end
   end
   else begin
      unpack_trn = 0;
   end
   return next_state;

endfunction : fsm_synced


`endif // __UVMA_I2C_MON_VSEQ_SV__