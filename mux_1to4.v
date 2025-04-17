module mux_1to4(of_signal, of_out, data);
	input [1:0] of_signal;
	input [31:0] data;
	output [31:0] of_out;
	
	wire [31:0] of_temp1, of_temp2;
	
	assign of_temp1 = of_signal[0] ? 32'd1 : data;
	assign of_temp2 = of_signal[0] ? 32'd3 : 32'd2;
	
	assign of_out = of_signal[1] ? of_temp2 : of_temp1;
	
endmodule 