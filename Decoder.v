
module Decoder(
    input clk,
    input rst,
    input regWrite,    // Register Write Enable
    input [31:0] inst,        // 32-bit Instruction Input
    input [31:0] writeData,   // Register Write Data Bus
    input [31:0] pcOld,          
    output reg [31:0] rs1Data,    // Source Register 1 Output
    output reg [31:0] rs2Data,    // Source Register 2 Output
    output [31:0] imm32,       // Sign-extended Immediate Output
    output [31:0] rs1
);
parameter R = 7'b0110011, I = 7'b0010011, L = 7'b0000011, S = 7'b0100011, B = 7'b1100011;
parameter J = 7'b1101111, I_jalr = 7'b1100111, U_lui = 7'b0110111, U_auipc = 7'b0010111, I_sys = 7'b1110011;

    reg [31:0] registers [0:31];  // x0 hardwired to 0 (write-protected)
    assign rs1 = registers[1]; // rs1Data is the value of the register specified by inst[19:15]

    // Immediate Generation Logic
    reg [31:0] imm32_reg;
    wire [6:0] opcode = inst[6:0];  // Opcode field (inst[6:0])

    always @(*) begin
        case(opcode)
            // B-type Instructions
            B: begin
                imm32_reg = ( {{20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]} )<<1;
                rs1Data = registers[inst[19:15]]; 
                rs2Data = registers[inst[24:20]]; 
            end

            // S-type Instructions
            S: begin
                imm32_reg = { {20{inst[31]}}, inst[31:25], inst[11:7] };
                rs1Data = registers[inst[19:15]]; 
                rs2Data = registers[inst[24:20]]; 
            end

            // I-type Instructions
            I, L : begin
                imm32_reg = { {20{inst[31]}}, inst[31:20] };
                rs1Data = registers[inst[19:15]]; 
                rs2Data = registers[inst[24:20]]; 
            end

            I_jalr: begin
                imm32_reg = { {20{inst[31]}}, inst[31:20] };
                rs1Data = registers[inst[19:15]];  
                rs2Data = pcOld+4-registers[inst[19:15]]; 
            end

            // J-type Instructions
            J: begin
                imm32_reg = ( {{13{inst[31]}}, inst[19:12], inst[20], inst[30:21]} ) <<1;
                rs1Data = pcOld+4;  
                rs2Data = 32'b0;  
                // jal instruction store pcOld+4 in rd
            end

            // U-type Instructions
            U_lui: begin
                imm32_reg = {inst[31:12], 12'b0};
                rs1Data = 32'b0;
                rs2Data = 32'b0;  
            end
            U_auipc:begin
                imm32_reg = {inst[31:12], 12'b0};
                rs1Data = pcOld;
                rs2Data = 32'b0;
            end



            default: begin 
                imm32_reg = 32'b0;
                rs1Data = registers[inst[19:15]];   
                rs2Data = registers[inst[24:20]];
            end

        endcase
    end
    assign imm32 = imm32_reg;

    // Synchronous Register Write
    integer i;
    always @(posedge clk or negedge rst) begin
        // Initialize all 32 registers to zero
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;  // Non-blocking assignment for synchronous reset
            end
        end

        else if (regWrite && (inst[11:7] != 5'b0)) begin
            // x0 is always 0.
            registers[inst[11:7]] <= writeData;
        end
    end

endmodule
