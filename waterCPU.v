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
	wire [31:0] alures_i, alures_o1, alures_o2;
    reg  [31:0] PC;
    wire [31:0] PCnext;
    wire [31:0] PCp4_origin,PCout;
	wire [31:0] origin_Ins,Ins,alu_Ins,;
	wire sign,Zero,branch,regwrite,memread,memwrite,alusrc1,alusrc2,extop,luop;
	wire [1:0] pcsrc, regdst,memtoreg;
	wire [4:0] aluc;
	wire [31:0] op1, op1_o, op2_o1, op2_o2,op1_reg; 
	wire [31:0] mem_w;
	wire [31:0] MemData_i,MemData_o;
	reg [31:0] show;

	wire [31:0] a0,v0,sp,ra;
	// Imm32_o processed extension based on extop and luop
	reg signed [31:0] Imm32, Imm32_o;
	reg signed [31:0] alu1;
	reg signed [31:0] alu2;
	reg signed [31:0] busW;
    reg [31:0] cnt;

    Control ControlUnit(.OpCode(pre_Ins[31:26]), .Funct(pre_Ins[5:0]),
           .PCSrc(pcsrc), .Branch(branch), .RegWrite(regwrite), .RegDst(regdst), 
           .MemRead(memread), .MemWrite(memwrite), .MemtoReg(memtoreg), 
           .ALUSrc1(alusrc1), .ALUSrc2(alusrc2), .ExtOp(extop), .LuOp(luop));
    InstructionMemory IMem(.Address(PC), .Instruction(origin_Ins));

	// realization
    ALU Alu(.in1(alu1), .in2(alu2), .ALUCtrl(aluc), .Sign(sign), .out(alures_i), .zero(Zero));
    ALUControl AluC(.Opcode(alu_Ins[31:26]), .Funct(alu_Ins[5:0]), .ALUCtrl(aluc), .Sign(sign));
    DataMemory DMem(.reset(Reset), .clk(slow_clk), .Address(alures_o1), .Write_data(mem_w), .Read_data(MemData_i), .MemRead(memread), .MemWrite(memwrite));
    RegisterFile Rfile(.reset(Reset), .clk(slow_clk), .RegWrite(RegWr3), .Read_register1(Ins[25:21]), .Read_register2(Ins[20:16]), .Write_register(rf4), .Write_data(busW), .Read_data1(op1), .Read_data2(op2),.A0(a0),.V0(v0),.SP(sp),.RA(ra));
	bcd_2_7seg BCD(.s1_data(show[15:12]),.s2_data(show[11:8]),.s3_data(show[7:4]),.s4_data(show[3:0]),.clk(Clk),.dout(Seg),.ano(Ano));
	ImmProcess ImmP(.ExtOp(extop),.LuiOp(luop),.Immediate(Ins[15:0]),ImmExtOut(Imm32));

	//RegTemp
	RegTemp regPC(.reset(Reset),.clk(slow_clk),.Data_i(PCnext),.Data_o(PCout));

	// pipeline
	wire [31:0] PCp40,PCp41,PCp42;
	wire [4:0] ALUCtrl1;
	wire [1:0] ALUSrc1_1,ALUSrc2_1,RegDst1,MemtoReg1,PCSrc1;
	wire [1:0] MemtoReg2,PCSrc2;
	wire [1:0] MemtoReg3;
	wire Sign1, MemWr1,Branch1,RegWr1,LuOp1;
	wire MemWr2,Branch2,RegWr2;
	wire RegWr3;
	wire [5:0] rs1,rt1,rd1,rf2,rf3,rf4;

	RegIF_ID IFID(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp4_origin),.PCp4_o(PCp40),.ins_i(origin_Ins),.ins_o(pre_Ins));
	// RegIF_IF IFIF(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp4),.ExtOp_i(extop),.ALUSrc1_i(alusrc1),.ALUSrc2_i(alusrc2),.ALUCtrl_i(aluc),.Sign_i(sign),.RegDst_i(regdst),.MemWr_i(memwrite),.Branch_i(branch),.MemtoReg_i(memtoreg),.RegWr_i(regwrite),.PCSrc_i(pcsrc),.LuOp_i(luop),.PCp4_o(PCp41),.ExtOp_o(ExtOp1),.ALUSrc1_o(ALUSrc1_1),.ALUSrc2_o(ALUSrc2_1),.ALUCtrl_o(ALUCtrl1),.Sign_o(Sign1),.RegDst_o(RegDst1),.MemWr_o(MemWr1),.Branch_o(Branch1),.MemtoReg_o(MemtoReg1),.RegWr_o(RegWr1),.PCSrc_o(PCSrc1),.LuOp_o(LuOp1));
	RegID_EX IDEX(.reset(Reset),.clk(slow_clk),.Rs_i(Ins[25:21]),.Rt_i(Ins[20:16]),.Rd_i(Ins[15:11]),.Rs_o(rs1),.Rt_o(rt1),.Rd_o(rd1),.Op1_i(op1),.Op2_i(op2),.Imm_i(Imm32),.Ins_i(Ins),.Op1_o(op1_o),.Op2_o(op2_o1),.Imm_o(Imm32_o),.Ins_o(alu_Ins),.PCp4_i(PCp40),.ALUSrc1_i(alusrc1),.ALUSrc2_i(alusrc2),.ALUCtrl_i(aluc),.Sign_i(sign),.RegDst_i(regdst),.MemWr_i(memwrite),.Branch_i(branch),.MemtoReg_i(memtoreg),.RegWr_i(regwrite),.PCSrc_i(pcsrc),.LuOp_i(luop),.PCp4_o(PCp41),.ALUSrc1_o(ALUSrc1_1),.ALUSrc2_o(ALUSrc2_1),.ALUCtrl_o(ALUCtrl1),.Sign_o(Sign1),.RegDst_o(RegDst1),.MemWr_o(MemWr1),.Branch_o(Branch1),.MemtoReg_o(MemtoReg1),.RegWr_o(RegWr1),.PCSrc_o(PCSrc1),.LuOp_o(LuOp1));
	// RegID_EX IDEX(.reset(Reset),.clk(slow_clk),.PCp4_i(PCp41),.ALUSrc1_i(ALUSrc1_1),.ALUSrc2_i(ALUSrc2_1),.ALUCtrl_i(ALUCtrl1),.Sign_i(Sign1),.RegDst_i(RegDst1),.MemWr_i(MemWr1),.Branch_i(Branch1),.MemtoReg_i(MemtoReg1),.RegWr_i(RegWr1),.PCSrc_i(PCSrc1),.LuOp_i(LuOp1),.PCp4_o(PCp42),.ALUSrc1_o(),.ALUSrc2_o(),.ALUCtrl_o(),.Sign_o(),.RegDst_o(),.MemWr_o(),.Branch_o(),.MemtoReg_o(),.RegWr_o(),.PCSrc_o(),.LuOp_o());
	RegEX_MEM EXMEM(.reset(Reset),.clk(slow_clk),.Rf_i(rf2),.Rf_o(rf3),.AluRes_i(alures_i),.AluRes_o(alures_o1),.Op2_i(op2_o1),.Op2_o(op2_o2),.PCp4_i(PCp41),.MemWr_i(MemWr1),.Branch_i(Branch1),.MemtoReg_i(MemtoReg1),.RegWr_i(RegWr1),.PCSrc_i(PCSrc1),.PCp4_o(PCp42),.MemWr_o(MemWr2),.Branch_o(Branch2),.MemtoReg_o(MemtoReg2),.RegWr_o(RegWr2),.PCSrc_o(PCSrc2));
	RegMEM_WB MEMWB(.reset(Reset),.clk(slow_clk),.Rf_i(rf3),.Rf_o(rf4),.AluRes_i(alures_o1),.Memdata_i(MemData_i),.Memdata_o(MemData_o),.AluRes_o(alures_o2),.MemtoReg_i(MemtoReg2),.RegWr_i(RegWr2),.MemtoReg_o(MemtoReg3),.RegWr_o(RegWr3));
	//
	assign PCp4_origin = PCout+4;
	assign PCnext = (pcsrc==2'b00)?PCp4_origin:
					(pcsrc==2'b10)?{PCp41[31:28],Ins[25:0],2'b00}: // jump
					(pcsrc==2'b01&&Branch2&&Zero)?PCp41+(Imm32<<2): // beq
					op1_o;	// jump regs
	assign mem_w = ()?MemData_o:op2_o2;
	assign rf2 = (RegDst1==2'b00)?rd1:
				 (RegDst1==2'b01)?rt1:
				 5'b11111;


	// TODO: always block should be fixed
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


	// TODO： hazard control
	always @(*)
	begin
		op1_reg = ()?:op1_o; // TODO： hazard unit
        alu1 = (alusrc1==1)?alu_Ins[10:6]:op1_reg; // Ins or Reg
        alu2 = (alusrc2==1)?Imm32_o:op2_o1;
        busW = 	(MemtoReg2==2'b00)?alures_o2:
				MemData_o; //(memtoreg==2'b01)?
		// bcd
		//show = 16'h1234;
		show = (show_control==2'b00)?a0:
		(show_control==2'b01)?v0:
		(show_control==2'b10)?sp:
		ra;
		led = PC[7:0];
	end
	

endmodule
	