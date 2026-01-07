//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_sequencer.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : UVM sequencer for AHB-Lite:
//              - Manages ahb_transaction items
//              - Connects sequences to driver               
//=====================================================

class ahb_sequencer extends uvm_sequencer#(ahb_transaction);
    `uvm_component_utils(ahb_sequencer)

    function new (string name = "ahb_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass