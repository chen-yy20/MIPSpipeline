// --- water-line CPU ---
// need a few registers as pipeline
// forwarding <= from ↑registers to input <= just wires
//  
module CPU(Reset, Clk,show_control, led,Seg,Ano);
// should constraint
	input Reset;
	input  Clk;
	input wire [1:0] show_control;
	output reg [7:0] led;
	output wire [6:0] Seg;
    output wire [3:0] Ano;
	// Regs and Wires
	reg slow_clk;
	wire [31:0] alu_res;
    reg  [31:0] PC;
    wire [31:0] PCnext;
    wire [31:0] PCp4,PCout;
	wire [31:0] Ins;
	wire sign,Zero,branch,regwrite,memread,memwrite,alusrc1,alusrc2,extop,luop;
	wire [1:0] pcsrc, regdst,memtoreg;
	reg [4:0] Rw;
	wire [4:0] aluc;
	wire [31:0] op1, op2, MemData;
	reg [31:0] show;

	wire [31:0] a0,v0,sp,ra;
	reg signed [31:0] Imm32;
	reg signed [31:0] alu1;
	reg signed [31:0] alu2;
	reg signed [31:0] busW;
    reg [31:0] cnt;

    Control ControlUnit(.OpCode(Ins[31:26]), .Funct(Ins[5:0]),
           .PCSrc(pcsrc), .Branch(branch), .RegWrite(regwrite), .RegDst(regdst), 
           .MemRead(memread), .MemWrite(memwrite), .MemtoReg(memtoreg), 
           .ALUSrc1(alusrc1), .ALUSrc2(alusrc2), .ExtOp(extop), .LuOp(luop));
    InstructionMemory IMem(.Address(PC), .Instruction(Ins));
	// realization
    ALU Alu(.in1(alu1), .in2(alu2), .ALUCtrl(aluc), .Sign(sign), .out(alu_res), .zero(Zero));
    ALUControl AluC(.Opcode(Ins[31:26]), .Funct(Ins[5:0]), .ALUCtrl(aluc), .Sign(sign));
    DataMemory DMem(.reset(Reset), .clk(slow_clk), .Address(alu_res), .Write_data(op2), .Read_data(MemData), .MemRead(memread), .MemWrite(memwrite));
    RegisterFile Rfile(.reset(Reset), .clk(slow_clk), .RegWrite(regwrite), .Read_register1(Ins[25:21]), .Read_register2(Ins[20:16]), .Write_register(Rw), .Write_data(busW), .Read_data1(op1), .Read_data2(op2),.A0(a0),.V0(v0),.SP(sp),.RA(ra));
	bcd_2_7seg BCD(.s1_data(show[15:12]),.s2_data(show[11:8]),.s3_data(show[7:4]),.s4_data(show[3:0]),.clk(Clk),.dout(Seg),.ano(Ano));
	
	//RegTemp
	RegTemp regPC(.reset(Reset),.clk(slow_clk),.Data_i(PCnext),.Data_o(PCout));

	// pipeline
	RegIF_ID IFID(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp4),.ExtOp_i(),.ALUSrc_i(),.ALUCtrl_i(),.Sign_i(),.RegDst_i(),.MemWr_i(),.Branch_i(),.MemtoReg_i(),.RegWr_i(),.PCSrc_i(),.LuOp_i(),.PCp4_o(),.ExtOp_o(),.ALUSrc_o(),.ALUCtrl_o(),.Sign_o(),.RegDst_o(),.MemWr_o(),.Branch_o(),.MemtoReg_o(),.RegWr_o(),.PCSrc_o(),.LuOp_o());
	RegID_EX IDEX(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp4),.ALUSrc_i(),.ALUCtrl_i(),.Sign_i(),.RegDst_i(),.MemWr_i(),.Branch_i(),.MemtoReg_i(),.RegWr_i(),.PCSrc_i(),.LuOp_i(),.PCp4_o(),.ALUSrc_o(),.ALUCtrl_o(),.Sign_o(),.RegDst_o(),.MemWr_o(),.Branch_o(),.MemtoReg_o(),.RegWr_o(),.PCSrc_o(),.LuOp_o());
	RegEX_MEM EXMEM(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp4),.MemWr_i(),.Branch_i(),.MemtoReg_i(),.RegWr_i(),.PCSrc_i(),.PCp4_o(),.MemWr_o(),.Branch_o(),.MemtoReg_o(),.RegWr_o(),.PCSrc_o());
	RegMEM_WB MEMWB(.reset(Reset),.clk(slow_clk),.MemtoReg_i(),.RegWr_i(),.MemtoReg_o(),.RegWr_o());
	//

	assign PCp4 = PCout+4;
	assign PCnext = (pcsrc==2'b00||pcsrc==2'b01)?PCp4:
				(pcsrc==2'b10)?{PCp4[31:28],Ins[25:0],2'b00}:op1;

	always @(posedge Reset or posedge slow_clk)
	begin
			if (Reset) 
			begin
				PC <= 0;
				cnt <= 0;
				slow_clk <= 0;
			end
			else 
			begin
				PC <= PCnext;
			end
	end

    always@(posedge Clk)
	begin
		 if(cnt == 32'd5000000) begin
           slow_clk <= ~slow_clk;
           cnt <= 0;
        end
        else cnt <= cnt +1;
    end

	always @(*)
	begin
	// ext the imm
        Imm32 = (extop==0)?{{16{Ins[15]}},Ins[15:0]}:
        (luop==1'b1)?{Ins[15:0],{16{1'b0}}}:
        {{16{1'b0}},Ins[15:0]};
        alu1 = (alusrc1==1)?Ins[10:6]:op1;
        alu2 = (alusrc2==1)?Imm32:op2;
        busW = (memtoreg==2'b00)?alu_res:(memtoreg==2'b01)?MemData:PC+4;
        Rw = (regdst==2'b00)?Ins[15:11]:(regdst==2'b01)?Ins[20:16]:5'b11111;
		// bcd
		//show = 16'h1234;
		show = (show_control==2'b00)?a0:
		(show_control==2'b01)?v0:
		(show_control==2'b10)?sp:
		ra;
		led = PC[7:0];
	end
	

endmodule
	