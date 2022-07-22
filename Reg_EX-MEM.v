`timescale 1ns / 1ps
module RegEX_MEM(
    input reset, input clk, 
    // calculate
    input wire [31:0] AluRes_i,
    input wire [31:0] Op2_i,
    input wire [31:0] PCp4_i,
    // control
    input wire ex_wr_i,
    input wire [1:0] ex_ano_i,
    input MemWr_i, 
    input MemRd_i,
    input ByteRd_i,
    input wire [1:0] MemtoReg_i,
    input RegWr_i,
    input wire [1:0] PCSrc_i,
    // pipeline
    input wire [31:0] Ins_i,
    input wire [4:0] Rf_i,
    // =========================================
    output reg [31:0] AluRes_o,
    output reg [31:0] Op2_o,
    output reg [31:0] PC_o,
    output reg ex_wr_o,
    output reg [1:0] ex_ano_o,
    output reg MemWr_o, 
    output reg MemRd_o,
    output reg ByteRd_o,
    output reg [1:0] MemtoReg_o,
    output reg RegWr_o,
    output reg [1:0] PCSrc_o,
    output reg [4:0] Rf_o,
    output reg [31:0] Ins_o
    );
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            AluRes_o <= 0;
            ex_wr_o <= 0;
            ex_ano_o <= 0;
            MemWr_o <= 0;
            MemRd_o <= 0;
            ByteRd_o <= 0;
            PC_o <= 0;
            MemtoReg_o <= 2'b00;
            RegWr_o <= 0;
            PCSrc_o <= 2'b00;
            Rf_o <= 0;
            Ins_o <= 0;
            Op2_o <= 0;
        end 
        else begin
            AluRes_o <= (ex_wr_i==1)?32'h40000010:AluRes_i;
            MemWr_o <= MemWr_i;
            MemRd_o <= MemRd_i;
            ByteRd_o <= ByteRd_i;
            PC_o <= PCp4_i -4;
            ex_wr_o <= ex_wr_i;
            ex_ano_o <= ex_ano_i;
            MemtoReg_o <= MemtoReg_i;
            RegWr_o <= RegWr_i;
            PCSrc_o <= PCSrc_i;
            Rf_o <= Rf_i;
            Ins_o <= Ins_i;
            Op2_o <= Op2_i;
        end
    end
endmodule