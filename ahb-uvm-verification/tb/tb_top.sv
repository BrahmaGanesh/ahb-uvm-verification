//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : tb_top.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : Top-level testbench for AHB UVM verification:
//              - Instantiates AHB interface and DUT (ahb_slave)
//              - Generates clock and reset
//              - Dumps waveform (VCD)
//              - Configures virtual interface and starts UVM test
//=====================================================

`include "ahb_interface.sv"
`include "ahb_package.sv"
module tb;
  	import ahb_pkg::*;
  ahb_interface vif();

    ahb_slave dut (
        .HCLK(vif.HCLK),
        .HRESET_n(vif.HRESET_n),
        .HTRANS(vif.HTRANS),
        .HSIZE(vif.HSIZE),
        .HBURST(vif.HBURST),
        .HADDR(vif.HADDR),
        .HWRITE(vif.HWRITE),
        .HWDATA(vif.HWDATA),
        .HREADYin(vif.HREADYin),
        .HRDATA(vif.HRDATA),
        .HRESP(vif.HRESP),
      .HREADYout(vif.HREADYout)
    );
    initial begin
    vif.HCLK = 0;
    vif.HRESET_n = 0;
    #10 vif.HRESET_n = 1;
    end
    always #5 vif.HCLK =~ vif.HCLK;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,tb);
    end

    initial begin
      uvm_config_db#(virtual ahb_interface)::set(null,"*","vif",vif);
      run_test();
    end
endmodule