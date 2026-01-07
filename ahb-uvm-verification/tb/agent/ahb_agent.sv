//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_agent.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : UVM agent for AHB-Lite:
//              - Instantiates driver, monitor, and sequencer
//              - Connects sequencer to driver when active               
//=====================================================

class ahb_agent extends uvm_agent;
    `uvm_component_utils(ahb_agent)

    ahb_driver      drv;
    ahb_monitor     mon;
    ahb_sequencer   seqr;

    uvm_active_passive_enum IS_ACTIVE = UVM_ACTIVE;

    function new (string name = "ahb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        drv     = ahb_driver::type_id::create("drv", this);
        mon     = ahb_monitor::type_id::create("mon", this);
        seqr    = ahb_sequencer::type_id::create("seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        if(IS_ACTIVE == UVM_ACTIVE)
            drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
