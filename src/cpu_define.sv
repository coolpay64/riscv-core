package cpu_define; 
localparam ADDR_WIDTH     = 39           ; 
localparam DATA_WIDTH     = 64           ; 
localparam DATA_BYTE      = DATA_WIDTH/8 ; 
localparam PC_WIDTH       = 39           ; 
localparam INST_WIDTH     = 32           ; 
localparam REG_WIDTH      = DATA_WIDTH   ; 
localparam REG_NUM        = 32           ; 
localparam REG_ADDR_WIDTH = 5            ; 
localparam IMM_WIDTH      = 32           ; 
endpackage
