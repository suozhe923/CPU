module Decoder(
    input clk,
    input rst,
    input regWrite,
    input [31:0] inst,
    input [31:0] writeData,
    output [31:0] rs1Data,
    output [31:0] rs2Data,
    output [31:0] imm32
);

    reg [31:0] registers [0:31];
    assign rs1Data = registers[inst[19:15]];
    assign rs2Data = registers[inst[24:20]];

    reg [31:0] imm32_reg;
    wire [6:0] opcode = inst[6:0];

    always @(*) begin
        case(opcode)
            7'b1100011: begin
                imm32_reg = ( {{20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8] } ) << 1;
            end

            7'b0100011: begin
                imm32_reg = { {20{inst[31]}}, inst[31:25], inst[11:7] };
            end

            7'b0000011, 7'b0010011, 7'b1100111: begin
                imm32_reg = { {20{inst[31]}}, inst[31:20] };
            end

            default: imm32_reg = 32'b0;
        endcase
    end

    assign imm32 = imm32_reg;

    integer idx;
    always @(posedge clk) begin
        if (~rst) begin
            for (idx = 0; idx < 32; idx = idx + 1)
                registers[idx] <= 32'b0;
        end
        else if (regWrite && inst[11:7] != 0) begin
            registers[inst[11:7]] <= writeData;
        end
    end

endmodule
