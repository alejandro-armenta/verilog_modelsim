`timescale 1ns / 1ps

module tb_lfsr_counter;

  // Testbench signals
  reg  clk;
  reg  resetb;
  reg  new_cntr_preset;
  wire ctr_expired;

  // Instantiate the Device Under Test (DUT)
  lfsr_counter dut (
      .clk            (clk),
      .resetb         (resetb),
      .new_cntr_preset(new_cntr_preset),
      .ctr_expired    (ctr_expired)
  );

  // Clock generation: 10ns period (100 MHz)
  initial clk = 0;
  always #5 clk = ~clk;

  // Monitor state changes on every rising clock edge
  always @(posedge clk) begin
    $display("Time=%0t ns | resetb=%b | preset=%b | lfsr_cnt=%b (0x%h) | ctr_expired=%b", $time,
             resetb, new_cntr_preset, dut.lfsr_cnt, dut.lfsr_cnt, ctr_expired);
  end

  // Main stimulus block
  initial begin
    // Waveform dump setup (works with Icarus Verilog / GTKWave / Verilator)
    $dumpfile("lfsr_counter.vcd");
    $dumpvars(0, tb_lfsr_counter);

    // 1. Initialize inputs and assert active-low reset
    resetb          = 0;
    new_cntr_preset = 0;
    #12;  // Hold reset across a clock edge

    // 2. Release reset and let the counter run through a full 15-state cycle
    resetb = 1;
    $display("--- Starting full 15-state sequence ---");

    // Cycle 0 is 4'b1111; Cycle 14 should reach 4'b0111 and assert ctr_expired
    repeat (14) @(posedge clk);
    #1;  // Small delay to sample combinational output after clock edge
    if (ctr_expired !== 1'b1)
      $error("FAIL: Expected ctr_expired=1 at Cycle 14 (state 0111), got %b", ctr_expired);
    else $display("PASS: ctr_expired asserted properly at state 4'b0111!");

    // 3. Step one more cycle to verify wrap-around back to 4'b1111
    @(posedge clk);
    #1;
    if (dut.lfsr_cnt !== 4'b1111 || ctr_expired !== 1'b0)
      $error("FAIL: Expected wrap-around to 4'b1111 with ctr_expired=0");
    else $display("PASS: Wrapped back to 4'b1111 cleanly!");

    // 4. Advance a few cycles, then test synchronous new_cntr_preset
    repeat (4) @(posedge clk);
    $display("--- Testing synchronous preset ---");
    @(negedge clk);
    new_cntr_preset = 1;
    @(posedge clk);
    #1;
    if (dut.lfsr_cnt !== 4'b1111) $error("FAIL: Synchronous preset did not load 4'b1111");
    else $display("PASS: Synchronous preset loaded 4'b1111!");

    @(negedge clk);
    new_cntr_preset = 0;

    // 5. Run a few more cycles and finish
    repeat (3) @(posedge clk);
    $display("--- Simulation Complete ---");
    $finish;
  end

endmodule
