module ariane_regfile_tb;
// time unit and precision
timeunit 1ns;
timeprecision 1ps;

// clocking / timing
parameter NCLKS=10000;
parameter CLK_PHASE_HI=50ns;
parameter CLK_PHASE_LO=50ns;
parameter STIM_APP_DEL=10ns;
parameter RESP_ACQ_DEL=90ns;

// DUT parameters
localparam int unsigned DATA_WIDTH = 32;
localparam int unsigned NR_READ_PORTS = 2;
localparam int unsigned NR_WRITE_PORTS = 2;
localparam bit          ZERO_REG_ZERO=1;
// DUT signals
logic clk;
logic rst_n;

// read port
logic [NR_READ_PORTS-1:0][4:0]             raddr;
logic [NR_READ_PORTS-1:0][DATA_WIDTH-1:0]  rdata_resp, rdata_exp;
// write port
logic [NR_WRITE_PORTS-1:0][4:0]            waddr;
logic [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata;
logic [NR_WRITE_PORTS-1:0]                 we;

task appl_wcycles(int unsigned n);
  repeat(n) @(posedge(clk));
  #(STIM_APP_DEL);
endtask

task acq_wcycles(int unsigned n);
  repeat(n) @(posedge(clk));
  #(RESP_ACQ_DEL);
endtask

ariane_regfile_fpga #(
  .DATA_WIDTH(DATA_WIDTH),
  .NR_READ_PORTS(NR_READ_PORTS),
  .NR_WRITE_PORTS(NR_WRITE_PORTS),
  .ZERO_REG_ZERO(ZERO_REG_ZERO)
) dut_i (
  .clk_i(clk),
  .rst_ni(rst_n),
  .test_en_i(1'b0),
  .raddr_i(raddr),
  .rdata_o(rdata_resp),
  .waddr_i(waddr),
  .wdata_i(wdata),
  .we_i(we)
);

ariane_regfile_ff #(
  .DATA_WIDTH(DATA_WIDTH),
  .NR_READ_PORTS(NR_READ_PORTS),
  .NR_WRITE_PORTS(NR_WRITE_PORTS),
  .ZERO_REG_ZERO(ZERO_REG_ZERO)
) model_i (
  .clk_i(clk),
  .rst_ni(rst_n),
  .test_en_i(1'b0),
  .raddr_i(raddr),
  .rdata_o(rdata_exp),
  .waddr_i(waddr),
  .wdata_i(wdata),
  .we_i(we)
);

logic EndOfSim_S;

always @* begin
  do begin
    clk=1; #(CLK_PHASE_HI);
    clk=0; #(CLK_PHASE_LO);
  end while (EndOfSim_S == 1'b0);
end

class RandWrite;
  rand bit [NR_WRITE_PORTS-1:0][4:0]            waddr;
  rand bit [NR_WRITE_PORTS-1:0]                 we;
  rand bit [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata;
  rand bit [NR_READ_PORTS-1:0][4:0]             raddr;

endclass

RandWrite rand_write;
logic [4:0] i;
bit ok;
bit init_done;

// stimuli application:
initial begin
  raddr = '0;
  waddr = '0;
  wdata = '0;
  we    = '0;
  init_done=1'b0;

  rand_write=new();

  EndOfSim_S = 1'b0;

  rst_n = 1'b0;

  appl_wcycles(20);
  rst_n = 1'b1;
  i=0;

  repeat(32) begin
    appl_wcycles(1);
    $display("Initializing Reg %0d", i);
    waddr = {NR_WRITE_PORTS'(i)};
    we = '1;
    wdata = '0;
    i=i+1;
  end

  appl_wcycles(1);
  init_done=1'b1;

  repeat(NCLKS) begin
    appl_wcycles(1);
    ok=rand_write.randomize();
    assert (ok) else $error("randomization failed");

    waddr = rand_write.waddr;
    we = rand_write.we;
    wdata = rand_write.wdata;
    raddr = rand_write.raddr;
  end
  EndOfSim_S=1'b1;
end

initial begin
  int tstCnt;
  int errCnt;
  while (1) begin
    if(init_done) begin
      do begin
        acq_wcycles(1);
        $display("we: 'b%x, waddr: 'b%x, wdata: 'b%x, raddr: 'b%x", we, waddr, wdata, raddr);
        if (rdata_exp != rdata_resp) begin
          $error("raddr: 'b%x, rdata exp: 'b%x, rdata resp: 'b%x", raddr, rdata_exp, rdata_resp);
        end
      end while (EndOfSim_S == 1'b0);
      break;
    end else begin
      acq_wcycles(1);
    end
  end
end





endmodule
