module Decoder(
    input clk,
    input rst,
    input regWrite,    // Register Write Enable
    input [31:0] inst,        // 32-bit Instruction Input
    input [31:0] writeData,   // Register Write Data Bus
    output [31:0] rs1Data,    // Source Register 1 Output
    output [31:0] rs2Data,    // Source Register 2 Output
    output [31:0] imm32       // Sign-extended Immediate Output
);
parameter R = 7'b0110011, I = 7'b0010011, L = 7'b0000011, S = 7'b0100011, B = 7'b1100011;
parameter J = 7'b1101111, I_jalr = 7'b1100111, U_lui = 7'b0110111, U_auipc = 7'b0010111, I_sys = 7'b1110011;

    reg [31:0] registers [0:31];  // x0 hardwired to 0 (write-protected)

    assign rs1Data = registers[inst[19:15]]; // inst[19:15] = rs1 field
    assign rs2Data = registers[inst[24:20]]; // inst[24:20] = rs2 field

    // Immediate Generation Logic
    reg [31:0] imm32_reg;
    wire [6:0] opcode = inst[6:0];  // Opcode field (inst[6:0])

    always @(*) begin
        case(opcode)
            // B-type Instructions
            B: begin
                imm32_reg = ( {{20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]} ) << 1;
            end

            // S-type Instructions
            S: begin
                imm32_reg = { {20{inst[31]}}, inst[31:25], inst[11:7] };
            end

            // I-type Instructions
            I, L, I_jalr: begin
                imm32_reg = { {20{inst[31]}}, inst[31:20] };
            end

            // U-type Instructions
            U_lui, U_auipc: begin
            imm32_reg = {inst[31:12], 12'b0};
        end

            // J-type Instructions
            J: begin
            imm32_reg = ( {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0} ) << 1;
        end

            default: imm32_reg = 32'b0;
        endcase
    end
    assign imm32 = imm32_reg;

    // Synchronous Register Write
    integer idx;
    always @(posedge clk or negedge rst) begin
        // Initialize all 32 registers to zero
        if (!rst) begin
            for (idx = 0; idx < 32; idx = idx + 1) begin
                registers[idx] <= 32'b0;  // Non-blocking assignment for synchronous reset
            end
        end

        else if (regWrite && (inst[11:7] != 5'b0)) begin
            // x0 is always 0.
            registers[inst[11:7]] <= writeData;
        end
    end

endmodule
