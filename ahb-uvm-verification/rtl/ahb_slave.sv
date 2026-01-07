//=====================================================
// Project     : AHB_UVM_VERFICATION
// File        : ahb_slave.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 07-01-2026
// Version     : 1.1
// Description : AHB-Lite slave with memory-mapped read/write:
//              - Supports HREADY/HRESP handshake and pipelining
//              - Implements single, INCR, INCR4, INCR8, WRAP4, WRAP8 burst types
//              - Includes wrap base and next address calculation for burst progression
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
    logic [3:0] beat_cnt;
    logic        write_reg;
    logic        vaild_reg;
    logic       burst_active;

    function automatic bit is_wrap(input logic [2:0] hb);
      return (hb == 3'b010) || (hb == 3'b100);
    endfunction

    function automatic int burst_len(input logic [2:0] hb);
      case(hb)
        3'b000  : return 1;
        3'b001  : return 0;
        3'b010  : return 4;
        3'b011  : return 4;
        3'b100  : return 8;
        3'b101  : return 8;
        default : return 1;
      endcase
    endfunction

    function automatic logic [31:0] transfer_size (input logic [2:0] hs);
      return 32'(1) << hs;
    endfunction

    function automatic logic [31:0] boundary(input logic [2:0] hb, input logic [2:0] hs);
      return ((burst_len(hb) == 0) ? 32'(0) : burst_len(hb) * transfer_size(hs) );
    endfunction

    function automatic logic [31:0] wrap_base(input logic [31:0] addr,input logic [2:0] hb, input logic [2:0] hs);
      logic [31:0] blen = boundary(hb,hs); 
      return (is_wrap(hb) ? (addr & ~(blen - 1)) : 32'(0));
    endfunction

    function automatic logic [31:0] next_addr(input logic [31:0] addr,input logic [2:0] hb, input logic [2:0] hs);
      logic [31:0] bnd = boundary(hb,hs);
      logic [31:0] size = transfer_size(hs);
      logic [31:0] base = wrap_base(addr,hb,hs);

      if(hb == 3'b000) begin
        return addr;
      end else if(!is_wrap(hb)) begin
        return addr + size;
      end
      return base +( ((addr + size) - base) % bnd);

    endfunction

    always @(posedge HCLK)begin
      if(vaild_reg && HWRITE)begin
        vaild_reg <= 1'b0;
        mem[addr_reg[11:2]] <= wdata_reg;
      end
    end
    
    always @(posedge HCLK)begin
      if(vaild_reg && HWRITE)begin
        vaild_reg <= 1'b0;
        HRDATA <= mem[addr_reg[11:2]];
      end
    end
    
    always @(posedge HCLK or negedge HRESET_n) begin
        if(!HRESET_n)begin
            foreach(mem[i]) mem[i] <= '0;
            HRDATA      <= '0;
            HREADYout   <= 1'b0;
            HRESP       <= 2'b00;
            beat_cnt     <= '0;
            vaild_reg   <= 1'b0;
            burst_active <= 1'b0;
        end
        else begin
            HREADYout   <= vaild_reg;
            HRESP       <= 2'b00;
          
            if(HTRANS == 2'b10 && HREADYin) begin
                addr_reg    <= HADDR;
                write_reg   <= HWRITE;
                wdata_reg <= HWDATA;
                burst_active <= (HBURST != 3'b000);
                beat_cnt     <= '0;
                vaild_reg   <= 1'b1;
            end else if(HTRANS == 2'b11 && burst_active && HREADYin) begin
                addr_reg <= next_addr(addr_reg,HBURST,HSIZE);
                beat_cnt++;
                wdata_reg <= HWDATA;
                vaild_reg <= 1;
            end

            if(burst_active && burst_len(HBURST) != 0 && beat_cnt == burst_len(HBURST) - 1) begin
                burst_active <= 1'b0;
            end 
        end
    end
endmodule