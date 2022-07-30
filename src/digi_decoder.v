`timescale 1ns / 1ps
module Digi_decoder(
    input wire [31:0] v0,
    input wire [1:0] ano,
    output reg [11:0] code_o
);
wire [3:0] num;
assign num =(ano == 2'b00)?v0[3:0]:
            (ano == 2'b01)?v0[7:4]:
            (ano == 2'b10)?v0[11:8]:
            v0[15:12];
always @(*)
begin
    code_o[7] <= 0;
    casez(num)
            4'h0: code_o[6:0] <= 7'b0111111;
            4'h1: code_o[6:0] <= 7'b0000110; //TODO
            4'h2: code_o[6:0] <= 7'b1011011;
            4'h3: code_o[6:0] <= 7'b1001111;
            4'h4: code_o[6:0] <= 7'b1100110;
            4'h5: code_o[6:0] <= 7'b1101101;
            4'h6: code_o[6:0] <= 7'b1111101;
            4'h7: code_o[6:0] <= 7'b0000111;
            4'h8: code_o[6:0] <= 7'b1111111;
            4'h9: code_o[6:0] <= 7'b1101111; 
            4'hA: code_o[6:0] <= 7'b1110111;
            4'hB: code_o[6:0] <= 7'b1111100;
            4'hC: code_o[6:0] <= 7'b0111001;
            4'hD: code_o[6:0] <= 7'b1011110;
            4'hE: code_o[6:0] <= 7'b1111001;
            4'hF: code_o[6:0] <= 7'b1110001;
            default: code_o[6:0] <= 7'b0;
        endcase
    casez(ano)
        2'b00: code_o[11:8] <= 4'b0001;
        2'b01: code_o[11:8] <= 4'b0010;
        2'b10: code_o[11:8] <= 4'b0100;
        2'b11: code_o[11:8] <= 4'b1000;
        default: code_o[11:8] <= 4'b0;
    endcase
end


endmodule