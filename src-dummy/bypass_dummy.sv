module bypass_dummy (
  input  logic clk,
  input  logic rst_n
);
   //==============================
   // Disable the Unused signal wraning
   //==============================
   initial begin : warning_killer
     if(0 & &rst_n );
     if(0 & &clk   );
   end


endmodule

