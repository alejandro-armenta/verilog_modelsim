
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

  always @(posedge clk or negedge resetb) begin

    if (resetb) begin

      enable_cnt_up_d1 <= 0;
      enable_cnt_dn_d1 <= 0;

    end else begin

      enable_cnt_up_d1 <= enable_cnt_up;
      enable_cnt_dn_d1 <= enable_cnt_dn;

    end

  end

  assign enable_cnt_up_risedge   = enable_cnt_up & !enable_cnt_up_d1;

  assign enable_cnt_down_risedge = enable_cnt_dn & !enable_cnt_dn_d1;






endmodule
