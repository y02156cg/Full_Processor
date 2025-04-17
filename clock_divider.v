module clock_div2(clk, reset, clk_out);

	input clk, reset;
	output reg clk_out;
	
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			clk_out <= 1'b0;
		end 
		else begin
			clk_out <= ~clk_out;
		end
	end
endmodule 
	
module clock_divider(clk,reset, processor_clk, imem_clk, regfil_clk, dmem_clk);

	input clk, reset;
	output processor_clk, imem_clk, regfil_clk, dmem_clk;
	
	wire proclk_temp;
	
	clock_div2 prodiv2(.clk(clk), .reset(reset), .clk_out(proclk_temp));
	clock_div2 prodiv(.clk(proclk_temp), .reset(reset), .clk_out(processor_clk));
	
	assign regfil_clk = processor_clk;
	assign dmem_clk = clk;
	assign imem_clk 																										= ~clk;
	
	/*always @(posedge clk or posedge reset or negedge clk) begin
		if(reset) begin
			imem_clk <= 1'b0;
		end else begin
			imem_clk <= ~clk;
		end*/
		
	endmodule 