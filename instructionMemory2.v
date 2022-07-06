
module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		// first 2 bits are 00
		case (Address[9:2])
        //     addi $a0, $zero, 5 #a=5
        8'd0:   Instruction <= {6'h08, 5'd0, 5'd4, 16'd5};
        //     xor $v0, $zero, $zero # set v0 = 0
        8'd1:   Instruction <= {6'h00, 5'd0, 5'd0, 5'd2, 5'd0, 6'h26};
        //     jal sum # to Sum
        8'd2:   Instruction <= {6'h03, 26'd4};
        // Loop:
        //     # at last it will come here
        //     beq $zero,$zero,Loop # always loop
        8'd3:   Instruction <= {6'h04, 5'd0, 5'd0, 16'hFFFF};
        // sum:
        //     addi $sp, $sp, -8
        8'd4:   Instruction <= {6'h08, 5'd29, 5'd29, 16'hFFF8};
        //     sw $ra,4($sp) # save the return PC address
        8'd5:   Instruction <= {6'h2B, 5'd29, 5'd31, 16'd4};
        //     # a= 5,4,3,2,1,0
        //     sw $a0, 0($sp) # save this a (begin with 5)
        8'd6:   Instruction <= {6'h2B, 5'd29, 5'd4, 16'd0};
        //     # if a>=1 branch to L1
        //     slti $t0, $a0, 1
        8'd7:   Instruction <= {6'h0A, 5'd4, 5'd8, 16'd1};
        //     beq $t0, $zero, L1 
        8'd8:   Instruction <= {6'h04, 5'd8, 5'd0, 16'd2};
        //     # if a<1 return
        //     # move sp upper
        //     addi $sp, $sp, 8
        8'd9:   Instruction <= {6'h08, 5'd29, 5'd29, 16'd8};
        //     jr $ra
        8'd10:   Instruction <= {6'h00, 5'd31, 15'd0, 6'h08};
        // L1:
        //     # static var v0 += a0 v0 = 5+4+3+2+1
        //     add $v0,$a0,$v0
        8'd11:   Instruction <= {6'h00, 5'd4, 5'd2, 5'd2, 5'd0, 6'h20};
        //     # a -= 1 a= 4\3\2\1\0
        //     addi $a0, $a0, -1
        8'd12:   Instruction <= {6'h08, 5'd4, 5'd4, 16'hFFFF};
        //     jal sum
        8'd13:   Instruction <= {6'h03, 26'd4};
        //     # a0 = 1,2,3,4,5, ra is always here
        //     lw $a0,0($sp)
        8'd14:   Instruction <= {6'h23, 5'd29, 5'd4, 16'd0};
        //     lw $ra,4($sp)
        8'd15:   Instruction <= {6'h23, 5'd29, 5'd31, 16'd4};
        //     addi $sp, $sp, 8
        8'd16:   Instruction <= {6'h08, 5'd29, 5'd29, 16'd8};
        //     add $v0, $a0, $v0
        8'd17:   Instruction <= {6'h00, 5'd4, 5'd2, 5'd2, 5'd0, 6'h20};
        //     jr $ra
		8'd18:   Instruction <= {6'h00, 5'd31, 15'd0, 6'h08};
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
