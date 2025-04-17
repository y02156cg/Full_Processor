module decoder5to32(
    input [4:0] in,
    output [31:0] out
);
    parameter [31:0] basevalue = 32'd1;
	 
	SLL sll_1(.data_operand(basevalue), .ctrl_shiftamt(in), .result(out));

endmodule


