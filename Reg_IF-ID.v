module RegIF_ID(
    input reset, input clk,input stay,input null,
    input wire [31:0] PCp4_i, 
    input wire [31:0] ins_i;
    output reg [31:0] PCp4_o;
    output reg [31:0] ins_o;
    );
    
    always@(posedge reset or posedge clk) begin
        if (reset||null) begin
            PCp4_o <= 32'b0;
            ins_o <= 32'b0;        
            end 
        else if (stay==0) begin
            PCp4_o <= PCp4_i;
            ins_o <= ins_i;
            end
        
    end
endmodule