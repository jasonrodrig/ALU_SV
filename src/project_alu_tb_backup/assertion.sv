module alu_assertion(clk,rst,ce,opa,opb,mode,inp_valid,cmd,cin,res);
	input clk;
	input rst;
	input ce;
	input [`DATA_WIDTH - 1 : 0] opa;
	input [`DATA_WIDTH - 1 : 0]opb;
	input mode;
	input [1:0] inp_valid;
	input [`CMD_WIDTH - 1 : 0]cmd;
	input cin;
	input [ ( 2 * `DATA_WIDTH ) - 1 : 0]res;
	ALU_reset: assert property (@(posedge clk) ##4000 !rst) 
	$info("RESET IS NOT TRIGERRED");
	else $info("RESET IS  TRIGGERED");

	property ALU_unknown;
		@(posedge clk) ##1!($isunknown({rst,ce,opa,opb,mode,inp_valid,cmd,cin}));
	endproperty

	ALU_UNKNOWN: assert property(ALU_unknown) begin
		$info("INPUTS ARE KNOWN");
	end
	else $info("INPUTS ARE UNKNOWN");

	property ALU_Latch;
		@(posedge clk) !ce |=> ($stable(res));
	endproperty
	ALU_LATCH: assert property(ALU_Latch) begin
		$info("OUTPUTS NOT CHANGED");
	end
	else $info("OUTPUT CHANGED");

endmodule
