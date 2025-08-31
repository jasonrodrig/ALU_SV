class alu_monitor;

	alu_transaction monitor_trans;
	mailbox #(alu_transaction) mon2scb;
	virtual alu_interface.mon_cb vif;

	covergroup output_coverage;
		RESULT:         coverpoint monitor_trans.res { bins opb = {[0:255]} with (item / 32 ); }
		OFLOW:        coverpoint monitor_trans.oflow     { bins oflow[] = { 0 , 1 }; }
		COUT:         coverpoint monitor_trans.cout      { bins cout[]  = { 0 , 1 }; }
		GREATER:      coverpoint monitor_trans.g         { bins g[]     = { 0 , 1 }; }
		LESSER:       coverpoint monitor_trans.l         { bins l[]     = { 0 , 1 }; }
		EQUAL:        coverpoint monitor_trans.e         { bins e[]     = { 0 , 1 }; }
		ERROR:        coverpoint monitor_trans.err       { bins err[]   = { 0 , 1 }; }
	endgroup


	function new(
		mailbox #(alu_transaction) mon2scb,
		virtual alu_interface.mon_cb vif
	);
		this.mon2scb = mon2scb;
		this.vif     = vif;
		output_coverage = new();
	endfunction

	task start();
		for( int i = 0; i < `no_of_transaction; i++)
		begin
			monitor_trans = new();
			repeat(3)@(vif.mon_cb);
			if( vif.mon_cb.mode == 1 && ( ( vif.mon_cb.cmd == 9 ) || ( vif.mon_cb.cmd == 10 ) ) ) 
			begin
				repeat(1)@(vif.mon_cb);
			end
			monitor_trans.rst       = vif.mon_cb.rst;
			monitor_trans.ce        = vif.mon_cb.ce;
			monitor_trans.opa       = vif.mon_cb.opa;
			monitor_trans.opb       = vif.mon_cb.opb;
			monitor_trans.cin       = vif.mon_cb.cin;
			monitor_trans.mode      = vif.mon_cb.mode;
			monitor_trans.cmd       = vif.mon_cb.cmd;
			monitor_trans.inp_valid = vif.mon_cb.inp_valid;
			monitor_trans.res       = vif.mon_cb.res;
			monitor_trans.oflow     = vif.mon_cb.oflow;
			monitor_trans.cout      = vif.mon_cb.cout;
			monitor_trans.g         = vif.mon_cb.g;
			monitor_trans.l         = vif.mon_cb.l;
			monitor_trans.e         = vif.mon_cb.e;
			monitor_trans.err       = vif.mon_cb.err;
			mon2scb.put(monitor_trans);
			output_coverage.sample();
			monitor_trans.display("MONITOR SIGNALS");
		end
	endtask
endclass

