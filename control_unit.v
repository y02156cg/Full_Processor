module control_unit(opcode, ALUopcode, Rwe, Rst, ALUinB, DMwe, Rwd, overflow, ctrl_of, ALUctrl, j, bne, jal, jr, blt, bex, setx);
	input [4:0] opcode, ALUopcode;
	input overflow;
	output Rwe, Rst, ALUinB, DMwe, Rwd;
	output [4:0] ALUctrl;
	output [1:0] ctrl_of;
	output j, bne, jal, jr, blt, bex, setx;
	
	wire add, addi, sub;
	wire sw, lw, and_op, or_op, sll, sra;
	wire j, bne, jal, jr, blt, bex, setx;
	
	assign sw = opcode[0] & opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4];
	assign lw = ~opcode[0] & ~opcode[1] & ~opcode[2] & opcode[3] & ~opcode[4];
	assign and_op = (~opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4])&(~ALUopcode[0]&ALUopcode[1]&~ALUopcode[2]&~ALUopcode[3]&~ALUopcode[4]);
	assign or_op = (~opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4])&(ALUopcode[0]&ALUopcode[1]&~ALUopcode[2]&~ALUopcode[3]&~ALUopcode[4]);
	assign sll = (~opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4])&(~ALUopcode[0]&~ALUopcode[1]&ALUopcode[2]&~ALUopcode[3]&~ALUopcode[4]);
	assign sra = (~opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4])&(~ALUopcode[0]&~ALUopcode[1]&ALUopcode[2]&~ALUopcode[3]&ALUopcode[4]);

	
	assign addi = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];
	assign add = ~opcode[4]&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0])&(~ALUopcode[0]&~ALUopcode[1]&~ALUopcode[2]&~ALUopcode[3]&~ALUopcode[4]);
	assign sub = ~opcode[4]&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0])&(ALUopcode[0]&~ALUopcode[1]&~ALUopcode[2]&~ALUopcode[3]&~ALUopcode[4]);
	
	assign j = ~opcode[4]&~opcode[3]&~opcode[2]&~opcode[1]&opcode[0];
	assign bne = ~opcode[4]&~opcode[3]&~opcode[2]&opcode[1]&~opcode[0];
	assign jal = ~opcode[4]&~opcode[3]&~opcode[2]&opcode[1]&opcode[0];
	assign jr = ~opcode[4]&~opcode[3]&opcode[2]&~opcode[1]&~opcode[0];
	assign blt = ~opcode[4]&~opcode[3]&opcode[2]&opcode[1]&~opcode[0];
	assign bex = opcode[4]&~opcode[3]&opcode[2]&opcode[1]&~opcode[0];
	assign setx = opcode[4]&~opcode[3]&opcode[2]&~opcode[1]&opcode[0];
	
	assign Rwe = ~(sw | j |bne | jr | blt | bex);
	assign Rst = sw | bne | blt | jr;
	assign ALUinB = addi | sw | lw;
	assign DMwe = sw;
	assign Rwd = lw;
	
	assign ctrl_of[0] = overflow & (add | sub);
	assign ctrl_of[1] = overflow & (addi | sub);
	
	assign ALUctrl = (addi | sw | lw) ? 5'd0 : ((bne | blt) ? 5'd1 : ALUopcode);
	
endmodule
	