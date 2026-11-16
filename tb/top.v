`timescale 1ns / 1ps

module top;

  reg  clka;
  reg  clkb;

  reg  sig_a;

  reg  rstb;

  wire sig_a_posedge;

  register_async dut (
      .clkb(clkb),
      .rstb(rstb),
      .sig_a(sig_a),
      .sig_a_posedge(sig_a_posedge)
  );

  initial begin

    clka = 0;

    forever begin
      // 13 ns;

      #6.5;
      clka = ~clka;
    end

  end

  initial begin

    clkb = 0;

    forever begin

      // 10 ns

      #5.0;

      clkb = ~clkb;
    end

  end

  initial begin

    $dumpfile("simulation.vcd");
    $dumpvars(0, top);

    sig_a = 0;
    rstb  = 0;

    #23;

    rstb = 1;

    #20;

    repeat (15) begin
      @(posedge clka);
      sig_a <= 1;
      repeat (3) @(posedge clka);
      sig_a <= 0;
      repeat (2) @(posedge clka);
    end

    $finish;

  end


endmodule
