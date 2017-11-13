import cpu_define::*;
module core_top (
  // Declare some signals so we can see how I/O works
  input  logic clk,
  input  logic rst_n,

  output logic                 ifu_req_addr_vld , 
  output logic[ADDR_WIDTH-1:0] ifu_req_addr     , 
  input  logic                 ifu_req_data_vld , 
  input  logic[DATA_WIDTH-1:0] ifu_req_data     , 

  output logic[ADDR_WIDTH-1:0] lsu_addr        , 
  input  logic[DATA_WIDTH-1:0] lsu_data_i      , 
  output logic[DATA_WIDTH-1:0] lsu_data_o      , 
  output logic[DATA_BYTE -1:0] lsu_data_strobe ,

  output logic                 commit_vld      ,
  output logic[PC_WIDTH  -1:0] commit_pc       ,
  output logic[INST_WIDTH-1:0] commit_inst     ,
  output logic[REG_WIDTH -1:0] commit_rs1      ,
  output logic[REG_WIDTH -1:0] commit_rs2      ,
  output logic[REG_WIDTH -1:0] commit_rd       ,
  output logic                 commit_we        

);

  logic                   ifu_valid; 
  logic[PC_WIDTH-1   : 0] ifu_pc   ; 
  logic[INST_WIDTH-1 : 0] ifu_inst ; 

  assign lsu_addr        = 0 ; 
  assign lsu_data_o      = 0 ; 
  assign lsu_data_strobe = 0 ;
  assign commit_vld      = 0 ;
  assign commit_pc       = 0 ;
  assign commit_inst     = 0 ;
  assign commit_rs1      = 0 ;
  assign commit_rs2      = 0 ;
  assign commit_rd       = 0 ;
  assign commit_we       = 0 ;


  //==============================
  // Dummy Components
  //==============================
  ctrl_dummy ctrl_dummy(.clk(clk),.rst_n(rst_n));
  ifu_dummy  ifu_dummy (
    .clk(clk),.rst_n(rst_n),
    .ifu_req_addr_vld (ifu_req_addr_vld ), 
    .ifu_req_addr     (ifu_req_addr     ), 
    .ifu_req_data_vld (ifu_req_data_vld ), 
    .ifu_req_data     (ifu_req_data     ), 
    .ifu_valid        (ifu_valid        ), 
    .ifu_pc           (ifu_pc           ), 
    .ifu_inst         (ifu_inst         )
  );
  rf_dummy   rf_dummy  (.clk(clk),.rst_n(rst_n));
  dec_dummy  dec_dummy (.clk(clk),.rst_n(rst_n));
  alu_dummy  alu_dummy (.clk(clk),.rst_n(rst_n));
  mdu_dummy  mdu_dummy (.clk(clk),.rst_n(rst_n));
  lsu_dummy  lsu_dummy (.clk(clk),.rst_n(rst_n));
  csr_dummy  csr_dummy (.clk(clk),.rst_n(rst_n));
  wb_dummy   wb_dummy  (.clk(clk),.rst_n(rst_n));

  //==============================
  // Disable the Unused signal wraning
  //==============================
  initial begin : warning_killer
    if(0 & &lsu_data_i);
    if(0 & &ifu_valid ); 
    if(0 & &ifu_pc    ); 
    if(0 & &ifu_inst  ); 
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
