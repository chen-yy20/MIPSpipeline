`timescale 1ns / 1ps
module RegisterFile(reset, clk, RegWrite, Read_register1, Read_register2, Write_register, Write_data, Read_data1, Read_data2,A0,V0,SP,RA);
	input reset, clk;
	input RegWrite;
	input [4:0] Read_register1, Read_register2, Write_register;
	input [31:0] Write_data;
	output [31:0] Read_data1, Read_data2;
	output [31:0] A0,V0,SP,RA;
	
	reg [31:0] RF_data[31:1];
	
	assign Read_data1 = (Read_register1 == 5'b00000)? 32'h00000000: RF_data[Read_register1];
	assign Read_data2 = (Read_register2 == 5'b00000)? 32'h00000000: RF_data[Read_register2];
	assign A0 = RF_data[4];
	assign V0 = RF_data[2];
	assign SP = RF_data[29];
	assign RA = RF_data[31];

	integer i;
	always @(posedge reset or negedge clk)
		if (reset) begin
			for (i = 1; i < 32; i = i + 1)
				RF_data[i] <= 32'h00000000;
			// INITIAL s0 = 17; s1 = 3; a1 = 10'd16; a3 = 10'd512;
			RF_data[16] <= 32'd47;
			RF_data[17] <= 32'd3;
			RF_data[5] <= 10'd16;
			RF_data[7] <= 10'd512;
			
		end
		else if (RegWrite && (Write_register != 5'b00000))
			RF_data[Write_register] <= Write_data;

endmodule
			