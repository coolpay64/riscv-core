//==============================
// This module process RF write asynchronously.
// Unless a 2 stage WB mechanism is designed, 
// RF write interface should not be floped.
//==============================
module wb_dummy(
  input  logic clk,
  input  logic rst_n,
 
  // ALU Input
  input  logic                          alu_vld      , 
  input  logic                          alu_rd_we    , 
  input  logic [ REG_ADDR_WIDTH-1 : 0 ] alu_rd_addr  , 
  input  logic [ REG_WIDTH-1      : 0 ] alu_rd       , 

  // Write Interface
  output logic                          rf_rd_we    , 
  output logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rd_addr  , 
  output logic [ REG_WIDTH -1     : 0 ] rf_rd         
);
  logic                          gated_alu_rd_we    ; 
  logic [ REG_ADDR_WIDTH-1 : 0 ] gated_alu_rd_addr  ; 
  logic [ REG_WIDTH-1      : 0 ] gated_alu_rd       ; 

  always_comb begin : datapath_gating
    gated_alu_rd_we   = alu_vld & alu_rd_we ; 
    gated_alu_rd_addr = gated_alu_rd_we ? alu_rd_addr : 0 ; 
    gated_alu_rd      = gated_alu_rd_we ? alu_rd      : 0 ; 
  end
  always_comb begin : datapath_reduction
    rf_rd_we   = gated_alu_rd_we   ;
    rf_rd_addr = gated_alu_rd_addr ;
    rf_rd      = gated_alu_rd      ;
  end

  //==============================
  // Disable the Unused signal wraning
  //==============================
  initial begin : warning_killer
    if(0 & &rst_n );
    if(0 & &clk   );
  end


endmodule
