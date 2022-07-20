`timescale 1ns / 1ps
module ALUControl(Opcode, Funct, ALUCtrl, Sign);
input [5:0] Opcode;
input [5:0] Funct;
output reg [4:0] ALUCtrl;
output reg Sign;

always@(*)
begin
casez(Opcode)
6'h23:
begin
    ALUCtrl = 5'd0;
    Sign =1;
end
6'h2b:
begin
    ALUCtrl = 5'd0;
    Sign = 1;
end
6'h0f:
begin
    ALUCtrl = 5'd0;
    Sign = 0;
end
6'h0:
begin
    casez(Funct)
    6'h20:
    begin
        ALUCtrl = 5'd0;
        Sign = 1;
    end
    6'h21:
    begin
        ALUCtrl = 5'd0;
        Sign = 0;
    end
    6'h22:
    begin
        ALUCtrl = 5'd1;
        Sign = 1;
    end
    6'h23:
    begin
        ALUCtrl = 5'd1;
        Sign = 0;
    end
    6'h24:
    begin
        ALUCtrl = 5'd2;
        Sign = 1;
    end
    6'h25:
    begin
        ALUCtrl = 5'd3;
        Sign = 1;
    end
    6'h26:
    begin
        ALUCtrl = 5'd4;
        Sign = 1;
    end
    6'h27:
    begin
        ALUCtrl = 5'd5;
        Sign = 1;
    end
    6'h0:
    begin
        ALUCtrl = 5'd6;
        Sign = 0;
    end
    6'h02:
    begin
        ALUCtrl = 5'd7;
        Sign = 0;
    end
    6'h03:
    begin
        ALUCtrl = 5'd8;
        Sign = 1;
    end
    6'h2a:
    begin
        ALUCtrl = 5'd9;
        Sign = 1;
    end
    6'h2b:
    begin
        ALUCtrl = 5'd9;
        Sign = 0;
    end
    6'h08:
    begin
        ALUCtrl = 5'd0;
        Sign =1;
    end
    6'h09:
    begin
        ALUCtrl = 5'd0;
        Sign = 1;
    end
    endcase
end
6'h08:
begin
    ALUCtrl = 5'd0;
    Sign = 1;
end
6'h09:
begin
    ALUCtrl = 5'd0;
    Sign = 0;
end
6'h0c:
begin
    ALUCtrl = 5'd2;
    Sign = 1;
end
6'h0a:
begin
    ALUCtrl=5'd9;
    Sign = 1;
end
6'h0b:
begin
    ALUCtrl = 5'd9;
    Sign = 0;
end
6'h04:
begin
    ALUCtrl = 5'd1;
    Sign = 1;
end
6'h02:
begin
    ALUCtrl = 5'd10;
    Sign = 1;
end
4'h03:
begin
    ALUCtrl = 5'd10;
    Sign = 1;
end
endcase
end

endmodule
