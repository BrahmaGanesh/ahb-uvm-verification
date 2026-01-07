//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_env.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : UVM environment for AHB-Lite:
//              - Instantiates agent and scoreboard
//              - Connects monitor analysis port to scoreboard
//=====================================================

class ahb_env extends uvm_env;
    `uvm_component_utils(ahb_env)

    ahb_agent       m_agent;
    ahb_scoreboard  soc;

    function new (string name = "ahb_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_agent     = ahb_agent::type_id::create("m_agent", this);
        soc         = ahb_scoreboard::type_id::create("soc", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        m_agent.mon.mon_ap.connect(soc.soc_export);
    endfunction

endclass