class alu_generator;

	alu_transaction generator_trans;
	mailbox #(alu_transaction) gen2driv;

	function new( mailbox #(alu_transaction) gen2driv );
		this.gen2driv = gen2driv;
		this.generator_trans = new();
	endfunction

	task start();
		for( int i = 0 ; i < `no_of_transaction ; i++ )
		begin
			assert(generator_trans.randomize());
			gen2driv.put(generator_trans.copy()); 
			generator_trans.display("generator signals");
		end
	endtask
endclass
