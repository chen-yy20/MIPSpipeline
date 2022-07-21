`timescale 1ns / 1ps
module DataMemory(reset, clk, ex_wr,Address, Write_data, Read_data, MemRead, MemWrite, led_data, digi_data);
	input reset, clk;
	input ex_wr;
	input [31:0] Address, Write_data;
	input MemRead, MemWrite;
	output [31:0] Read_data;
	output [31:0] led_data;
	output [31:0] digi_data;
	
	parameter RAM_SIZE = 512;
	parameter RAM_SIZE_BIT = 8;
	
	// 32bit * RAM_SIZE
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	// external equipment
	reg [7:0] led;
	reg [11:0] digi;

	// the first 2 bit is 00 and there are only 256 words in the RAM => valid bit: 2-9
	assign Read_data = 	MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	assign led_data = {24'b0,led};
	assign digi_data = {20'b0,digi};
	
	integer i;
	always @(posedge reset or posedge clk)
		if (reset) begin
			for (i = 0; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
				led<= 0;
				digi <= 0;
			end
		else if (ex_wr) begin
			casez(Address)
				32'h4000000C: led <= Write_data[7:0];
				32'h40000010: digi <= Write_data[11:0];
			endcase
		end
		else if (MemWrite)
			// fetch data: 32bit
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
			
endmodule
