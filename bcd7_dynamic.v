`timescale 1ns / 1ps
module bcd_2_7seg(
        input wire [3:0] s1_data,
        input wire [3:0] s2_data,
        input wire [3:0] s3_data,
        input wire [3:0] s4_data,
        input wire clk,
        output reg [6:0] dout,
        output reg [3:0] ano
        );
    
    reg [3:0] data;
    reg [18:0] times;
    
    initial times = 0;
    initial ano = 4'b0000;
    
    always @ (posedge clk)
        begin
//            else if (stop) begin
//                ano <= 4'b1000; 
//                data <= s4_data;
//            end
        times <= times + 19'b1;
        case (times)
            19'd000000: begin ano <= 4'b0001; data <= s1_data; end
            19'd100000: begin ano <= 4'b0010; data <= s2_data; end
            19'd200000: begin ano <= 4'b0100; data <= s3_data; end
            19'd300000: begin ano <= 4'b1000; data <= s4_data; end
        endcase
        if(times == 400000)
            times <= 19'b0;
        end
            
    always @ (posedge clk)
    begin
        case(data)
            4'h0: dout <= 7'b0111111;
            4'h1: dout <= 7'b0000110;
            4'h2: dout <= 7'b1011011;
            4'h3: dout <= 7'b1001111;
            4'h4: dout <= 7'b1100110;
            4'h5: dout <= 7'b1101101;
            4'h6: dout <= 7'b1111101;
            4'h7: dout <= 7'b0000111;
            4'h8: dout <= 7'b1111111;
            4'h9: dout <= 7'b1101111; 
            4'hA: dout <= 7'b1110111;
            4'hB: dout <= 7'b1111100;
            4'hC: dout <= 7'b0111001;
            4'hD: dout <= 7'b1011110;
            4'hE: dout <= 7'b1111001;
            4'hF: dout <= 7'b1110001;
            default: dout <= 7'b0;
        endcase
    end
endmodule

