module and_32(
    input enable,
    input [31:0] writeD_in,
    output [31:0] and_out
);
    genvar i;
    generate 
        for (i=0; i<32; i=i+1) begin: and_loop
            and and_gate(and_out[i], enable, writeD_in[i]);
        end
    endgenerate

endmodule


