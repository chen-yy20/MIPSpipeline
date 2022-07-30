`timescale 1ns / 1ps
module DataMemory_new(reset, clk, ex_wr,Address, Write_data, Read_data, MemRead, ByteRead,MemWrite, led_data, digi_data);
	input reset, clk;
	input ex_wr;
	input [31:0] Address, Write_data;
	input MemRead, ByteRead, MemWrite;
	output [31:0] Read_data;
	output [31:0] led_data;
	output [31:0] digi_data;
	
	parameter RAM_SIZE = 2048;
	parameter RAM_SIZE_BIT = 8;
	
	// 8bit * 4* RAM_SIZE512
	reg [7:0] RAM_data[2048- 1: 0];

	// external equipment
	reg [7:0] led;
	reg [11:0] digi;
    wire [9:0] base_Address;
    assign base_Address = {Address[9:2],2'b00};

	// the first 2 bit is 00 and there are only 256 words in the RAM => valid bit: 2-9
	assign Read_data = 	MemRead? {RAM_data[base_Address],RAM_data[base_Address+2'b01],RAM_data[base_Address+2'b10],RAM_data[base_Address+2'b11]}: 
						ByteRead? {24'h000000,RAM_data[Address[9:0]]}: 
						32'h00000000;
	assign led_data = {24'b0,led};
	assign digi_data = {20'b0,digi};
	
	integer i;
	always @(posedge reset or posedge clk)
		if (reset) begin
			for (i = 0; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 8'h00;
				led<= 8'b10101011;
				digi <= 0;
			// initial str
			RAM_data[10'd16] <= 8'h63;
			RAM_data[10'd17] <= 8'h61;
			RAM_data[10'd18] <= 8'h6e;
			RAM_data[10'd19] <= 8'h20;
			RAM_data[10'd20] <= 8'h61;
			RAM_data[10'd21] <= 8'h20;
			RAM_data[10'd22] <= 8'h63;
			RAM_data[10'd23] <= 8'h61;
			RAM_data[10'd24] <= 8'h6e;
			RAM_data[10'd25] <= 8'h6e;
			RAM_data[10'd26] <= 8'h65;
			RAM_data[10'd27] <= 8'h72;
			RAM_data[10'd28] <= 8'h20;
			RAM_data[10'd29] <= 8'h63;
			RAM_data[10'd30] <= 8'h61;
			RAM_data[10'd31] <= 8'h6e;
			RAM_data[10'd32] <= 8'h20;
			RAM_data[10'd33] <= 8'h61;
			RAM_data[10'd34] <= 8'h20;
			RAM_data[10'd35] <= 8'h63;
			RAM_data[10'd36] <= 8'h61;
			RAM_data[10'd37] <= 8'h6e;
			RAM_data[10'd38] <= 8'h20;
			RAM_data[10'd39] <= 8'h6c;
			RAM_data[10'd40] <= 8'h69;
			RAM_data[10'd41] <= 8'h6b;
			RAM_data[10'd42] <= 8'h65;
			RAM_data[10'd43] <= 8'h20;
			RAM_data[10'd44] <= 8'h61;
			RAM_data[10'd45] <= 8'h20;
			RAM_data[10'd46] <= 8'h63;
			RAM_data[10'd47] <= 8'h61;
			RAM_data[10'd48] <= 8'h6e;
			RAM_data[10'd49] <= 8'h6e;
			RAM_data[10'd50] <= 8'h65;
			RAM_data[10'd51] <= 8'h72;
			RAM_data[10'd52] <= 8'h20;
			RAM_data[10'd53] <= 8'h63;
			RAM_data[10'd54] <= 8'h61;
			RAM_data[10'd55] <= 8'h6e;
			RAM_data[10'd56] <= 8'h20;
			RAM_data[10'd57] <= 8'h61;
			RAM_data[10'd58] <= 8'h20;
			RAM_data[10'd59] <= 8'h63;
			RAM_data[10'd60] <= 8'h61;
			RAM_data[10'd61] <= 8'h6e;
			RAM_data[10'd62] <= 8'h3f;
			RAM_data[10'd63] <= 8'ha;
			// initial pattern
			RAM_data[10'd512] <= 8'h63;
			RAM_data[10'd513] <= 8'h61;
			RAM_data[10'd514] <= 8'h6e;
			end
		else if (ex_wr) begin
			casez(Address)
				32'h4000000C: led <= Write_data[7:0];
				32'h40000010: digi <= Write_data[11:0];
			endcase
		end
		else if (MemWrite)
			// fetch data: 32bit
            begin
			RAM_data[base_Address] <= Write_data[31:24];
            RAM_data[base_Address+2'b01] <= Write_data[23:16];
            RAM_data[base_Address+2'b10] <= Write_data[15:8];
            RAM_data[base_Address+2'b11] <= Write_data[7:0];
            end
			
endmodule
