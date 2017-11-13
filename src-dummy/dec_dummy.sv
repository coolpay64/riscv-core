module dec_dummy(
  input  logic clk,
  input  logic rst_n,
  input  logic                   ifu_vld  , 
  input  logic[INST_WIDTH-1 : 0] ifu_inst , 
  output logic                   dec_vld  , 
  output logic[IMM_WIDTH-1  : 0] dec_imm  ,
  output logic                   dec_req_alu,
  output logic                   dec_req_mdu,
  output logic                   dec_req_lsu,
  output logic                   dec_req_csr 
);
  logic imm_type_i;
  logic imm_type_s;
  logic imm_type_b;
  logic imm_type_u;
  logic imm_type_j;
  
  logic [IMM_WIDTH-1:0] imm_i;
  logic [IMM_WIDTH-1:0] imm_s;
  logic [IMM_WIDTH-1:0] imm_b;
  logic [IMM_WIDTH-1:0] imm_u;
  logic [IMM_WIDTH-1:0] imm_j;

  //==============================
  // Decoding Functional Unit request
  //==============================
  // Dummy Output
  always_comb dec_req_alu = 1'b1 ; 
  always_comb dec_req_mdu = 1'b0 ; 
  always_comb dec_req_lsu = 1'b0 ; 
  always_comb dec_req_csr = 1'b0 ; 


  //==============================
  // Decoding Immediate Value from Inst
  //==============================
  // Dummy Imm value decode
  always_comb imm_i = ifu_inst;
  always_comb imm_s = ifu_inst;
  always_comb imm_b = ifu_inst;
  always_comb imm_u = ifu_inst;
  always_comb imm_j = ifu_inst;
  
  // Dummy Imm type decode
  always_comb  imm_type_i = 1'b1;
  always_comb  imm_type_s = 1'b0;
  always_comb  imm_type_b = 1'b0;
  always_comb  imm_type_u = 1'b0;
  always_comb  imm_type_j = 1'b0;

  always_ff @ (posedge clk)begin : imm_decode_output
    if(ifu_vld)begin
      dec_imm <=
        (imm_type_i ? imm_i : {IMM_WIDTH{1'h0}}) |
        (imm_type_s ? imm_s : {IMM_WIDTH{1'h0}}) |
        (imm_type_b ? imm_b : {IMM_WIDTH{1'h0}}) |
        (imm_type_u ? imm_u : {IMM_WIDTH{1'h0}}) |
        (imm_type_j ? imm_j : {IMM_WIDTH{1'h0}}) ;
    end
  end

  //==============================
  // Dummy Status pipeline
  //==============================
  always_ff @ (posedge clk or negedge rst_n)begin : status_pipe
    if(!rst_n)begin
      dec_vld <= 0;
    end else begin
      dec_vld <= ifu_vld;
    end
  end


  //==============================
  // Assertions
  //==============================
  // 1. Only request one unit
  always_ff @ (posedge clk or negedge rst_n)begin
    assert_one_unit: assert (!rst_n || $onehot({dec_req_alu, dec_req_mdu, dec_req_lsu, dec_req_csr})); 
  end

endmodule
