module RegIF_ID(
    input reset, input clk,
    input wire [31:0] PCp4_i, 
    input wire [31:0] ins_i;
    output reg [31:0] PCp4_o;
    output reg [31:0] ins_o;
    );
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            PCp4_o <= 32'b0;
            ins_o <= 32'b0;        end 
        else begin
            PCp4_o <= PCp4_i;
            ins_o <= ins_i;
        end
    end
endmodule