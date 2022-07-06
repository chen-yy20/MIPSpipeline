
module DataMemory(reset, clk, Address, Write_data, Read_data, MemRead, MemWrite);
	input reset, clk;
	input [31:0] Address, Write_data;
	input MemRead, MemWrite;
	output [31:0] Read_data;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
	
	// 32bit * RAM_SIZE
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];
	// the first 2 bit is 00 and there are only 256 words in the RAM => valid bit: 2-9
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	integer i;
	always @(posedge reset or posedge clk)
		if (reset)
			for (i = 0; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
		else if (MemWrite)
			// fetch data: 32bit
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
			
endmodule
