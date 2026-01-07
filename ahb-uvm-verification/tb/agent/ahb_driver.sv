//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_driver.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : UVM driver for AHB-Lite:
//              - Handles reset phases (pre, reset, post)
//              - Drives single transfer read/write (HBURST=000)
//              - Uses virtual interface to apply signals
//=====================================================

class ahb_driver extends uvm_driver#(ahb_transaction);
    `uvm_component_utils(ahb_driver)

  	virtual ahb_interface vif;
    ahb_transaction tr;

    function new(string name = "ahb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual ahb_interface)::get(this,"","vif",vif))
          `uvm_fatal(get_type_name(),"virtual interface is not set")
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);

      `uvm_info("PHASE","Start of simmulation...",UVM_LOW)
    endfunction
    
    task pre_reset_phase(uvm_phase phase);
      super.pre_reset_phase(phase);
      `uvm_info("PHASE","Preparing Reset....",UVM_LOW)
    endtask

    task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this,"driver reset");
        vif.HRESET_n <= 0;
        #10;
        vif.HRESET_n <= 1;
        `uvm_info("PHASE","Reset applied....",UVM_LOW)
      phase.drop_objection(this, "driver reset");
    endtask

    task post_reset_phase(uvm_phase phase);
      super.post_reset_phase(phase);
      `uvm_info("PHASE","Reset Completed....",UVM_LOW)
    endtask

    task run_phase(uvm_phase phase);
      forever begin
        wait(vif.HRESET_n);
        seq_item_port.get_next_item(tr);
          case(tr.HBURST)
            3'b000  : begin
                        if(tr.HWRITE)
                          signal_write();
                        else
                          signal_read();
                      end
          endcase
        seq_item_port.item_done();
      end
    endtask


   task signal_write();
    `uvm_info(get_type_name(),"signal_write stated...",UVM_LOW)
    @(posedge vif.HCLK);
    vif.HBURST <= tr.HBURST;
    vif.HREADYin <= 1;
    vif.HADDR  <= tr.HADDR;
    vif.HWRITE <= tr.HWRITE;
    vif.HTRANS <= tr.HTRANS;

    @(posedge vif.HCLK);
    vif.HWDATA <= tr.HWDATA;
    
    @(posedge vif.HCLK);
    vif.HTRANS <= 2'b00;
    `uvm_info(get_type_name(),"signal_write Completed...",UVM_LOW)
  endtask

  task signal_read();
    `uvm_info(get_type_name(),"signal_read stated...",UVM_LOW)
    @(posedge vif.HCLK);
    vif.HBURST <= tr.HBURST;
    vif.HADDR  <= tr.HADDR;
    vif.HWRITE <= 1'b0;
    vif.HTRANS <= 2'b10;

    @(posedge vif.HCLK);
    tr.HRDATA = vif.HRDATA;

    @(posedge vif.HCLK);
    vif.HTRANS <= 2'b00;
    @(posedge vif.HCLK);
    `uvm_info(get_type_name(),"signal_read Completed...",UVM_LOW)
  endtask

endclass