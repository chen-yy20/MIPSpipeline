module RegEX_MEM(
    input reset, input clk, 
    input wire [31:0] AluRes_i,
    input MemWr_i, 
    input Branch_i,
    input wire [1:0] MemtoReg_i,
    input RegWr_i,
    input wire [1:0] PCSrc_i,
    output reg [31:0] AluRes_o,
    output reg MemWr_o, 
    output reg Branch_o,
    output reg [1:0] MemtoReg_o,
    output reg RegWr_o,
    output reg [1:0] PCSrc_o);
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            AluRes_o <= 0;
            MemWr_o <= 0;
            Branch_o <= 0;
            MemtoReg_o <= 2'b00;
            RegWr_o <= 0;
            PCSrc_o <= 2'b00;
        end 
        else begin
            AluRes_o <= AluRes_i;
            MemWr_o <= MemWr_i;
            Branch_o <= Branch_i;
            MemtoReg_o <= MemtoReg_i;
            RegWr_o <= RegWr_i;
            PCSrc_o <= PCSrc_i;
        end
    end
endmodule