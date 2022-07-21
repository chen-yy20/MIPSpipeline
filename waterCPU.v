`timescale 1ns / 1ps
// --- water-line CPU ---
// need a few registers as pipeline
// forwarding <= from ↑registers to input <= just wires
//  
module CPU(Reset, Clk,show_control, led,Seg,Ano);
// should constraint
	input Reset;
	input  Clk;
	input wire [1:0] show_control;
	output wire [7:0] led;
	output wire [6:0] Seg;
    output wire [3:0] Ano;
	// external device
	wire ex_WR_ID,ex_WR_EX,ex_WR_MEM;
	wire [11:0] digi_wr_data;
	wire [31:0] led_out, digi_out;
	// Regs and Wires
	reg slow_clk;
	wire [1:0] ex_Ano_ID, ex_Ano_EX, ex_Ano_MEM;
	wire [31:0] alures_EX, alures_MEM, alures_WB;
    wire [31:0] PCnext,PCout;
    wire [31:0] PCp4_origin;
	wire [31:0] Ins_IF,Ins_ID,Ins_EX,Ins_MEM;
	// original control signals
	wire sign,Zero,branch,regwrite,memread,memwrite,alusrc1,alusrc2,extop,luop;
	wire [1:0] PCSrc_ID, regdst, memtoreg;

	wire [4:0] aluc;
	wire [31:0] Op1_ID,Op2_ID,Op1_EX, Op2_EX, Op2_MEM, Op2_reg; // Op2_reg is MUX with forward control 
	wire [31:0] MemWr_data;
	wire [31:0] MemData_MEM,MemData_WB;
	reg [31:0] show;

	wire [31:0] a0,v0,sp,ra;
	// pipeline wires
	wire [31:0] PC_MEM, PC_WB;
	wire [31:0] PCp4_ID,PCp4_EX;
    wire [1:0] RegDst_EX,MemtoReg_EX,PCSrc_EX;
    wire  AluSrc1_EX,AluSrc2_EX;
    wire [1:0] MemtoReg_MEM,PCSrc_MEM;
    wire [1:0] MemtoReg_WB;
    wire Sign_EX, MemWr_EX,MemRd_EX,Branch_EX,RegWr_EX;
    wire MemWr_MEM,MemRd_MEM,RegWr_MEM;
    wire RegWr_WB;
    wire [4:0] Rs_EX,Rt_EX,Rd_EX,Rfinal_EX,Rfinal_MEM,Rfinal_WB;
    // hazard wires
    wire [1:0] forward1_1,forward1_2;
    wire forward2;
    wire stall1;
    wire Null_IFID, Null_IDEX;
	wire signed [31:0] Imm32_ID, Imm32_EX;
	// Imm32_EX processed extension based on extop and luop
	reg signed [31:0] alu1;
	reg signed [31:0] alu2;
	reg signed [31:0] RFWr_data;
    reg [31:0] cnt;

	// Reset and Devide the frequency
	always@(posedge Clk or posedge Reset)
	begin
         if (Reset) 
            begin
                cnt <= 0;
                slow_clk <= 0;
            end    
		 else if(cnt == 32'd50) begin // should be 5000000
           slow_clk <= ~slow_clk;
           cnt <= 0;
        end
        else cnt <= cnt +1;
    end

	// Units realization
    Control ControlUnit(.OpCode(Ins_ID[31:26]), .Funct(Ins_ID[5:0]),
		   .ExWrite(ex_WR_ID),.ExAno(ex_Ano_ID),
           .PCSrc(PCSrc_ID), .Branch(branch), .RegWrite(regwrite), .RegDst(regdst), 
           .MemRead(memread), .MemWrite(memwrite), .MemtoReg(memtoreg), 
           .ALUSrc1(alusrc1), .ALUSrc2(alusrc2), .ExtOp(extop), .LuOp(luop));
    InstructionMemory IMem(.Address(PCout), .Instruction(Ins_IF));
    ALU Alu(.in1(alu1), .in2(alu2), .ALUCtrl(aluc), .Sign(sign), .out(alures_EX), .zero(Zero));
    ALUControl AluC(.Opcode(Ins_EX[31:26]), .Funct(Ins_EX[5:0]), .ALUCtrl(aluc), .Sign(sign));
    DataMemory DMem(.reset(Reset), .clk(slow_clk),.ex_wr(ex_WR_MEM),.led_data(led_out),.digi_data(digi_out),.Address(alures_MEM), .Write_data(MemWr_data), .Read_data(MemData_MEM), .MemRead(MemRd_MEM), .MemWrite(MemWr_MEM));
    RegisterFile Rfile(.reset(Reset), .clk(slow_clk), .RegWrite(RegWr_WB), .Read_register1(Ins_ID[25:21]), .Read_register2(Ins_ID[20:16]), .Write_register(Rfinal_WB), .Write_data(RFWr_data), .Read_data1(Op1_ID), .Read_data2(Op2_ID),.A0(a0),.V0(v0),.SP(sp),.RA(ra));
	//bcd_2_7seg BCD(.s1_data(show[15:12]),.s2_data(show[11:8]),.s3_data(show[7:4]),.s4_data(show[3:0]),.clk(Clk),.dout(Seg),.ano(Ano));
	ImmProcess ImmP(.ExtOp(extop),.LuiOp(luop),.Immediate(Ins_ID[15:0]),.ImmExtOut(Imm32_ID));
	Digi_decoder DIGI(.v0(Op2_MEM),.ano(ex_Ano_MEM),.code_o(digi_wr_data));
	//RegTemp
	RegTemp regPC(.reset(Reset),.clk(slow_clk),.Data_i(PCnext),.Data_o(PCout));

	// pipeline

	RegIF_ID IFID(.reset(Reset),.clk(slow_clk),.stay(stall1),.null(Null_IFID),.PCp4_i(PCp4_origin),.PCp4_o(PCp4_ID),.ins_i(Ins_IF),.ins_o(Ins_ID));
	RegID_EX IDEX(.reset(Reset),.clk(slow_clk),.null(Null_IDEX),.ex_wr_i(ex_WR_ID),.ex_wr_o(ex_WR_EX),.ex_ano_i(ex_Ano_ID),.ex_ano_o(ex_Ano_EX),.Rs_i(Ins_ID[25:21]),.Rt_i(Ins_ID[20:16]),.Rd_i(Ins_ID[15:11]),.Rs_o(Rs_EX),.Rt_o(Rt_EX),.Rd_o(Rd_EX),.Op1_i(Op1_ID),.Op2_i(Op2_ID),.Imm_i(Imm32_ID),.Ins_i(Ins_ID),.Op1_o(Op1_EX),.Op2_o(Op2_EX),.Imm_o(Imm32_EX),.Ins_o(Ins_EX),.PCp4_i(PCp4_ID),.ALUSrc1_i(alusrc1),.ALUSrc2_i(alusrc2),.Sign_i(sign),.RegDst_i(regdst),.MemWr_i(memwrite),.MemRd_i(memread),.Branch_i(branch),.MemtoReg_i(memtoreg),.RegWr_i(regwrite),.PCSrc_i(PCSrc_ID),.PCp4_o(PCp4_EX),.ALUSrc1_o(AluSrc1_EX),.ALUSrc2_o(AluSrc2_EX),.Sign_o(Sign_EX),.RegDst_o(RegDst_EX),.MemWr_o(MemWr_EX),.MemRd_o(MemRd_EX),.Branch_o(Branch_EX),.MemtoReg_o(MemtoReg_EX),.RegWr_o(RegWr_EX),.PCSrc_o(PCSrc_EX));
	RegEX_MEM EXMEM(.reset(Reset),.clk(slow_clk),.ex_wr_i(ex_WR_EX),.ex_wr_o(ex_WR_MEM),.ex_ano_i(ex_Ano_EX),.ex_ano_o(ex_Ano_MEM),.PCp4_i(PCp4_EX),.PC_o(PC_MEM),.Ins_i(Ins_EX),.Ins_o(Ins_MEM),.Rf_i(Rfinal_EX),.Rf_o(Rfinal_MEM),.AluRes_i(alures_EX),.AluRes_o(alures_MEM),.Op2_i(Op2_EX),.Op2_o(Op2_MEM),.MemWr_i(MemWr_EX),.MemRd_i(MemRd_EX),.MemtoReg_i(MemtoReg_EX),.RegWr_i(RegWr_EX),.PCSrc_i(PCSrc_EX),.MemWr_o(MemWr_MEM),.MemRd_o(MemRd_MEM),.MemtoReg_o(MemtoReg_MEM),.RegWr_o(RegWr_MEM),.PCSrc_o(PCSrc_MEM));
	RegMEM_WB MEMWB(.reset(Reset),.clk(slow_clk),.PC_i(PC_MEM),.PC_o(PC_WB),.Rf_i(Rfinal_MEM),.Rf_o(Rfinal_WB),.AluRes_i(alures_MEM),.Memdata_i(MemData_MEM),.Memdata_o(MemData_WB),.AluRes_o(alures_WB),.MemtoReg_i(MemtoReg_MEM),.RegWr_i(RegWr_MEM),.MemtoReg_o(MemtoReg_WB),.RegWr_o(RegWr_WB));


	// hazard control
	assign stall1 = ((Ins_ID[25:21]==Rt_EX||Ins_ID[20:16]==Rt_EX)&&(Ins_EX[31:26]==6'h23))?1:0; // only when load-use
	assign forward1_1 = (Rs_EX==Rfinal_MEM && RegWr_MEM==1)?2'b01:
						(Rs_EX==Rfinal_WB && RegWr_WB==1)?2'b10:
						0;
	assign forward1_2 = (Rt_EX==Rfinal_MEM && RegWr_MEM==1)?2'b01:
						(Rt_EX==Rfinal_WB && RegWr_WB==1)?2'b10:
						0;
	assign Op2_reg = (forward1_2==2'b01)?alures_MEM:
					 (forward1_2==2'b10)?RFWr_data:
					 Op2_EX;
	assign forward2 = (MemWr_MEM==1&&(Rfinal_MEM==Rfinal_WB))?1:0;
	assign Null_IFID = ((Branch_EX&&Zero)||PCSrc_ID==2'b10||PCSrc_ID==2'b11)?1:0;  // jump or beq
	assign Null_IDEX = ((Branch_EX&&Zero)||stall1)?1:0;

	// pc update
	assign PCp4_origin = PCout+4;
	assign PCnext = (Branch_EX&&Zero)?PCp4_EX+(Imm32_EX<<2): // beq EX priority
					(PCSrc_ID==2'b10)?{PCp4_ID[31:28],Ins_ID[25:0],2'b00}: // jump ID
					(PCSrc_ID==2'b11)?Op1_ID: // jump reg ID			
					PCp4_origin;	// PC+4
	// branch & jump 

	assign MemWr_data = (forward2==1)?RFWr_data:
						(ex_WR_MEM==1)?digi_wr_data:
						Op2_MEM;
	assign Rfinal_EX = (RegDst_EX==2'b00)?Rd_EX:
				 (RegDst_EX==2'b01)?Rt_EX:
				 5'b11111;

	// show control
	assign Seg = digi_out[6:0];
	assign Ano = digi_out[11:8];
	assign led = led_out[7:0];

	always @(*)
	begin
		RFWr_data = (MemtoReg_WB==2'b10)?PC_WB+4:
					(MemtoReg_WB==2'b00)?alures_WB:
					MemData_WB;
        alu1 = 	(forward1_1==2'b01)?alures_MEM:
				(forward1_1==2'b10)?RFWr_data: 
				((AluSrc1_EX==1)?Ins_EX[10:6]:Op1_EX); // no forward Ins or Reg
        alu2 = (AluSrc2_EX==1)?Imm32_EX:Op2_reg; // Imm or reg (have been forwarded)
       
		// bcd
		//show = 16'h1234;
		show = (show_control==2'b00)?a0:
		(show_control==2'b01)?v0:
		(show_control==2'b10)?sp:
		ra;
		//led = PCout[7:0];
	end
	

endmodule
	