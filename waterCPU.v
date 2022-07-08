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
	wire [31:0] PCp41,PCp42;
	wire [4:0] ALUCtrl1;
	wire [1:0] ALUSrc1_1,ALUSrc2_1,RegDst1,MemtoReg1,PCSrc1;
	wire [1:0] MemtoReg2,PCSrc2;
	wire [1:0] MemtoReg3;
	wire Sign1, MemWr1,Branch1,RegWr1,LuOp1;
	wire MemWr2,Branch2,RegWr2;
	wire RegWr3;
	// RegIF_IF IFIF(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp4),.ExtOp_i(extop),.ALUSrc1_i(alusrc1),.ALUSrc2_i(alusrc2),.ALUCtrl_i(aluc),.Sign_i(sign),.RegDst_i(regdst),.MemWr_i(memwrite),.Branch_i(branch),.MemtoReg_i(memtoreg),.RegWr_i(regwrite),.PCSrc_i(pcsrc),.LuOp_i(luop),.PCp4_o(PCp41),.ExtOp_o(ExtOp1),.ALUSrc1_o(ALUSrc1_1),.ALUSrc2_o(ALUSrc2_1),.ALUCtrl_o(ALUCtrl1),.Sign_o(Sign1),.RegDst_o(RegDst1),.MemWr_o(MemWr1),.Branch_o(Branch1),.MemtoReg_o(MemtoReg1),.RegWr_o(RegWr1),.PCSrc_o(PCSrc1),.LuOp_o(LuOp1));
	RegID_EX IDEX(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp4),.ALUSrc1_i(alusrc1),.ALUSrc2_i(alusrc2),.ALUCtrl_i(aluc),.Sign_i(sign),.RegDst_i(regdst),.MemWr_i(memwrite),.Branch_i(branch),.MemtoReg_i(memtoreg),.RegWr_i(regwrite),.PCSrc_i(pcsrc),.LuOp_i(luop),.PCp4_o(PCp41),.ALUSrc1_o(ALUSrc1_1),.ALUSrc2_o(ALUSrc2_1),.ALUCtrl_o(ALUCtrl1),.Sign_o(Sign1),.RegDst_o(RegDst1),.MemWr_o(MemWr1),.Branch_o(Branch1),.MemtoReg_o(MemtoReg1),.RegWr_o(RegWr1),.PCSrc_o(PCSrc1),.LuOp_o(LuOp1));
	// RegID_EX IDEX(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp41),.ALUSrc1_i(ALUSrc1_1),.ALUSrc2_i(ALUSrc2_1),.ALUCtrl_i(ALUCtrl1),.Sign_i(Sign1),.RegDst_i(RegDst1),.MemWr_i(MemWr1),.Branch_i(Branch1),.MemtoReg_i(MemtoReg1),.RegWr_i(RegWr1),.PCSrc_i(PCSrc1),.LuOp_i(LuOp1),.PCp4_o(PCp42),.ALUSrc1_o(),.ALUSrc2_o(),.ALUCtrl_o(),.Sign_o(),.RegDst_o(),.MemWr_o(),.Branch_o(),.MemtoReg_o(),.RegWr_o(),.PCSrc_o(),.LuOp_o());
	RegEX_MEM EXMEM(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp41),.MemWr_i(MemWr1),.Branch_i(Branch1),.MemtoReg_i(MemtoReg1),.RegWr_i(RegWr1),.PCSrc_i(PCSrc1),.PCp4_o(PCp42),.MemWr_o(MemWr2),.Branch_o(Branch2),.MemtoReg_o(MemtoReg2),.RegWr_o(RegWr2),.PCSrc_o(PCSrc2));
	RegMEM_WB MEMWB(.reset(Reset),.clk(slow_clk),.MemtoReg_i(MemtoReg2),.RegWr_i(RegWr2),.MemtoReg_o(MemtoReg3),.RegWr_o(RegWr3));
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
	