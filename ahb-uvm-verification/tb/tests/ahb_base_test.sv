//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_base_test.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : Base UVM test for AHB-Lite:
//              - Instantiates ahb_env
//              - Provides foundation for derived test cases               
//=====================================================

class ahb_base_test extends uvm_test;
    `uvm_component_utils(ahb_base_test)

    ahb_env env;

    function new (string name = "ahb_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = ahb_env::type_id::create("env", this);
    endfunction

endclass