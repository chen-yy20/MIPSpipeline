`timescale 1ns / 1ps
module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		// first 2 bits are 00
		case (Address[9:2])
        8'd0: Instruction <= 32'h00102021;
        8'd1: Instruction <= 32'h00113021;
        8'd2: Instruction <= {6'h3,26'd8};// jump and link 
        // show up
        8'd3: Instruction <= {6'h3F,5'd0,5'd2,5'd0,5'd0,6'h0};
        //      esw2 $v0[11:8] $digi
        8'd4: Instruction <= {6'h3F,5'd0,5'd2,5'd0,5'd0,6'h1};
        //      esw3 $v0[7:4] $digi
        8'd5: Instruction <= {6'h3F,5'd0,5'd2,5'd0,5'd0,6'h2};
        //      esw4 $v0[3:0] $digi
        8'd6: Instruction <= {6'h3F,5'd0,5'd2,5'd0,5'd0,6'h3};
        //     beq $zero,$zero,Loop # always loop
        8'd7: Instruction <= {6'h04, 5'd0, 5'd0, 16'hFFFB};
        // brute force
        8'd8: Instruction <= 32'h24080000;
        8'd9: Instruction <= 32'h24090000;
        8'd10: Instruction <= 32'h02117022;
        // outer loop
        8'd11: Instruction <= 32'h01C9582A;
        8'd12: Instruction <= {6'h05,5'd11,5'd0,16'd15}; // bnez outerloop break
        8'd13: Instruction <= 32'h240a0000;
        // inner loop
        8'd14: Instruction <= 32'h0151582A;
        8'd15: Instruction <= {16'h1160,16'd8}; // beqz inner_loop_break
        8'd16: Instruction <= 32'h012A5820;
        8'd17: Instruction <= 32'h00AB9020;
        8'd18: Instruction <= 32'h00EA9820;
        // load byte
        8'd19: Instruction <= 32'h824C0000;
        8'd20: Instruction <= 32'h826D0000;
        8'd21: Instruction <= {16'h158D,16'd2}; // bne innerloopbreak
        8'd22: Instruction <= 32'h214A0001;
        8'd23: Instruction <= {6'h2,26'd14};
        // inner loop break
        8'd24: Instruction <= {16'h1551,16'd1}; // bne not if
        8'd25: Instruction <= 32'h21080001;
        // not if
        8'd26: Instruction <= 32'h21290001;
        8'd27: Instruction <= {6'h2,26'd11};
        // outer loop break
        8'd28: Instruction <= 32'h00081021;
        8'd29: Instruction <= 32'h03e00008;
		default: Instruction <= 32'h00000000;
		endcase
		
endmodule
