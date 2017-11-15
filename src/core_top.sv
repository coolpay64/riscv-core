import cpu_define::*;
module core_top (
  // Declare some signals so we can see how I/O works
  input  logic clk,
  input  logic rst_n,

  output logic                 ifu_req_addr_vld , 
  output logic[ADDR_WIDTH-1:0] ifu_req_addr     , 
  input  logic                 ifu_rsp_data_vld , 
  input  logic[DATA_WIDTH-1:0] ifu_rsp_data     , 

  output logic                 lsu_req_vld        , 
  output logic[ADDR_WIDTH-1:0] lsu_req_addr       , 
  output logic[DATA_WIDTH-1:0] lsu_req_data       , 
  output logic[DATA_BYTE -1:0] lsu_req_data_strobe,
  input  logic                 lsu_rsp_vld        , 
  input  logic[DATA_WIDTH-1:0] lsu_rsp_data       , 

  output logic                 commit_vld      ,
  output logic[PC_WIDTH  -1:0] commit_pc       ,
  output logic[INST_WIDTH-1:0] commit_inst     ,
  output logic[REG_WIDTH -1:0] commit_rs1      ,
  output logic[REG_WIDTH -1:0] commit_rs2      ,
  output logic[REG_WIDTH -1:0] commit_rd       ,
  output logic                 commit_we        

);

  // IFU Output
  logic                   ifu_vld  ; 
  logic[PC_WIDTH-1   : 0] ifu_pc   ; 
  logic[INST_WIDTH-1 : 0] ifu_inst ; 
 
  // DEC Output
  logic                   dec_vld    ; 
  logic[IMM_WIDTH-1  : 0] dec_imm    ; 
  logic                   dec_req_alu;
  logic                   dec_req_mdu;
  logic                   dec_req_lsu;
  logic                   dec_req_csr;

  // RF Signal
  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rs1_addr ; 
  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rs2_addr ; 
  logic [ REG_WIDTH-1      : 0 ] rf_rs1      ; 
  logic [ REG_WIDTH-1      : 0 ] rf_rs2      ; 
  logic                          rf_rd_we    ; 
  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rd_addr  ; 
  logic [ REG_WIDTH -1     : 0 ] rf_rd       ; 
  logic [ PC_WIDTH-1       : 0 ] rf_pc       ; 

  // ALU Output
  logic                          alu_vld          ; 
  logic                          alu_rd_we        ; 
  logic [ REG_ADDR_WIDTH-1 : 0 ] alu_rd_addr      ; 
  logic [ REG_WIDTH-1      : 0 ] alu_rd           ; 
  logic                          alu_branch       ; 
  logic                          alu_branch_cond  ; 
  logic                          alu_branch_taken ; 
  logic [ PC_WIDTH-1       : 0 ] alu_branch_pc    ; 
    
  assign lsu_req_vld         = 0 ; 
  assign lsu_req_addr        = 0 ; 
  assign lsu_req_data        = 0 ; 
  assign lsu_req_data_strobe = 0 ; 
  assign commit_vld          = 0 ; 
  assign commit_pc           = 0 ; 
  assign commit_inst         = 0 ; 
  assign commit_rs1          = 0 ; 
  assign commit_rs2          = 0 ; 
  assign commit_rd           = 0 ; 
  assign commit_we           = 0 ; 

  assign rf_rs1_addr = ifu_inst[19:15];
  assign rf_rs2_addr = ifu_inst[24:20];
  assign rf_rd_we    = 0; // FIXME: get we from wb stage
  assign rf_rd_addr  = 0; // FIXME: get addr from wb stage
  assign rf_rd       = 0; // FIXME: get data from wb stage

  //==============================
  // Dummy Components
  //==============================
  ctrl_dummy ctrl_dummy(.clk(clk),.rst_n(rst_n));
  ifu_dummy  ifu_dummy (
    .clk(clk),.rst_n(rst_n),
    .ifu_req_addr_vld ( ifu_req_addr_vld   ), 
    .ifu_req_addr     ( ifu_req_addr       ), 
    .ifu_rsp_data_vld ( ifu_rsp_data_vld   ), 
    .ifu_rsp_data     ( ifu_rsp_data       ), 
    .ifu_vld          ( ifu_vld            ), 
    .ifu_pc           ( ifu_pc             ), 
    .ifu_inst         ( ifu_inst           )
  );
  bypass_dummy bypass_dummy(.clk(clk),.rst_n(rst_n));
  dec_dummy  dec_dummy (
    .clk(clk),.rst_n(rst_n),
    .ifu_vld     ( ifu_vld       ), 
    .ifu_inst    ( ifu_inst      ), 
    .dec_vld     ( dec_vld       ), 
    .dec_imm     ( dec_imm       ), 
    .dec_req_alu ( dec_req_alu   ), 
    .dec_req_mdu ( dec_req_mdu   ), 
    .dec_req_lsu ( dec_req_lsu   ), 
    .dec_req_csr ( dec_req_csr   )
  );
  rf_dummy   rf_dummy  (
    .clk(clk),.rst_n(rst_n),
    .rf_rs1_addr(rf_rs1_addr),
    .rf_rs2_addr(rf_rs2_addr),
    .rf_rs1     (rf_rs1     ),
    .rf_rs2     (rf_rs2     ),
    .rf_rd_we   (rf_rd_we   ),
    .rf_rd_addr (rf_rd_addr ),
    .rf_rd      (rf_rd      ),
    .ifu_pc     (ifu_pc     ),
    .rf_pc      (rf_pc      ) 
  );
  alu_dummy  alu_dummy (
    .clk(clk),.rst_n(rst_n),
    .dec_vld    (dec_vld    ),
    .dec_req_alu(dec_req_alu),

    // Data Flow input
    .rf_rs1_addr (0), 
    .rf_rs2_addr (0), 
    .rf_rd_addr  (0), 
    .rf_rs1      (0), 
    .rf_rs2      (0), 
    .rf_pc       (0), 
    .dec_imm     (dec_imm), 

    // OP Code

    // Data Flow Output
    .alu_vld      (alu_vld      ), 
    .alu_rd_we    (alu_rd_we    ), 
    .alu_rd_addr  (alu_rd_addr  ), 
    .alu_rd       (alu_rd       ), 

    // Branching
    .alu_branch         (alu_branch         ), 
    .alu_branch_cond    (alu_branch_cond    ), 
    .alu_branch_taken   (alu_branch_taken   ), 
    .alu_branch_pc      (alu_branch_pc      ) 

  );
  mdu_dummy  mdu_dummy (.clk(clk),.rst_n(rst_n));
  lsu_dummy  lsu_dummy (.clk(clk),.rst_n(rst_n));
  csr_dummy  csr_dummy (.clk(clk),.rst_n(rst_n));
  wb_dummy   wb_dummy  (.clk(clk),.rst_n(rst_n));

  //==============================
  // Disable the Unused signal wraning
  //==============================
  initial begin : warning_killer
    if(0 & &rf_rs1           ); 
    if(0 & &rf_rs2           ); 
    if(0 & &rf_pc            ); 
    if(0 & &dec_vld          ); 
    if(0 & &dec_req_alu      ); 
    if(0 & &dec_req_mdu      ); 
    if(0 & &dec_req_lsu      ); 
    if(0 & &dec_req_csr      ); 
    if(0 & &dec_imm          ); 
    if(0 & &lsu_rsp_vld      ); 
    if(0 & &lsu_rsp_data     ); 
    if(0 & &alu_vld          ); 
    if(0 & &alu_rd_we        ); 
    if(0 & &alu_rd_addr      ); 
    if(0 & &alu_rd           ); 
    if(0 & &alu_branch       ); 
    if(0 & &alu_branch_cond  ); 
    if(0 & &alu_branch_taken ); 
    if(0 & &alu_branch_pc    ); 
  end


  
  initial begin
    $display("[%0t] Model running...\n", $time);
  end
  always@(posedge clk)begin
    if($time > 10000) begin
      $display("[%0t] Model End...\n", $time);
      $finish();
    end
  end

endmodule
