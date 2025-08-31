class alu_reference_model;

	alu_transaction ref_t;

	mailbox#(alu_transaction) driv2ref;
	mailbox#(alu_transaction) ref2scb;
	virtual alu_interface.reference_cb vif;

	function new(
		mailbox#(alu_transaction) driv2ref,
		mailbox#(alu_transaction) ref2scb,
		virtual alu_interface.reference_cb vif
	);

		this.driv2ref = driv2ref;
		this.ref2scb  = ref2scb;
		this.vif      = vif;
	endfunction
	reg [ RESULT_WIDTH - 1 : 0 ] t_mul;
	task start();
		for(int i = 0; i < `no_of_transaction; i++)
		begin
			driv2ref.get(ref_t);	
			repeat(3)@(vif.reference_cb);
			if( ( ref_t.cmd == 9 || ref_t.cmd == 10 ) && ( ref_t.mode == 1 ) )
				repeat(1)@(vif.reference_cb);

			if(ref_t.rst || !ref_t.ce)begin
				ref_t.res = 'bz ;
				ref_t.oflow = 'bz; 
				ref_t.cout = 'bz;
				ref_t.g = 'bz ; 
				ref_t.l = 'bz; 
				ref_t.e = 'bz; 
				ref_t.err = 'bz;
			end
			else if(ref_t.ce)begin
				ref_t.res ='bz ;
				ref_t.oflow = 'bz; 
				ref_t.cout = 'bz;
				ref_t.g = 'bz ; 
				ref_t.l = 'bz; 
				ref_t.e = 'bz; 
				ref_t.err = 'bz;
				t_mul = 'b0;

				if( ref_t.mode )
					arithematic_operation(ref_t);
				else
					logical_operation(ref_t);
			end
			ref_t.display("REFERENCE SIGNALS ");
			ref2scb.put(ref_t);
		end
	endtask

	task arithematic_operation(input alu_transaction ref_t);
		case(ref_t.cmd)

			0:begin // ADD WITHOUT CIN
				if( ref_t.inp_valid == 3) 
				begin
					ref_t.res = ref_t.opa + ref_t.opb;
					ref_t.cout = ( ref_t.res[`DATA_WIDTH] ) ? 1 : 0;
				end
				else ref_t.err = 1;
			end

			1:begin // SUB WITHOUT CIN
				if( ref_t.inp_valid == 3) 
				begin
					ref_t.res = ( ref_t.opa - ref_t.opb ) & ( { { (`DATA_WIDTH){1'b0} } , { (`DATA_WIDTH){1'b1} } } );
					ref_t.oflow = ( ( ref_t.opa < ref_t.opb ) || ( ( ref_t.opa == ref_t.opb ) && (ref_t.cin == 1 ) ) ) ? 1 :0;
				end
				else ref_t.err = 1;
			end

			2:begin // ADD WITH CIN
				if( ref_t.inp_valid == 3) 
				begin
					ref_t.res = ref_t.opa + ref_t.opb + ref_t.cin;
					ref_t.cout = ( ref_t.res[`DATA_WIDTH] ) ? 1 : 0;
				end
				else ref_t.err = 1;
			end

			3:begin // SUB WITH CIN
				if( ref_t.inp_valid == 3) 
				begin
					ref_t.res = ( ref_t.opa - ref_t.opb - ref_t.cin ) & ( { { (`DATA_WIDTH){1'b0} } , { (`DATA_WIDTH){1'b1} } } );
					ref_t.oflow = ( ( ref_t.opa < ref_t.opb ) || ( ( ref_t.opa == ref_t.opb ) && ( ref_t.cin == 1 ) ) ) ? 1 :0;
				end
				else ref_t.err = 1;
			end

			4:begin // INCREMENT A
				if( ref_t.inp_valid == 1)
				begin
					ref_t.res = ref_t.opa + 1;
					ref_t.cout = ( ref_t.res[`DATA_WIDTH] ) ? 1 : 0;
				end
				else ref_t.err = 1;
			end

			5:begin // DECREMENT A
				if( ref_t.inp_valid == 1)
				begin
					ref_t.res = ( ref_t.opa - 1 ) & ( { { (`DATA_WIDTH){1'b0} } , { (`DATA_WIDTH){1'b1} } } );
					ref_t.oflow = ( ref_t.opa == 0 ) ? 1 : 0;
				end
				else ref_t.err = 1;
			end

			6:begin // INCREMENT B
				if( ref_t.inp_valid == 2)
				begin
					ref_t.res = ref_t.opb + 1;
					ref_t.cout = ( ref_t.res[`DATA_WIDTH] ) ? 1 : 0;
				end
				else ref_t.err = 1;
			end

			7:begin // DECREMENT B
				if( ref_t.inp_valid == 2)
				begin
					ref_t.res = ( ref_t.opb - 1 ) & ( { { (`DATA_WIDTH){1'b0} } , { (`DATA_WIDTH){1'b1} } } );
					ref_t.oflow = ( ref_t.opb == 0 ) ? 1 : 0;
				end
				else ref_t.err = 1;
			end

			8:begin // COMPARISON 
				if( ref_t.inp_valid == 3 )
				begin

					ref_t.res = 'bz;

					if (ref_t.opa == ref_t.opb )
					begin
						ref_t.e = 'b1;
						ref_t.g = 'bz;
						ref_t.l = 'bz;
					end

					else if( ref_t.opa > ref_t.opb )
					begin
						ref_t.e = 'bz;
						ref_t.g = 'b1;
						ref_t.l = 'bz;
					end		          

					else 
					begin
						ref_t.e = 'bz;
						ref_t.g = 'bz;
						ref_t.l = 'b1;
					end

				end
				else ref_t.err = 1;
			end

			9:begin // INCREMENT AND MULTIPLY
				if(ref_t.inp_valid == 3) begin
					t_mul  = ( ref_t.opa + 1 ) * ( ref_t.opb + 1 );  
					ref_t.res =  t_mul;
				end
				else ref_t.err = 1;
			end

			10:begin // SHIFT AND MULTIPLY
				if(ref_t.inp_valid == 3) begin
					bit [`DATA_WIDTH - 1:0] temp = ( ref_t.opa << 1 ); 
					t_mul  = ( temp ) * ( ref_t.opb );
					ref_t.res =  t_mul;
				end
				else ref_t.err = 1;
			end
			default:begin
				ref_t.err = 1;
			end
		endcase    
	endtask

	task logical_operation(input alu_transaction ref_t);
		case(ref_t.cmd)
			0: begin // BITWISE AND
				if(ref_t.inp_valid == 3) begin
					ref_t.res = ( ref_t.opa & ref_t.opb ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } ); 
				end
				else ref_t.err = 1;
			end

			1: begin // BITWISE NAND
				if(ref_t.inp_valid == 3) begin
					ref_t.res = ( ~( ref_t.opa & ref_t.opb ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } ); 
				end
				else ref_t.err = 1;
			end

			2: begin // BITWISE OR
				if(ref_t.inp_valid == 3) begin
					ref_t.res = ( ref_t.opa | ref_t.opb ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } ); 
				end
				else ref_t.err = 1;
			end

			3: begin // BITWISE NOR
				if(ref_t.inp_valid == 3) begin
					ref_t.res = ( ~( ref_t.opa | ref_t.opb ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } ); 
				end
				else ref_t.err = 1;
			end

			4: begin // BITWISE XOR
				if(ref_t.inp_valid == 3) begin
					ref_t.res = ( ref_t.opa ^ ref_t.opb ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } ); 
				end
				else ref_t.err = 1;
			end

			5: begin // BITWISE XNOR
				if(ref_t.inp_valid == 3) begin
					ref_t.res = ( ~( ref_t.opa ^ ref_t.opb ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } ); 
				end
				else ref_t.err = 1;
			end

			6: begin // NOT A
				if(ref_t.inp_valid == 1) begin
					ref_t.res = ( ~( ref_t.opa ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
				end
				else ref_t.err = 1;
			end

			7: begin // NOT B
				if(ref_t.inp_valid == 2) begin
					ref_t.res = ( ~( ref_t.opb ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
				end
				else ref_t.err = 1;
			end

			8: begin // SHIFT RIGHT A
				if(ref_t.inp_valid == 1) begin
					ref_t.res = ( ( ref_t.opa ) >> 1 ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
				end
				else ref_t.err = 1;
			end

			9: begin // SHIFT LEFT A
				if(ref_t.inp_valid == 1) begin
					ref_t.res = ( ( ref_t.opa ) << 1 ) & ( { {`DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
				end
				else ref_t.err = 1;
			end

			10: begin // SHIFT RIGHT B
				if(ref_t.inp_valid == 2) begin
					ref_t.res = ( ( ref_t.opb ) >> 1 ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
				end
				else ref_t.err = 1;
			end

			11: begin // SHIFT LEFT B
				if(ref_t.inp_valid == 2) begin
					ref_t.res = ( ( ref_t.opb ) << 1 ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
				end
				else ref_t.err = 1;
			end


			12: begin
				if(ref_t.inp_valid == 3) begin
					ref_t.res = 
						( ( ref_t.opa << ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | (ref_t.opa >> ( `DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) ) ) & ( { {(`DATA_WIDTH){ 1'b0 }} , { (`DATA_WIDTH ){1'b1} } } );

					if(|(ref_t.opb[ `DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)])) ref_t.err = 1; 
					else                                                           ref_t.err = 0;
				end
				else ref_t.err = 1;
			end

			13: begin // ROTATE RIGHT
				if(ref_t.inp_valid == 3) begin
					ref_t.res[ `DATA_WIDTH : 0 ] = 
						( ( ref_t.opa >> ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | ( ref_t.opa << ( `DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );

					if(|(ref_t.opb[ `DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)])) ref_t.err = 1; 
					else                                                           ref_t.err = 0;
				end
				else ref_t.err = 1;
			end

			default : begin
				ref_t.err = 1;
			end
		endcase
	endtask
endclass


