module tristate_32(reg_in, enable_decoder, tri_out);
	input[31:0] reg_in;
	input enable_decoder;
	output[31:0] tri_out;

    assign tri_out = enable_decoder ? reg_in : 32'bz;

endmodule
	
	
	/*assign tri_out[0] = enable_decoder ? reg_in[0] : 1'bz;
	assign tri_out[1] = enable_decoder ? reg_in[1] : 1'bz;
	assign tri_out[2] = enable_decoder ? reg_in[2] : 1'bz;
	assign tri_out[3] = enable_decoder ? reg_in[3] : 1'bz;
	assign tri_out[4] = enable_decoder ? reg_in[4] : 1'bz;
	assign tri_out[5] = enable_decoder ? reg_in[5] : 1'bz;
	assign tri_out[6] = enable_decoder ? reg_in[6] : 1'bz;
	assign tri_out[7] = enable_decoder ? reg_in[7] : 1'bz;
	assign tri_out[8] = enable_decoder ? reg_in[8] : 1'bz;
	assign tri_out[9] = enable_decoder ? reg_in[9] : 1'bz;
	assign tri_out[10] = enable_decoder ? reg_in[10] : 1'bz;
	assign tri_out[11] = enable_decoder ? reg_in[11] : 1'bz;
	assign tri_out[12] = enable_decoder ? reg_in[12] : 1'bz;
	assign tri_out[13] = enable_decoder ? reg_in[13] : 1'bz;
	assign tri_out[14] = enable_decoder ? reg_in[14] : 1'bz;
	assign tri_out[15] = enable_decoder ? reg_in[15] : 1'bz;
	assign tri_out[16] = enable_decoder ? reg_in[16] : 1'bz;
	assign tri_out[17] = enable_decoder ? reg_in[17] : 1'bz;
	assign tri_out[18] = enable_decoder ? reg_in[18] : 1'bz;
	assign tri_out[19] = enable_decoder ? reg_in[19] : 1'bz;
	assign tri_out[20] = enable_decoder ? reg_in[20] : 1'bz;
	assign tri_out[21] = enable_decoder ? reg_in[21] : 1'bz;
	assign tri_out[22] = enable_decoder ? reg_in[22] : 1'bz;
	assign tri_out[23] = enable_decoder ? reg_in[23] : 1'bz;
	assign tri_out[24] = enable_decoder ? reg_in[24] : 1'bz;
	assign tri_out[25] = enable_decoder ? reg_in[25] : 1'bz;
	assign tri_out[26] = enable_decoder ? reg_in[26] : 1'bz;
	assign tri_out[27] = enable_decoder ? reg_in[27] : 1'bz;
	assign tri_out[28] = enable_decoder ? reg_in[28] : 1'bz;
	assign tri_out[29] = enable_decoder ? reg_in[29] : 1'bz;
	assign tri_out[30] = enable_decoder ? reg_in[30] : 1'bz;
	assign tri_out[31] = enable_decoder ? reg_in[31] : 1'bz;*/



