module dffe_ref(q, d, clk, en, clr);
   
   //Inputs
   input clk, en, clr;
   input [31:0] d;

   //Internal wire
   wire clr;

   //Output
   output reg [31:0] q;
   
   //Register
   //reg q;

   //Intialize q to 0
   initial
   begin
       q = 32'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 32'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule
