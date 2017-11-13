module alu_dummy (
  input  logic clk,
  input  logic rst_n,
  input  logic dec_vld    ,
  input  logic dec_req_alu,

  //==============================
  // Data Flow input
  //==============================
  input  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rs1_addr , 
  input  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rs2_addr , 
  input  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rd_addr  , 
  input  logic [ REG_WIDTH-1      : 0 ] rf_rs1      , 
  input  logic [ REG_WIDTH-1      : 0 ] rf_rs2      , 
  input  logic [ PC_WIDTH-1       : 0 ] rf_pc       , 
  input  logic [ IMM_WIDTH-1      : 0 ] dec_imm     , 

  //==============================
  // OP Code
  //==============================
    
  //==============================
  // Data Flow Output
  //==============================
  output logic                          alu_vld      , 
  output logic                          alu_rd_we    , 
  output logic [ REG_ADDR_WIDTH-1 : 0 ] alu_rd_addr  , 
  output logic [ REG_WIDTH-1      : 0 ] alu_rd       , 

  //==============================
  // Branching
  //==============================
  output logic                          alu_branch         , 
  output logic                          alu_branch_cond    , 
  output logic                          alu_branch_taken   , 
  output logic [ PC_WIDTH-1       : 0 ] alu_branch_pc       


);

  //==============================
  // Dummy Status pipeline
  //==============================
  always_ff @ (posedge clk or negedge rst_n)begin : status_pipe
    if(!rst_n)begin
      alu_vld <= 0 ;
    end else begin
      alu_vld <= (dec_vld & dec_req_alu);
    end
  end

  //==============================
  // Disable the Unused signal wraning
  //==============================
  initial begin : warning_killer
    if(0 & &rf_rs1_addr);
    if(0 & &rf_rs2_addr);
    if(0 & &rf_rd_addr );
    if(0 & &rf_rs1     );
    if(0 & &rf_rs2     );
    if(0 & &rf_pc      );
    if(0 & &dec_imm    );
  end
  //==============================
  // Dummy output
  //==============================
  assign alu_rd_we        = 0 ; 
  assign alu_rd_addr      = 0 ; 
  assign alu_rd           = 0 ; 
  assign alu_branch       = 0 ; 
  assign alu_branch_cond  = 0 ; 
  assign alu_branch_taken = 0 ; 
  assign alu_branch_pc    = 0 ;


endmodule
