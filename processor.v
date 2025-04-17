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
	 
	 wire [31:0] instruction, current_pc, next_pc, ALUB, ALUoutput;
	 wire [4:0] opcode, rd, rs, rt, shamt, ALUopcode, ALUctrl;
	 wire [32:0] immediate;
	 wire ALUinB, Rst, Rwd, overflow, of_indicator;
	 wire [1:0] of_signal;
	 wire [31:0] of_out;
	 wire [31:0] T;
	 wire j, bne, jal, jr, blt, bex, setx, BR;
	 wire isNotEqual, isLessThan;
	 wire [31:0] pc_1add, pc_Nadd;
	 wire blt_and, bne_and, bex_and, choose_T;
	 
	 localparam Rstatus = 5'd30;
	 localparam Rreturn = 5'd31;
	 localparam Rzero = 5'd0;
	 
	 /* PC */
	 
	 dffe_ref pc(.clk(clock), .d(next_pc), .q(current_pc), .clr(reset), .en(1'b1));
	 alu pc_add1(.data_operandA(current_pc), .data_operandB(32'd1), .ctrl_ALUopcode(5'd0), .data_result(pc_1add));
	 alu pc_addN(.data_operandA(pc_1add), .data_operandB(immediate), .ctrl_ALUopcode(5'd0), .data_result(pc_Nadd));
	 
	 /* Imem */
	 assign address_imem = current_pc[11:0];
	 assign instruction = q_imem;
	 
	 assign opcode = instruction[31:27];
	 assign rd = instruction[26:22];
	 assign rs = instruction[21:17];
	 assign rt = instruction[16:12];
	 assign shamt = instruction[11:7];
	 assign ALUopcode = instruction[6:2];
	 assign immediate = {{15{instruction[16]}}, instruction[16:0]}; //sign extension
	 assign T = {{5{instruction[26]}}, instruction[26:0]};
	 
	 /* Control Unit */
	 control_unit control(.opcode(opcode), .ALUopcode(ALUopcode), .Rwe(ctrl_writeEnable), .Rst(Rst), .ALUinB(ALUinB),
				.DMwe(wren), .Rwd(Rwd), .overflow(overflow), .ctrl_of(of_signal), .ALUctrl(ALUctrl), .j(j), .bne(bne), .jal(jal),
				.jr(jr), .blt(blt), .bex(bex), .setx(setx));
				
	 or (of_indicator, of_signal[0], of_signal[1]);
	 
	 /* Register File */
	 
	 assign ctrl_readRegB = bex ? Rzero : (Rst ? rd : rt);
	 assign ctrl_readRegA = bex ? Rstatus : rs;
	 assign ctrl_writeReg = (of_indicator | setx) ? Rstatus : (jal ? Rreturn : rd);
	 
	 /* ALU */
	 assign ALUB = ALUinB ? immediate : data_readRegB;
	 alu main_alu(.data_operandA(data_readRegA), .data_operandB(ALUB), .ctrl_ALUopcode(ALUctrl),
	 .ctrl_shiftamt(shamt), .data_result(ALUoutput), .overflow(overflow), .isNotEqual(isNotEqual), .isLessThan(isLessThan));
	 
	 and (blt_and, ~isLessThan, isNotEqual, blt);
	 and (bne_and, isNotEqual, bne);
	 or (BR, blt_and, bne_and);
	 and (bex_and, bex, isNotEqual);
	 or (choose_T, bex_and, j, jal);
	 
	 assign next_pc = BR ? pc_Nadd : (choose_T ? T : (jr ? data_readRegB : pc_1add));
	 
	 /* Dmem */
	 mux_1to4 of_mux(.of_signal(of_signal), .of_out(of_out), .data(ALUoutput));
	 
	 assign address_dmem = ALUoutput[11:0];
	 assign data = data_readRegB;
	 
	 assign data_writeReg = jal ? pc_1add : (setx ? T :(Rwd ? q_dmem : of_out));


endmodule 