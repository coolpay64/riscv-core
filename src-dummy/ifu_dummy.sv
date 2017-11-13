//==============================
// Dummy IFU generate NOP and 0 PC
//==============================
module ifu_dummy (
  input  logic clk  ,
  input  logic rst_n,
  output logic                   ifu_req_addr_vld , 
  output logic[ADDR_WIDTH-1:0]   ifu_req_addr     , 
  input  logic                   ifu_req_data_vld , 
  input  logic[DATA_WIDTH-1:0]   ifu_req_data     , 
  output logic                   ifu_valid        , 
  output logic[PC_WIDTH-1   : 0] ifu_pc           , 
  output logic[INST_WIDTH-1 : 0] ifu_inst   

);
  always_ff @ (posedge clk or negedge rst_n)begin : dummy_generation
    if(!rst_n)begin
      ifu_valid <= 0;
      ifu_pc    <= 0;
    end else begin
      ifu_valid <= 1;
      ifu_pc    <= ifu_pc+1;
      ifu_inst  <= 'h00000023; // ADDI 0 to r0
    end
  end
 
  //==============================
  // Dummy Memory access
  //==============================
  assign ifu_req_addr     = 0 ; 
  assign ifu_req_addr_vld = 0 ; 
  
  //==============================
  // Disable the Unused signal wraning
  //==============================
  initial begin : warning_killer
    if(0 & &ifu_req_data_vld  );
    if(0 & &ifu_req_data      );
  end


endmodule
