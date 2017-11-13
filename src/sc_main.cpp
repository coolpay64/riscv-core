// -*- SystemC -*-
// DESCRIPTION: Verilator Example: Top level main for invoking SystemC model
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2017 by Wilson Snyder.
//======================================================================

// SystemC global header
#include <systemc.h>

// Include common routines
#include <verilated.h>
#if VM_TRACE
#include <verilated_vcd_sc.h>
#endif

#include <sys/stat.h>  // mkdir

// Include modules
#include "Vcpu_define.h"

int sc_main(int argc, char* argv[]) {
    // This is a more complicated example, please also see the simpler examples/hello_world_c.

    // Prevent unused variable warnings
    if (0 && argc && argv) {}
    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    Verilated::commandArgs(argc, argv);

    // Set debug level, 0 is off, 9 is highest presently used
    Verilated::debug(0);

    // Randomization reset policy
    Verilated::randReset(2);

    // General logfile
    ios::sync_with_stdio();

    // Defaults time
#if (SYSTEMC_VERSION>20011000)
#else
    sc_time dut(1.0, sc_ns);
    sc_set_default_time_unit(dut);
#endif

    // Define clocks
#if (SYSTEMC_VERSION>=20070314)
    sc_clock clk     ("clk",    10,SC_NS, 0.5, 3,SC_NS, true);
#else
    sc_clock clk     ("clk",    10, 0.5, 3, true);
#endif

    // Define interconnect
    
    sc_signal < bool       > rst_n            ; 
    sc_signal < bool       > ifu_req_addr_vld ; 
    sc_signal < vluint64_t > ifu_req_addr     ; 
    sc_signal < bool       > ifu_req_data_vld ; 
    sc_signal < vluint64_t > ifu_req_data     ; 
    sc_signal < vluint64_t > lsu_addr         ; 
    sc_signal < vluint64_t > lsu_data_i       ; 
    sc_signal < vluint64_t > lsu_data_o       ; 
    sc_signal < uint32_t   > lsu_data_strobe  ; 
    sc_signal < bool       > commit_vld       ; 
    sc_signal < vluint64_t > commit_pc        ; 
    sc_signal < uint32_t   > commit_inst      ; 
    sc_signal < vluint64_t > commit_rs1       ; 
    sc_signal < vluint64_t > commit_rs2       ; 
    sc_signal < vluint64_t > commit_rd        ; 
    sc_signal < bool       > commit_we        ; 


    // Construct the Verilated model, from inside Vtop.h
    Vcpu_define* top = new Vcpu_define("top");
    // Attach signals to the model
    top->clk              ( clk              ); 
    top->rst_n            ( rst_n            ); 
    top->ifu_req_addr_vld ( ifu_req_addr_vld ); 
    top->ifu_req_addr     ( ifu_req_addr     ); 
    top->ifu_req_data_vld ( ifu_req_data_vld ); 
    top->ifu_req_data     ( ifu_req_data     ); 
    top->lsu_addr         ( lsu_addr         ); 
    top->lsu_data_i       ( lsu_data_i       ); 
    top->lsu_data_o       ( lsu_data_o       ); 
    top->lsu_data_strobe  ( lsu_data_strobe  ); 
    top->commit_vld       ( commit_vld       ); 
    top->commit_pc        ( commit_pc        ); 
    top->commit_inst      ( commit_inst      ); 
    top->commit_rs1       ( commit_rs1       ); 
    top->commit_rs2       ( commit_rs2       ); 
    top->commit_rd        ( commit_rd        ); 
    top->commit_we        ( commit_we        ); 
    

#if VM_TRACE
    // Before any evaluation, need to know to calculate those signals only used for tracing
    Verilated::traceEverOn(true);
#endif

    // You must do one evaluation before enabling waves, in order to allow
    // SystemC to interconnect everything for testing.
#if (SYSTEMC_VERSION>=20070314)
    sc_start(1,SC_NS);
#else
    sc_start(1);
#endif

    // Turn on waves
#if VM_TRACE
    cout << "Enabling waves into logs/vlt_dump.vcd...\n";
    VerilatedVcdSc* tfp = new VerilatedVcdSc;
    top->trace (tfp, 99);
    mkdir("logs", 0777);
    tfp->open ("logs/vlt_dump.vcd");
#endif

    // Simulate until $finish
    while (!Verilated::gotFinish()) {
#if VM_TRACE
        // Flush the wave files each cycle so we can immediately see the output
        // Don't do this in "real" programs, do it in an abort() handler instead
        if (tfp) tfp->flush();
        // Apply inputs
        if (VL_TIME_Q() > 1 && VL_TIME_Q() < 10) {
            rst_n   = !1;       // Assert reset
        } else if (VL_TIME_Q() > 1) {
            rst_n   = !0;       // Deassert reset
        }
#endif
        // Simulate 1ns
#if (SYSTEMC_VERSION>=20070314)
        sc_start(1,SC_NS);
#else
        sc_start(1);
#endif
    }

    //  Close Waves
#if VM_TRACE
    if (tfp) tfp->close();
#endif

    // Final model cleanup
    top->final();

    //  Coverage analysis (since test passed)
#if VM_COVERAGE
    mkdir("logs", 0777);
    VerilatedCov::write("logs/coverage.dat");
#endif

    // Fin
    return 0;
}
