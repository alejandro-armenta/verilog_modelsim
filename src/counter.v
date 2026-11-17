
// counter sincrono

module counter (
    clk,
    resetb,
    new_cntr_preset,
    new_cntr_preset_value,
    enable_cnt_up,
    enable_cnt_dn,
    pause_counting,
    ctr_expired
);

  input clk;

  input resetb;

  input new_cntr_preset;

  input [7:0] new_cntr_preset_value;

  input enable_cnt_up;

  input enable_cnt_dn;

  input pause_counting;

  output ctr_expired;

  reg ctr_expired;

  wire enable_cnt_up_risedge, enable_cnt_down_risedge;

  reg enable_cnt_up_d1, enable_cnt_dn_d1;

  reg [7:0] cnt_preset_stored;

  wire [7:0] cnt_preset_stored_nxt;

  wire ctr_expired_next;

  // aqui se guarda la variable principal
  reg [7:0] count255_nxt, count255;

  assign enable_cnt_up_risedge = enable_cnt_up & !enable_cnt_up_d1;

  assign enable_cnt_down_risedge = enable_cnt_dn & !enable_cnt_dn_d1;

  assign cnt_preset_stored_nxt = new_cntr_preset ? new_cntr_preset_value : cnt_preset_stored;

  assign ctr_expired_next = enable_cnt_up ? (count255_nxt == cnt_preset_stored) : enable_cnt_dn ? (count255_nxt == 0) : 0;

  always @(*) begin

    // siempre se copia de los registros y no de los wires

    count255_nxt = count255;

    // este ya tiene que estar reseteado para que pase al siguiente

    if (enable_cnt_down_risedge) count255_nxt = cnt_preset_stored;

    else if (enable_cnt_up_risedge) count255_nxt = 'd0;

    else if (pause_counting) count255_nxt = count255;

    else if (enable_cnt_dn && ctr_expired) count255_nxt = cnt_preset_stored;

    else if (enable_cnt_dn) count255_nxt = count255 - 1'b1;

    else if (enable_cnt_up && ctr_expired) count255_nxt = 'd0;

    // despues se injecta esta

    else if (enable_cnt_up) count255_nxt = count255 + 1'b1;

  end

  always @(posedge clk or negedge resetb) begin

    if (!resetb) begin

      enable_cnt_up_d1 <= 1'b0;

      enable_cnt_dn_d1 <= 1'b0;

      ctr_expired <= 1'b0;

      cnt_preset_stored <= 'd0;

      count255 <= 'd0;

    end else begin

      enable_cnt_up_d1 <= enable_cnt_up;

      enable_cnt_dn_d1 <= enable_cnt_dn;

      cnt_preset_stored <= cnt_preset_stored_nxt;

      ctr_expired <= ctr_expired_next;

      // sino se volveria zero en el mismo ciclo y no

      count255 <= count255_nxt;

    end

  end

endmodule
