module immGen(
    input [31:0] inst,
    output reg [31:0] imm
);

parameter R = 7'b0110011, I = 7'b0010011, L = 7'b0000011, S = 7'b0100011, B = 7'b1100011;
parameter J = 7'b1101111, I_jalr = 7'b1100111, U_lui = 7'b0110111, U_auipc = 7'b0010111, I_sys = 7'b1110011;

always @(*) begin
    case (inst[6:0])
        R: imm = 32'b0;
        I, L, I_jalr, I_sys: imm = { {20{inst[31]}}, inst[31:20] };
        S: imm = { {20{inst[31]}}, inst[31:25], inst[11:7] };
        B: imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
        J: imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 };
        U_lui, U_auipc: imm = { inst[31:12], 12'b0 };
        default: imm = 32'b0;
    endcase
end

endmodule
