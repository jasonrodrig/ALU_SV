`include "alu_environment.sv"

class alu_test;

	virtual alu_interface driv_vif;
	virtual alu_interface mon_vif;
	virtual alu_interface ref_vif;
	alu_environment env;

	function new(	virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);

		this.driv_vif = driv_vif;
		this.mon_vif  = mon_vif;
		this.ref_vif  = ref_vif;
	endfunction

	task run();
		env = new( driv_vif , mon_vif , ref_vif  );
		env.build;
		env.start;	
	endtask

endclass

class rst_ce00_test extends alu_test;
	rst_ce00 test0;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test0 = new();
			env.gen.generator_trans = test0;
		end
		env.start;
	endtask
endclass

class rst_ce10_test extends alu_test;
	rst_ce10 test1;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test1 = new();
			env.gen.generator_trans = test1;
		end
		env.start;
	endtask
endclass

class rst_ce11_test extends alu_test;
	rst_ce11 test2;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test2 = new();
			env.gen.generator_trans = test2;
		end
		env.start;
	endtask
endclass

class logical_single_operand_test extends alu_test;
	logical_single_operand test3;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test3 = new();
			env.gen.generator_trans = test3;
		end
		env.start;
	endtask
endclass

class arithmatic_single_operand_test extends alu_test;
	arithmatic_single_operand test4;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test4 = new();
			env.gen.generator_trans = test4;
		end
		env.start;
	endtask
endclass

class logical_two_operand_test extends alu_test;
	logical_two_operand test5;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test5 = new();
			env.gen.generator_trans = test5;
		end
		env.start;
	endtask
endclass

class arithmatic_two_operand_test extends alu_test;
	arithmatic_two_operand test6;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test6 = new();
			env.gen.generator_trans = test6;
		end
		env.start;
	endtask
endclass

class cycle_16_logical_test extends alu_test;
	cycle_16_logical test7;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test7 = new();
			env.gen.generator_trans = test7;
		end
		env.start;
	endtask
endclass

class cycle_16_arithmatic_test extends alu_test;
	cycle_16_arithmatic test8;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run(); 
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		begin
			test8 = new();
			env.gen.generator_trans = test8;
		end
		env.start;
	endtask
endclass


class test_regression extends alu_test;
	rst_ce00 test0;
	rst_ce10 test1;
	rst_ce11 test2;
	logical_single_operand test3;
	arithmatic_single_operand test4;
	logical_two_operand test5;
	arithmatic_two_operand test6;
	cycle_16_logical test7;
	cycle_16_arithmatic test8;
	function new(virtual alu_interface driv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
		super.new(driv_vif,mon_vif,ref_vif);
	endfunction

	task run();
		env = new(driv_vif,mon_vif,ref_vif);
		env.build;
		env.start;
		begin
			test0 = new();
			env.gen.generator_trans = test0;
		end

		env.start;
		begin
			test1 = new();
			env.gen.generator_trans = test1;
		end
		env.start;

		begin
			test2 = new();
			env.gen.generator_trans = test2;
		end
		env.start;

		begin
			test3 = new();
			env.gen.generator_trans = test3;
		end
		env.start;

		begin
			test4 = new();
			env.gen.generator_trans = test4;
		end
		env.start;

		begin
			test5 = new();
			env.gen.generator_trans = test5;
		end
		env.start;

		begin
			test6 = new();
			env.gen.generator_trans = test6;
		end
		env.start;
		begin
			test7 = new();
			env.gen.generator_trans = test7;
		end
		env.start;
		begin
			test8 = new();
			env.gen.generator_trans = test8;
		end
		env.start;
	endtask
endclass
