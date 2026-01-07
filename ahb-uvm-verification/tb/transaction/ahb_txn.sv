//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_transaction.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : UVM sequence item for AHB-Lite:
//              - Defines transaction fields (address, data, control, handshake)
//              - Supports randomization and field automation               
//=====================================================

class ahb_transaction extends uvm_sequence_item;
    
    rand bit [1:0] HTRANS;
    rand bit [2:0] HBURST;
    rand bit [2:0] HSIZE;
    rand bit [31:0] HADDR;
    rand bit [31:0] HWDATA;
    rand bit        HWRITE;
         bit [31:0] HRDATA;
         bit        HREADYin;
         bit        HREADYout;
         bit [1:0]  HRESP;
    
    `uvm_object_utils_begin(ahb_transaction)
        `uvm_field_int(HTRANS, UVM_ALL_ON)
        `uvm_field_int(HBURST, UVM_ALL_ON)
        `uvm_field_int(HSIZE, UVM_ALL_ON)
        `uvm_field_int(HADDR, UVM_ALL_ON)
        `uvm_field_int(HWDATA, UVM_ALL_ON)
        `uvm_field_int(HWRITE, UVM_ALL_ON)
        `uvm_field_int(HRDATA, UVM_ALL_ON)
        `uvm_field_int(HREADYin, UVM_ALL_ON)
        `uvm_field_int(HREADYout, UVM_ALL_ON)
        `uvm_field_int(HRESP, UVM_ALL_ON) 
    `uvm_object_utils_end

    function new (string name = "ahb_transaction");
        super.new(name);
    endfunction

endclass