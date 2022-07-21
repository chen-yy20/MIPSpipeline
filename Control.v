`timescale 1ns / 1ps
module Control(OpCode, Funct,
	PCSrc, Branch, RegWrite, RegDst, 
	MemRead, MemWrite,ExWrite,ExAno, MemtoReg, 
	ALUSrc1, ALUSrc2, ExtOp, LuOp);
	input [5:0] OpCode;
	input [5:0] Funct;
	output [1:0] PCSrc;
	output Branch;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output ExWrite;
	output [1:0] ExAno;
	output [1:0] MemtoReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	
    assign PCSrc = (OpCode==6'h04||OpCode==6'h05||OpCode==6'h30||OpCode==6'h38||OpCode==6'h21)?2'b01:(OpCode==6'h02||OpCode==6'h03)?2'b10:((OpCode==0&&Funct==6'h08)||(OpCode==0&&Funct==6'h09))?2'b11:2'b00;
    assign Branch = (OpCode==6'h04||OpCode==6'h05||OpCode==6'h30||OpCode==6'h38||OpCode==6'h21)?1:0;
    assign RegWrite = (OpCode==6'h04||OpCode==6'h05||OpCode==6'h30||OpCode==6'h38||OpCode==6'h21||OpCode==6'h02||OpCode==6'h3F||(OpCode ==0&&Funct == 6'h08)||(OpCode ==0&&Funct == 6'h09)||OpCode==6'h2b)?0:1;
    // 01 I-type write Rt
    assign RegDst = (OpCode==6'h03||(OpCode ==0&&Funct == 6'h09))?2'b10:(OpCode==6'h23||OpCode == 6'h2b||OpCode==6'h0f||OpCode==6'h08||OpCode==6'h09||OpCode==6'h0c||OpCode==6'h0a||OpCode==6'h0b||OpCode==6'h04)?2'b01:2'b00;
    assign MemRead = (OpCode==6'h23)?1:0;
    assign MemWrite = (OpCode==6'h2b)?1:0;
	// external device control
	assign ExWrite = (OpCode == 6'h3F)?1:0;
	assign ExAno = Funct[1:0];
    // jalr
    assign MemtoReg = (OpCode==6'h23)?2'b01:(OpCode==6'h03||(OpCode ==0&&Funct == 6'h09))?2'b10:2'b00;
    // choose IMM or Rt
    assign ALUSrc2 = (OpCode==6'h23||OpCode==6'h2b||OpCode==6'h0f||OpCode==6'h08||OpCode==6'h09||OpCode==6'h0c||OpCode==6'h0a||OpCode==6'h0b)?1:0;
    // Rs or shamt
    assign ALUSrc1 = (OpCode == 6'h0 &&(Funct==6'h0||Funct==6'h02||Funct==6'h03))?1:0;
    assign ExtOp = (OpCode==6'h0c)?1:0;
    assign LuOp = (OpCode==6'h0f)?1:0;


	
endmodule