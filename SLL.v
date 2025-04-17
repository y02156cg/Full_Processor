module SLL(data_operand, ctrl_shiftamt, result);

   input [31:0] data_operand;
	input [4:0] ctrl_shiftamt;

   output [31:0] result;

	wire [31:0] mid1, mid2, mid3, mid4;
	wire [31:0] phase0, phase1, phase2, phase3, phase4;

	assign phase0 = {data_operand[30:0], 1'b0};
	mux_32bit mux0(.in0(data_operand), .in1(phase0), .sel(ctrl_shiftamt[0]), .out(mid1));

	assign phase1 = {mid1[29:0], 2'b00};
	mux_32bit mux1(.in0(mid1), .in1(phase1), .sel(ctrl_shiftamt[1]), .out(mid2));

	assign phase2 = {mid2[27:0], 4'b0000};
	mux_32bit mux2(.in0(mid2), .in1(phase2), .sel(ctrl_shiftamt[2]), .out(mid3));

	assign phase3 = {mid3[23:0], 8'b00000000};
	mux_32bit mux3(.in0(mid3), .in1(phase3), .sel(ctrl_shiftamt[3]), .out(mid4));

	assign phase4 = {mid4[15:0], 16'b0000000000000000};
	mux_32bit mux4(.in0(mid4), .in1(phase4), .sel(ctrl_shiftamt[4]), .out(result));

endmodule
