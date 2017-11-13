package cpu_define;
  localparam int ADDR_WIDTH = 39           ; 
  localparam int DATA_WIDTH = 64           ; 
  localparam int DATA_BYTE  = DATA_WIDTH/8 ; 
  localparam int PC_WIDTH   = 39           ; 
  localparam int INST_WIDTH = 32           ; 
  localparam int REG_WIDTH  = DATA_WIDTH   ; 
  localparam int IMM_WIDTH  = 32           ; 
endpackage
