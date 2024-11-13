module pc_ins(q, d, clk, en, clr);

	input[31:0] d;
	input clk,en,clr;
	
	output[31:0] q;
	
	genvar i;
	generate 
			for(i=0; i<32; i=i+1) begin: loop_pc
			  dffe_ref pc1(.q(q[i]), .d(d[i]), .clk(clk), .en(en), .clr(clr));
			end
	endgenerate
	
endmodule