`timescale 1ns / 1ps

module register_async (
    sig_a,
    clkb,
    rstb,
    sig_a_posedge
);

  input sig_a;

  input clkb;

  input rstb;

  output sig_a_posedge;

  wire sig_a_posedge;

  reg sig_a_d1, sig_a_d2, sig_a_d3;

  reg notifier;

  specify
    $setuphold(posedge clkb, sig_a, 1.5, 1.5, notifier);
  endspecify

  always @(posedge clkb or negedge rstb) begin

    if (!rstb) begin

      sig_a_d1 <= 1'b0;

      sig_a_d2 <= 1'b0;

      sig_a_d3 <= 1'b0;

    end else begin

      sig_a_d1 <= sig_a;

      sig_a_d2 <= sig_a_d1;

      sig_a_d3 <= sig_a_d2;

    end

  end

  always @(notifier) begin

    sig_a_d1 <= 1'bx;

    #3.5;

    sig_a_d1 <= sig_a;

  end

  assign sig_a_posedge = sig_a_d2 & !sig_a_d3;

endmodule
