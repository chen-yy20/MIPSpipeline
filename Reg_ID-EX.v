module RegID_EX(
    input reset, input clk, 
    input wire [31:0] PCp4_i,
    // calculate signals 
    input wire [31:0] Op1_i;
    input wire [31:0] Op2_i;
    input wire [31:0] Imm_i
    input wire [31:0] Ins_i;
    // control signals
    input wire ALUSrc1_i,
    input wire ALUSrc2_i,
    input wire [4:0] ALUCtrl_i,
    input wire Sign_i,
    input wire [1:0] RegDst_i,
    input MemWr_i, 
    input Branch_i,
    input wire [1:0] MemtoReg_i,
    input RegWr_i,
    input wire [1:0] PCSrc_i,
    input LuOp_i,
    // forward
    input wire [4:0] Rs_i,
    input wire [4:0] Rt_i,
    input wire [4:0] Rd_i,
    // ======================================
    output reg [31:0] Op1_o;
    output reg [31:0] Op2_o;
    output reg [31:0] Imm_o;
    output reg [31:0] Ins_o;
    output reg [31:0] PCp4_o,
    output reg ALUSrc1_o,
    output reg ALUSrc2_o,
    output reg [4:0] ALUCtrl_o,
    output reg Sign_0,
    output reg [1:0] RegDst_o,
    output reg MemWr_o, 
    output reg Branch_o,
    output reg [1:0] MemtoReg_o,
    output reg RegWr_o,
    output reg [1:0] PCSrc_o,
    output reg LuOp_o
    output reg [4:0] Rs_o,
    output reg [4:0] Rt_o,
    output reg [4:0] Rd_o
    );
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            Op1_o <= 0;
            Op2_o <= 0;
            Imm_o <= 0;
            Ins_o <= 0;
            PCp4_o <= 32'b0; 
            ALUSrc1_o <= 0;
            ALUSrc2_o <= 0;
            ALUCtrl_o <= 0;
            Sign_o <= 0;
            RegDst_o <= 2'b00;
            MemWr_o <= 0;
            Branch_o <= 0;
            MemtoReg_o <= 2'b00;
            RegWr_o <= 0;
            PCSrc_o <= 2'b00;
            LuOp_o <= 0;
            Rs_o <= 0;
            Rt_o <= 0;
            Rd_o <= 0;
        end 
        else begin
            Op1_o <= Op1_i;
            Op2_o <= Op2_i;
            Imm_o <= Imm_i;
            Ins_o <= Ins_i;
            PCp4_o <= PCp4_i;
            ALUSrc1_o <= ALUSrc1_i;
            ALUSrc2_o <= ALUSrc2_i;
            ALUCtrl_o <= ALUCtrl_i;
            Sign_o <= Sign_i;
            RegDst_o <= RegDst_i;
            MemWr_o <= MemWr_i;
            Branch_o <= Branch_i;
            MemtoReg_o <= MemtoReg_i;
            RegWr_o <= RegWr_i;
            PCSrc_o <= PCSrc_i;
            LuOp_o <= LuOp_i;
            Rs_o <= Rs_i;
            Rt_o <= Rt_i;
            Rt_o <= Rt_i;
        end
    end
endmodule