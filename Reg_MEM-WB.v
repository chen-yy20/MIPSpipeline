module RegMEM_WB(
    input reset, input clk, 
    input wire [31:0] Memdata_i, 
    input wire [31:0] AluRes_i,
    input wire [1:0] MemtoReg_i,
    input RegWr_i,
    input wire [4:0] Rf_i,
    output reg [31:0] Memdata_o,
    output reg [31:0] AluRes_o,
    output reg [1:0] MemtoReg_o,
    output reg RegWr_o,
    output reg Rf_o
    );
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            Memdata_o <= 0;
            AluRes_o <= 0;
            MemtoReg_o <= 2'b00;
            RegWr_o <= 0;
            Rf_o <= 0;
        end 
        else begin
            Memdata_o <= Memdata_i;
            AluRes_o <= AluRes_i;
            MemtoReg_o <= MemtoReg_i;
            RegWr_o <= RegWr_i;
            Rf_o <= Rf_i;
        end
    end
endmodule