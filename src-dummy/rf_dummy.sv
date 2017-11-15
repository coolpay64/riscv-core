module rf_dummy (
  input  logic clk,
  input  logic rst_n,

  // Read Interface
  input  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rs1_addr , 
  input  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rs2_addr , 
  output logic [ REG_WIDTH-1      : 0 ] rf_rs1      , 
  output logic [ REG_WIDTH-1      : 0 ] rf_rs2      , 
  
  // Write Interface
  input  logic                          rf_rd_we    , 
  input  logic [ REG_ADDR_WIDTH-1 : 0 ] rf_rd_addr  , 
  input  logic [ REG_WIDTH -1     : 0 ] rf_rd       , 

  // PC Interface
  input  logic [ PC_WIDTH-1       : 0 ] ifu_pc      , 
  output logic [ PC_WIDTH-1       : 0 ] rf_pc         


);

  logic [ REG_WIDTH-1:0] reg_file [1:REG_NUM-1];
  
  always_ff @ (posedge clk )begin : reg_file_read 
    rf_rs1 <= rf_rs1_addr != 0 ? reg_file[rf_rs1_addr] : 0 ;
    rf_rs2 <= rf_rs2_addr != 0 ? reg_file[rf_rs2_addr] : 0 ;
  end

  always_ff @ (posedge clk )begin : reg_file_write
    if(rf_rd_we && rf_rd_addr != 0)begin
      reg_file[rf_rd_addr] <= rf_rd;
    end
  end

  always_ff @ (posedge clk )begin : status_pipe
    rf_pc <= ifu_pc;
  end

  //==============================
  // Disable the Unused signal wraning
  //==============================
  initial begin : warning_killer
    if(0 & &rst_n );
  end

endmodule
