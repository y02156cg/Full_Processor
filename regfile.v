module regfile(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, 
    data_readRegA, data_readRegB
);
    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    input [31:0] data_writeReg;

    output [31:0] data_readRegA, data_readRegB; 

    wire [31:0] writeDec, readDecB, readDecA, writeReg_choose;
    wire [31:0] q [31:0];
    
    // Write Port //
    decoder5to32 decoder5to32_write(.in(ctrl_writeReg), .out(writeDec));
    and_32 and_32gate(.enable(ctrl_writeEnable), .writeD_in(writeDec), .and_out(writeReg_choose));

    dffe_ref dffe0(.clk(clock), .clr(ctrl_reset), .en(1'b0), .d(data_writeReg), .q(q[0]));
	 genvar i;
	 generate
		for (i=1; i<32; i=i+1) begin: register_loop
			dffe_ref dffe(.clk(clock), .clr(ctrl_reset), .en(writeReg_choose[i]), .d(data_writeReg), .q(q[i]));
		end
	endgenerate
    

    // Read Port A //
    decoder5to32 decoder5to32_readA(.in(ctrl_readRegA), .out(readDecA));
	 
	 genvar j;
	 generate
		for (j=0; j<32; j=j+1) begin: tristate_loop1
			 tristate_32 tristate_32_A(.reg_in(q[j]), .enable_decoder(readDecA[j]), .tri_out(data_readRegA));
		end
	endgenerate


    // Read Port B //
    decoder5to32 decoder5to32_readB(.in(ctrl_readRegB), .out(readDecB));
	 
	 genvar k;
	 generate
		for (k=0; k<32; k=k+1) begin: tristate_loop2
			 tristate_32 tristate_32_B(.reg_in(q[k]), .enable_decoder(readDecB[k]), .tri_out(data_readRegB));
		end
	endgenerate


endmodule

