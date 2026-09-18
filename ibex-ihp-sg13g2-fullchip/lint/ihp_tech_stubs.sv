// Lint-only declarations for IHP technology cells.
// prepare_rtl.py explicitly excludes this file from build/rtl.
`default_nettype none
module sg13g2_IOPadIn(output logic p2c, inout wire pad);
  assign p2c = pad;
endmodule
module sg13g2_IOPadOut30mA(input logic c2p, inout wire pad);
  assign pad = c2p;
endmodule
module sg13g2_IOPadIOVdd(); endmodule
module sg13g2_IOPadIOVss(); endmodule
module sg13g2_IOPadVdd(); endmodule
module sg13g2_IOPadVss(); endmodule

module RM_IHPSG13_1P_1024x32_c2_bm_bist(
  input logic A_CLK,A_MEN,A_WEN,A_REN,
  input logic [9:0] A_ADDR,
  input logic [31:0] A_DIN,
  input logic A_DLY,
  output logic [31:0] A_DOUT,
  input logic [31:0] A_BM,
  input logic A_BIST_CLK,A_BIST_EN,A_BIST_MEN,A_BIST_WEN,A_BIST_REN,
  input logic [9:0] A_BIST_ADDR,
  input logic [31:0] A_BIST_DIN,A_BIST_BM
);
  logic [31:0] mem [0:1023];
  always_ff @(posedge A_CLK) begin
    if (A_MEN && A_WEN)
      mem[A_ADDR] <= (mem[A_ADDR] & ~A_BM) | (A_DIN & A_BM);
    if (A_MEN && A_REN) A_DOUT <= mem[A_ADDR];
  end
endmodule
`default_nettype wire
