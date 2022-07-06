module clk_gen(
    clk, 
    reset, 
    new_clk
);

input           clk;
input           reset;
output reg      new_clk;

// 1Hz
parameter   CNT = 14'd50;

reg     [13:0]  count;

always @(posedge clk or posedge reset)
begin
    if(reset) begin
        new_clk <= 1'b0;
        count <= 14'd0;
    end
    else begin
        count <= (count==CNT-14'd1) ? 14'd0 : count + 14'd1;
        new_clk <= (count==14'd0) ? ~new_clk : new_clk;
    end
end

endmodule
