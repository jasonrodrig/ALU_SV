class alu_transaction;

	rand bit ce , rst;
	rand bit mode , cin ;
	rand logic [1:0] inp_valid ;
	rand logic [ `CMD_WIDTH - 1 : 0 ] cmd ;
	rand logic [ `DATA_WIDTH - 1 : 0 ] opa , opb ;

	logic [RESULT_WIDTH - 1 : 0] res ;
	logic oflow , cout , g , l , e , err ;

	virtual function alu_transaction copy();
		copy = new();
		copy.mode = this.mode;
		copy.cin  = this.cin;
		copy.inp_valid = this.inp_valid;
		copy.cmd  = this.cmd;
		copy.opa  = this.opa;
		copy.opb  = this.opb;
		copy.rst  = this.rst;
		copy.ce   = this.ce;
		return copy;
	endfunction

	function void display(string name);
		$display("-------------------------------------------------------------------------------------------");
		$display("\t%s", name);
		$display(" Time: %0t , rst = %0b , ce = %0b , mode = %0b , cmd = %0d , inp_valid = %0d, cin = %0b , opa = %0d , opb = %0d", $time , rst , ce , mode , cmd , inp_valid , cin , opa , opb );
		$display(" Time: %0t , res = %0b , oflow = %0b , cout = %0b , g = %0b , l = %0b , e = %0b , err = %0b\n", $time , res , oflow , cout , g , l , e , err );
		$display("-------------------------------------------------------------------------------------------");
	endfunction

endclass

class rst_ce00 extends alu_transaction;

	constraint rst_ce {rst ==0;  ce==0; inp_valid == 3;}
	virtual function alu_transaction copy();
		rst_ce00 copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class rst_ce10 extends alu_transaction;

	constraint rst_ce {rst ==1;  ce==0; inp_valid == 3;}
	virtual function alu_transaction copy();
		rst_ce10 copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class rst_ce11 extends alu_transaction;

	constraint rst_ce {rst ==1;  ce==1; inp_valid ==3;}
	virtual function alu_transaction copy();
		rst_ce11 copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class logical_single_operand extends alu_transaction;
	constraint rst_ce {rst ==0;  ce==1;}
	constraint cmd_val {cmd inside {[6:11]};}
	constraint mode_val {mode == 0;}
	constraint inp_valid_val {inp_valid inside {[1:2]};}
	virtual function alu_transaction copy();
		logical_single_operand copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class arithmatic_single_operand extends alu_transaction;
	constraint rst_ce {rst ==0;  ce==1;}
	constraint cmd_val {cmd inside {[4:7]};}
	constraint mode_val {mode == 1;}
	constraint inp_valid_val {inp_valid inside {[1:2]};}
	virtual function alu_transaction copy();
		arithmatic_single_operand copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class logical_two_operand extends alu_transaction;
	constraint rst_ce {rst ==0;  ce==1;}
	//constraint rotate_left{cmd == 12; opa==1;}
	constraint cmd_val {cmd inside {[0:5],[12:13]};}
	constraint mode_val {mode == 0;}
	constraint inp_valid_val {inp_valid == 3;}
	virtual function alu_transaction copy();
		logical_two_operand copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class arithmatic_two_operand extends alu_transaction;
	constraint rst_ce {rst ==0;  ce==1;}
	//constraint cmd_mul {cmd dist{ 0:=3,9:=1 };}
	constraint cmd_val {cmd inside {[0:3],[8:10]};}
	constraint mode_val {mode == 1;}
	constraint inp_valid_val {inp_valid == 3;}
	virtual function alu_transaction copy();
		arithmatic_two_operand copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class cycle_16_logical extends alu_transaction;
	constraint rst_ce {rst ==0;  ce==1;}
	//constraint rotate_left{cmd == 12; opa==1;}
	constraint cmd_val {cmd inside {[0:5],[12:13]};}
	constraint mode_val {mode == 0;}
	constraint inp_valid_val {inp_valid inside{[0:3]};}
	virtual function alu_transaction copy();
		cycle_16_logical copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass

class cycle_16_arithmatic extends alu_transaction;
	constraint rst_ce {rst ==0;  ce==1;}
	constraint cmd_add {cmd == 0;}
	//constraint cmd_val {cmd inside {[0:3],[8:10]};}
	constraint mode_val {mode == 1;}
	constraint inp_valid_val {inp_valid inside {[0:3]};}
	virtual function alu_transaction copy();
		cycle_16_arithmatic copy1;
		copy1 = new();
		copy1.opa = this.opa;
		copy1.opb = this.opb;
		copy1.inp_valid = this.inp_valid;
		copy1.cmd = this.cmd;
		copy1.cin = this.cin;
		copy1.mode = this.mode;
		copy1.rst = this.rst;
		copy1.ce = this.ce;
		return copy1;
	endfunction
endclass


