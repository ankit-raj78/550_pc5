/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
 
	 wire[4:0] opcode, Rd, Rs, Rt, shamt,alu_op, shmt;
	 wire[16:0] imm;
	 wire[31:0] p_counter, s_out, s_out2;
	 wire out1, isNotEqual, isLessThan, overflow,blt_op,bne_op, j_jal_op,jump_op,bex_op,jal,jr,j,bex,bne,blt,setx;
	 wire[31:0] data_B,alu_out;
    wire[31:0] extend_imm;
	 wire[31:0] Target,branch_op,final;
	 
	 CSA_32 csa1(.a(p_counter[31:0]), .b(32'b1), .cin(1'b0), .sum(s_out[31:0]), .cout(out1)); //PC=PC+1
	 
	// pc_ins pc1(.q(p_counter[31:0]), .d(s_out[31:0]), .clk(clock), .en(1'b1), .clr(reset));
	 pc_ins pc1(.q(p_counter[31:0]), .d(final), .clk(clock), .en(1'b1), .clr(reset));
	 
	 assign address_imem = p_counter[11:0];
	 
	 //Pc5---from here--- part
	 
	 CSA_32 csa2(.a(s_out[31:0]), .b(extend_imm[31:0]), .cin(1'b0), .sum(s_out2[31:0]), .cout(out1)); //PC=PC+1+N
	 
	 assign Target[31:27] = 5'b00000;
	 assign Target[26:0] = q_imem[26:0];
	 
	 assign bne_op = bne & isNotEqual;
	 assign blt_op = (~isLessThan) & isNotEqual & blt;
	 assign bex_op = bex & isNotEqual;
	 assign branch_op = (bne_op | blt_op) ? s_out2: s_out;
	 assign jump_op = (jal | j);
	 assign final = jr ? data_readRegB : bex_op ? Target: (jump_op ? Target : branch_op); 
	 
	 
	 
	 
	 
	 wire Rdst, ALUinB, Rwe, Rwd, DMWe, all_Rtype, add, addi,sub,ovf; 
	 wire[31:0] ovf_status,mux1_out, mux2_out;
	 wire [31:0] rwd_mux;
	 
	// assign ALUop = q_imem[6:2];
	 assign opcode = q_imem[31:27];
	 assign Rs = q_imem[21:17];
	 assign Rt = q_imem[16:12];
	 assign Rd = q_imem[26:22];
	// assign shamt = q_imem[11:7];
	 assign imm = q_imem[16:0];
	 
	 //control signals
	 control_unit cont1(.opcode(opcode), .Rdst(Rdst), .ALUinB(ALUinB), .Rwe(Rwe), .Rwd(Rwd), .DMwe(DMWe), .all_Rtype(all_Rtype), .ALUop(alu_op), .addi(addi), .add(add), .sub(sub), .jal(jal), .jr(jr), .j(j), .bex(bex), .bne(bne), .blt(blt), .setx(setx));
	
	 assign ovf_status = all_Rtype ? (add) ? 32'd1 : 32'd3 : 32'd2;
	
	 
	 assign alu_op = all_Rtype ? q_imem[6:2] : 5'b00000;
	 assign shmt = all_Rtype ?  q_imem[11:7] : 5'b00000;
	 //Register file
	 assign ctrl_readRegA = bex? 5'b00000 : Rs;
	 assign ctrl_readRegB = bex ? 5'b11110 : (Rdst ? Rd : Rt);
	 assign ctrl_writeEnable = Rwe;
	
	 assign ctrl_writeReg = jal ? 5'b11111 : (((add | sub | addi) & overflow) | setx) ? 5'b11110 : Rd;
  
	// wire[31:0] extend_imm;
	 assign extend_imm[31:17] = {15{imm[16]}};
	 assign extend_imm[16:0] = imm;
	 
	 //alu
	 assign data_B = ALUinB ? extend_imm : data_readRegB;
	 alu alu1(.data_operandA(data_readRegA), .data_operandB(data_B), .ctrl_ALUopcode(alu_op), .ctrl_shiftamt(shmt), .data_result(alu_out), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));

   //dmem
	
   assign wren = DMWe;
	assign data = data_readRegB;
	assign address_dmem = alu_out[11:0];
 
	
	//assign data_writeReg = ((add | sub | addi) & overflow) ? ovf_status : (Rwd ? q_dmem : alu_out);
	  assign data_writeReg = setx ? Target : (jal ? s_out : (((add | sub | addi) & overflow) ? ovf_status : (Rwd ? q_dmem : alu_out)));
 
endmodule
