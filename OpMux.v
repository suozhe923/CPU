module OpMux(
    input [1:0] ALUSrc,
    input [31:0] rs2Data, imm32, pc,
    output reg [31:0] op2
);
always @(*) begin
    case(ALUSrc)
        0: op2 = rs2Data;
        1: op2 = imm32;
        2: op2 = pc;
        default: op2 = 0;
    endcase
end
endmodule
