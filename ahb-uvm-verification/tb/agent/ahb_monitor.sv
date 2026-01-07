 //=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_monitor.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.0
// Description : UVM monitor for AHB-Lite:
//              - Observes bus activity after reset
//              - Captures single transfer read/write (HBURST=000)
//              - Publishes transactions via analysis port               
//=====================================================

 class ahb_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_monitor)

    virtual ahb_interface vif;
    ahb_transaction tr;

    uvm_analysis_port#(ahb_transaction) mon_ap;

    function new (string name = "ahb_monitor", uvm_component parent = null);
        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual ahb_interface)::get(this,"","vif",vif))
          `uvm_fatal(get_type_name(),"virtual interface is not set")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            wait(vif.HRESET_n);
            @(posedge vif.HCLK);

            case(vif.HBURST)
                3'b000 :    begin
                                if(vif.HWRITE)
                                    signal_write();
                                else
                                    signal_read();
                            end
            endcase
        end
    endtask

    task signal_write();
        `uvm_info(get_type_name(),"signal_write stated...",UVM_LOW)
        if (vif.HTRANS[1] && vif.HREADYin) begin
            tr = ahb_transaction::type_id::create("tr");
            tr.HADDR  = vif.HADDR;
            tr.HWRITE = vif.HWRITE;
            if (vif.HWRITE)
                tr.HWDATA = vif.HWDATA;
           `uvm_info("MON","write..",UVM_LOW)
           	mon_ap.write(tr);
            end
        `uvm_info(get_type_name(),"signal_write Completed...",UVM_LOW)
    endtask

    task signal_read();
        `uvm_info(get_type_name(),"signal_read stated...",UVM_LOW)
         if (vif.HTRANS[1] && vif.HREADYin) begin
            tr = ahb_transaction::type_id::create("tr");
            tr.HADDR  = vif.HADDR;
            tr.HWRITE = vif.HWRITE;
        
        if(vif.HREADYout && vif.HTRANS == 2'b00)begin
            if(!vif.HWRITE)begin
                tr.HRDATA = vif.HRDATA;
                tr.HRESP = vif.HRESP;
            end
          mon_ap.write(tr);
        end
         end
         `uvm_info(get_type_name(),"signal_read Completed...",UVM_LOW)
    endtask

endclass 