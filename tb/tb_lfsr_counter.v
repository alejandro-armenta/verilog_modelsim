module tb_lfsr_counter;

  reg  clk;
  reg  resetb;
  reg  new_cntr_preset;
  wire ctr_expired;

  lfsr_counter dut (
      .clk(clk),
      .resetb(resetb),
      .new_cntr_preset(new_cntr_preset),
      .ctr_expired(ctr_expired)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb_lfsr_counter);



    $finish;
  end

endmodule
