//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_if.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : AHB-Lite interface definition:
//              - Declares clock, reset, and protocol signals
//              - Supports address, data, burst, transfer, and handshake
//=====================================================

interface ahb_interface;
    logic           HCLK;
    logic           HRESET_n;
    logic   [1:0]   HTRANS; 
    logic   [2:0]   HBURST; 
    logic   [2:0]   HSIZE; 
    logic   [31:0]  HADDR;
    logic           HWRITE;
    logic   [31:0]  HWDATA;
    logic   [31:0]  HRDATA;
    logic           HREADYin;
    logic           HREADYout;
    logic   [1:0]   HRESP; 
endinterface