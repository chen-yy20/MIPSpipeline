module RegMEM_WB(
    input reset, input clk, 
    input wire [31:0] AluRes_i,
    input wire [1:0] MemtoReg_i,
    input RegWr_i,
    output reg [31:0] AluRes_o,
    output reg [1:0] MemtoReg_o,
    output reg RegWr_o
    );
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            AluRes_o <= 0;
            MemtoReg_o <= 2'b00;
            RegWr_o <= 0;
        end 
        else begin
            AluRes_o <= AluRes_i;
            MemtoReg_o <= MemtoReg_i;
            RegWr_o <= RegWr_i;
        end
    end
endmodule