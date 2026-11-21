module lfsr_counter (
    clk,
    resetb,
    new_cntr_preset,
    ctr_expired
);

  input clk;
  input resetb;
  input new_cntr_preset;

  output ctr_expired;

  wire [3:0] lfsr_cnt_xor;

  reg [3:0] lfsr_cnt, lfsr_cnt_next;

  wire ctr_expired;

  // no puede ser zero porque si es zero no podria salir del zero

  assign lfsr_cnt_xor[0] = lfsr_cnt[1];

  assign lfsr_cnt_xor[1] = lfsr_cnt[2];

  assign lfsr_cnt_xor[2] = lfsr_cnt[3] ^ lfsr_cnt[0];

  assign lfsr_cnt_xor[3] = lfsr_cnt[0];

  always @(*) begin

    if (new_cntr_preset) lfsr_cnt_next = 4'b1111;
    // esta madre es solo para cortar el ciclo antes 
    // else if (lfsr_cnt == 4'b1100) lfsr_cnt_next = 4'b1111;  
    else
      lfsr_cnt_next = lfsr_cnt_xor;

  end

  always @(posedge clk or negedge resetb) begin

    if (!resetb) lfsr_cnt <= 4'b1111;
    else lfsr_cnt <= lfsr_cnt_next;

  end

  assign ctr_expired = (lfsr_cnt == 4'b0111);

endmodule
