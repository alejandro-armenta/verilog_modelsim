`timescale 1ns / 1ps


module tb_counter;

  reg clk;
  reg resetb;
  reg new_cntr_preset;
  reg [7:0] new_cntr_preset_value;
  reg enable_cnt_up;
  reg enable_cnt_dn;
  reg pause_counting;

  wire ctr_expired;

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


  initial begin
    clk = 0;
    forever begin
      #5;
      clk = ~clk;
    end
  end

  initial begin

    $dumpfile("../simulation.vcd");
    $dumpvars(0, tb_counter);


    resetb = 0;
    new_cntr_preset = 0;
    new_cntr_preset_value = 8'h00;
    enable_cnt_up = 0;
    enable_cnt_dn = 0;
    pause_counting = 0;

    #20;
    resetb = 1;

    $finish;

  end

endmodule
