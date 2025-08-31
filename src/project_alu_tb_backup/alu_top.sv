`include "defines.sv"
`include "assertion.sv"
`include "alu_test.sv"
`include "alu_interface.sv"
`include "alu_design.v"
module alu_top;

	bit clk;

  initial begin
	  clk = 0;
	  forever #5 clk = ~clk;
   end

	alu_interface vif(clk);
	  
	ALU_DESIGN duv ( .CLK(vif.clk), .RST(vif.rst), .CE(vif.ce), .INP_VALID(vif.inp_valid), .MODE(vif.mode), 
		        .CMD(vif.cmd), .OPA(vif.opa), .OPB(vif.opb), .CIN(vif.cin), .RES(vif.res), 
		        .OFLOW(vif.oflow), .COUT(vif.cout), .G(vif.g), .E(vif.e), .L(vif.l), .ERR(vif.err) 
	        );
  
	alu_test tb = new( vif.driv , vif.mon , vif.reference);
	alu_assertion assertion(.clk(clk),.rst(vif.rst),.ce(vif.ce),.opa(vif.opa),.opb(vif.opb),.mode(vif.mode),.inp_valid                      (vif.inp_valid),.cmd(vif.cmd),.cin(vif.cin),.res(vif.res));

  rst_ce00_test t0                  = new(vif.driv,vif.mon,vif.reference);
  rst_ce10_test t1                  = new(vif.driv,vif.mon,vif.reference);
  rst_ce11_test t2                  = new(vif.driv,vif.mon,vif.reference);
  logical_single_operand_test t3    = new(vif.driv,vif.mon,vif.reference);
  arithmatic_single_operand_test t4 = new(vif.driv,vif.mon,vif.reference);
  logical_two_operand_test t5       = new(vif.driv,vif.mon,vif.reference);
  arithmatic_two_operand_test t6    = new(vif.driv,vif.mon,vif.reference);
  cycle_16_logical_test t7          = new(vif.driv,vif.mon,vif.reference);
  cycle_16_arithmatic_test t8       = new(vif.driv,vif.mon,vif.reference);
  test_regression rt                = new(vif.driv,vif.mon,vif.reference);

  initial begin
		rt.run();
		$finish;
	end
endmodule
