`timescale 1ns / 1ps
module ALU(in1, in2, ALUCtrl, Sign, out, zero);
input signed [31:0] in1;
input signed [31:0] in2;
input [4:0] ALUCtrl;
input Sign;
output reg signed[31:0] out;
output reg zero;

always @(*)
begin
    casez(ALUCtrl)
    // lw in1: $rs, in2: Imm16 Sign_ext
    // sw in1: $rs, in2: Imm16 Sign_ext
    // lui in1 $zero, in2: Imm16 Sign_ext
    // add/ addu/ addi/ addiu
    // jr/jalr
    5'd0:
    begin
        out = in1 + in2;
        zero = (out==0) ? 1:0;
    end
    // sub / subu/ beq
    5'd1:
    begin
        out = in1 - in2;
        zero = (out == 0)?1:0;
    end
    // and / andi
    5'd2:
    begin
        out = in1&in2;
        zero= (out == 0) ? 1:0;
    end
    // or
    5'd3:
    begin
        out = in1|in2;
        zero= (out == 0) ? 1:0;
    end
    // xor
    5'd4:
    begin
        out = in1^in2;
        zero = (out == 0) ? 1:0;
    end
    // nor
    5'd5: 
    begin
        out = ~(in1|in2);
        zero= (out == 0)?1:0;
    end
    // sll
    5'd6:
    begin
        out = in2<<in1;
        zero= (out == 0)?1:0;
    end
    // srl
    5'd7:
    begin
        out = in2>>in1;
        zero = (out == 0)?1:0;
    end
    // sra
    5'd8:
    begin
        out = in2>>>in1;
        zero = (out == 0)?1:0;
    end
    // slt/slti & sltu/sltiu
    5'd9:
    begin
        if(~Sign&&(in1[31]==1&&in2[31]==0)) 
            out = 0;
        else if(~Sign&&(in1[31]==0&&in2[31]==1))
            out = 1;
        else
            out = (in1<in2)?1:0;
        zero = (out == 0)?1:0;
    end
    // j / jal no use ALU?
    5'd10:
    begin
        out = 0;
        zero = 0;
    end
    // there must be some problem! 
    // bne
    5'd11:
    begin
        out = in1-in2;
        zero = (out ==0)?0:1;
    end
    // blez
    5'd12:
    begin
        out = in1;
        zero = (out>0)?0:1;
    end
    // bltz
    5'd13:
    begin
        out = in1;
        zero = (out<0)?1:0;
    end
    // bgtz
    5'd14:
    begin
        out = in1;
        zero = (out>0)?1:0;
    end
    default:
    begin
        out = 0;
        zero = 0;
    end
    endcase
end
endmodule