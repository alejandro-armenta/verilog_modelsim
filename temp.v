`timescale 1ns / 1ps

module tb_counter;

  // Testbench signals
  reg clk;
  reg resetb;
  reg new_cntr_preset;
  reg [7:0] new_cntr_preset_value;
  reg enable_cnt_up;
  reg enable_cnt_dn;
  reg pause_counting;

  wire ctr_expired;

  // Instantiate the Device Under Test (DUT)
  counter dut (
      .clk(clk),
      .resetb(resetb),
      .new_cntr_preset(new_cntr_preset),
      .new_cntr_preset_value(new_cntr_preset_value),
      .enable_cnt_up(enable_cnt_up),
      .enable_cnt_dn(enable_cnt_dn),
      .pause_counting(pause_counting),
      .ctr_expired(ctr_expired)
  );

  // Clock generation: 10ns period (100 MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Main test sequence
  initial begin
    // Setup waveform dumping (for GTKWave / Vivado / ModelSim)
    $dumpfile("counter_waves.vcd");
    $dumpvars(0, tb_counter);

    // 1. Initialize inputs & assert asynchronous reset
    resetb = 0;
    new_cntr_preset = 0;
    new_cntr_preset_value = 8'd0;
    enable_cnt_up = 0;
    enable_cnt_dn = 0;
    pause_counting = 0;

    #20;
    resetb = 1;  // Release reset
    @(posedge clk);

    // 2. Load a preset value (e.g., 5)
    $display("[%0t] Loading preset value = 5", $time);
    new_cntr_preset = 1;
    new_cntr_preset_value = 8'd5;
    @(posedge clk);
    new_cntr_preset = 0;
    @(posedge clk);

    // 3. Test Count Up (0 -> 5 -> wrap to 0)
    $display("[%0t] Starting Count Up...", $time);
    enable_cnt_up = 1;
    repeat (7) @(posedge clk);  // Run enough cycles to expire and wrap around

    // 4. Test Pause Functionality
    $display("[%0t] Testing Pause...", $time);
    pause_counting = 1;
    repeat (3) @(posedge clk);
    pause_counting = 0;
    repeat (2) @(posedge clk);
    enable_cnt_up = 0;
    @(posedge clk);

    // 5. Test Count Down (5 -> 0 -> wrap to 5)
    $display("[%0t] Starting Count Down...", $time);
    enable_cnt_dn = 1;
    repeat (7) @(posedge clk);  // Run enough cycles to expire and reload preset
    enable_cnt_dn = 0;

    // 6. Finish simulation
    #30;
    $display("[%0t] Simulation complete.", $time);
    $finish;
  end

  // Monitor internal state and outputs on every clock edge
  always @(posedge clk) begin
    $display("Time=%0t | rst=%b | up=%b dn=%b pause=%b | count=%0d (preset=%0d) | expired=%b",
             $time, resetb, enable_cnt_up, enable_cnt_dn, pause_counting, dut.count255,
             dut.cnt_preset_stored, ctr_expired);
  end

endmodule
