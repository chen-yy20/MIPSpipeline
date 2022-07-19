module RegEX_MEM(
    input reset, input clk, 
    // calculate
    input wire [31:0] AluRes_i,
    // control
    input MemWr_i, 
    input wire [1:0] MemtoReg_i,
    input RegWr_i,
    input wire [1:0] PCSrc_i,
    // pipeline
    input wire [31:0] Ins_i,
    input wire [4:0] Rf_i,
    output reg [31:0] AluRes_o,
    output reg MemWr_o, 
    output reg [1:0] MemtoReg_o,
    output reg RegWr_o,
    output reg [1:0] PCSrc_o,
    output reg [4:0] Rf_o,
    output reg [31:0] Ins_o
    );
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            AluRes_o <= 0;
            MemWr_o <= 0;
            MemtoReg_o <= 2'b00;
            RegWr_o <= 0;
            PCSrc_o <= 2'b00;
            Rf_o <= 0;
            Ins_o <= 0;
        end 
        else begin
            AluRes_o <= AluRes_i;
            MemWr_o <= MemWr_i;
            MemtoReg_o <= MemtoReg_i;
            RegWr_o <= RegWr_i;
            PCSrc_o <= PCSrc_i;
            Rf_o <= Rf_i;
            Ins_o <= Ins_i;
        end
    end
endmodule