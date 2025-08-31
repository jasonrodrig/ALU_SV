
//`include "defines.sv"
//`include "alu_transaction.sv"
class alu_driver;

	alu_transaction driver_trans ;
	mailbox #(alu_transaction) gen2driv;
	mailbox #(alu_transaction) driv2ref;
	virtual alu_interface.driv vif;

	covergroup input_coverage;
		RESET:          coverpoint driver_trans.rst       { bins rst[]       = { 0 , 1 }; }
		CE:             coverpoint driver_trans.ce        { bins ce[]        = { 0 , 1 }; }
		MODE:           coverpoint driver_trans.mode      { bins mode[]      = { 0 , 1 }; }
		INP_VALID:      coverpoint driver_trans.inp_valid { bins inp_valid[] = { 0 , 1 , 2 , 3 }; }
		CARRY_IN:       coverpoint driver_trans.cin       { bins cin[]       = { 0 , 1 }; }
		COMMAND:        coverpoint driver_trans.cmd       { 
      bins arith_cmd[] = {[0:10]} iff(driver_trans.mode == 1);
			bins logic_cmd[] = {[0:13]} iff(driver_trans.mode == 0);
		}
		OPA       : coverpoint driver_trans.opa { bins opa = {[0:255]} with (item / 32 ); }
		OPB       : coverpoint driver_trans.opb { bins opb = {[0:255]} with (item / 32 ); }

		RESETXCE:       cross RESET , CE ;
		CEXMODE:        cross CE , MODE;
		INP_VALIDXMODE: cross INP_VALID , MODE;
	endgroup

	function new(
		mailbox #(alu_transaction) gen2driv,
		mailbox #(alu_transaction) driv2ref,
		virtual alu_interface.driv vif
	);
		this.gen2driv = gen2driv;
		this.driv2ref = driv2ref;
		this.vif = vif;
		input_coverage = new();
	endfunction

	task drive_signals;
		vif.driv_cb.rst       <= driver_trans.rst;
		vif.driv_cb.ce        <= driver_trans.ce;
		vif.driv_cb.opa       <= driver_trans.opa;
		vif.driv_cb.opb       <= driver_trans.opb;
		vif.driv_cb.cin       <= driver_trans.cin;
		vif.driv_cb.mode      <= driver_trans.mode;
		vif.driv_cb.cmd       <= driver_trans.cmd;
		vif.driv_cb.inp_valid <= driver_trans.inp_valid;
		input_coverage.sample();
		driv2ref.put(driver_trans);
		driver_trans.display("DRIVER SIGNLAS");
	endtask

	task delay();
		if( ( driver_trans.mode == 1 ) && ( driver_trans.cmd == 9 || driver_trans.cmd == 10 ) )
			repeat(4) @(vif.driv_cb);  
		else
			repeat(3) @(vif.driv_cb); 
	endtask

	task start();
		for(int i = 0 ; i < `no_of_transaction; i++)
		begin
			driver_trans = new();
			gen2driv.get(driver_trans);
			if( driver_trans.inp_valid == 1 || driver_trans.inp_valid == 2 )
			begin
				if( driver_trans.mode == 1 && driver_trans.cmd inside{4,5,6,7} )
					drive_signals();
				else if( driver_trans.mode == 0 && driver_trans.cmd inside{6,7,8,9,10,11} )
					drive_signals();
				else 
				begin
					for( int i = 0; i < 16; i++ ) 
					begin
						driver_trans.rst.rand_mode(0);
						driver_trans.ce.rand_mode(0);       
						driver_trans.mode.rand_mode(0);
						driver_trans.cmd.rand_mode(0);
						void'( driver_trans.randomize() );
						$display("count = %d",i+1 );
						if( i == 15 )
						begin
							driver_trans.mode.rand_mode(1);
							driver_trans.cmd.rand_mode(1);
							drive_signals();
						end
						else 
						begin
							if( driver_trans.inp_valid == 3 )
							begin
								i = 0 ;
								drive_signals();
								break;
							end
							else
							begin
								drive_signals(); 
							  delay();
							end
						end
					end
				end
				delay();     
			end
			else
			begin
				if( driver_trans.inp_valid == 0 || driver_trans.inp_valid == 3 )
					drive_signals();
				delay(); 
			end
		end
	endtask
endclass


