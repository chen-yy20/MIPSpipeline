
module test_cpu();
	
	reg reset;
	reg clk;
	wire [7:0] Led;
	wire [6:0] seg;
	wire [3:0] ano;
	
	CPU cpu1(reset,clk,2'b00,Led,seg,ano);
	
	initial begin
		reset = 1;
		clk = 1;
		#2 reset = 0;
	end

	always forever begin 
		#1 clk = ~clk;
	end
endmodule
