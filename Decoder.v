module Decoder(
    input clk,
    input rst,
    input regWrite,    // Register Write Enable
    input [31:0] inst,        // 32-bit Instruction Input
    input [31:0] writeData,   // Register Write Data Bus         
    output wire [31:0] rs1Data,    // Source Register 1 Output
    output wire [31:0] rs2Data,    // Source Register 2 Output
    output [31:0] imm32       // Sign-extended Immediate Output
);
parameter R = 7'b0110011, I = 7'b0010011, L = 7'b0000011, S = 7'b0100011, B = 7'b1100011;
parameter J = 7'b1101111, I_jalr = 7'b1100111, U_lui = 7'b0110111, U_auipc = 7'b0010111, I_sys = 7'b1110011;

reg [31:0] registers [0:31];  // x0 hardwired to 0 (write-protected)
wire rs1;
assign rs1 = registers[1]; // rs1Data is the value of the register specified by inst[19:15]

immGen ig(inst, imm32);

assign rs1Data = registers[inst[19:15]];   
assign rs2Data = registers[inst[24:20]];

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
