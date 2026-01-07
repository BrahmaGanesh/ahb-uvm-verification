//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_sequence.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : Base UVM sequence for AHB-Lite:
//              - Provides reusable sequence class
//              - Defines empty body for extension               
//=====================================================

class ahb_sequence extends uvm_sequence;
    `uvm_object_utils(ahb_sequence)

    function new (string name = "ahb_sequence");
        super.new(name);
    endfunction

    virtual task body();
    endtask

endclass