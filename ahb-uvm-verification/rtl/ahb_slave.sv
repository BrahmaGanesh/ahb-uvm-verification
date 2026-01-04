//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_slave.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 05-01-2026
// Version     : 1.0
// Description : AHB-Lite slave with memory-mapped read/write,
//               supporting HREADY/HRESP handshake and pipelining.
//=====================================================

module ahb_slave(
    input   logic HCLK,
    input   logic HRESET_n,
    input   logic [1:0] HTRANS,
    input   logic [2:0] HBURST,
    input   logic [2:0] HSIZE,
    input   logic       HWRITE,
    input   logic [31:0] HADDR,
    input   logic [31:0] HWDATA,
    input   logic        HREADYin,
    output  logic [31:0] HRDATA,
    output  logic [1:0]  HRESP,
    output  logic        HREADYout
);
  logic [31:0] mem [0:512];

    logic [31:0] addr_reg;
  logic  [31:0] wdata_reg;
    logic        write_reg;
    logic        vaild_reg;
    
    always @(posedge HCLK or negedge HRESET_n) begin
        if(!HRESET_n)begin
            foreach(mem[i]) mem[i] <= '0;
            HRDATA      <= '0;
            HREADYout   <= 1'b0;
            HRESP       <= 2'b00;
            vaild_reg   <= 1'b0;
        end
        else begin
            HREADYout   <= 1'b1;
            HRESP       <= 2'b00;
          
            if(HTRANS[1] && HREADYin) begin
                addr_reg    <= HADDR;
                write_reg   <= HWRITE;
                        	wdata_reg <= HWDATA;
                vaild_reg   <= 1'b1;
            end
            if(vaild_reg) begin
                if(write_reg) begin
                  mem[addr_reg[11:2]] <= wdata_reg;
                end
                else begin
                  HRDATA <= mem[addr_reg[11:2]];
                end
            end
        end
    end
endmodule