`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 12:03:59
// Design Name: 
// Module Name: Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define R 7'b0110011
`define I 7'b0010011
`define L 7'b0000011
`define S 7'b0100011
`define B 7'b1100011
`define J 7'b1101111
`define I_jalr 7'b1100111
`define U_lui 7'b0110111
`define U_auipc 7'b0010111
`define I_sys 7'b1110011

module Controller(
    input [31:0] inst,
    output reg [3:0] ALUOp,
    output reg [1:0] ALUSrc,
    output reg Branch, MemRead, MemWrite, MemtoReg, RegWrite
);

always @(*) begin  // ALUOp
    case (inst[6:0])
        `L, `S, `J, `I_jalr: ALUOp = 0;
        `B: begin
            case (inst[14:12])
                0: ALUOp = 8;  // beq
                1: ALUOp = 9;  // bne
                4: ALUOp = 10;  // blt
                5: ALUOp = 11;  // bge
                6: ALUOp = 12;  // bltu
                7: ALUOp = 13;  // bgeu
                default: ALUOp = 0;
            endcase
        end
        `R, `I: begin
            case (inst[14:12])
                0: begin
                    if (inst[31:25] == 7'h20) ALUOp = 1;  // sub
                    else ALUOp = 0;  // add
                end
                1: ALUOp = 2;  // sll
                2: ALUOp = 10;  // slt
                3: ALUOp = 12;  // sltu
                4: ALUOp = 5;  // xor
                5: begin
                    if (inst[31:25] == 7'h20) ALUOp = 4;  // sra
                    else ALUOp = 3;  // srl
                end
                6: ALUOp = 6;  // or
                7: ALUOp = 7;  // and
                default: ALUOp = 0;
            endcase
        end
        `U_lui, `U_auipc: ALUOp = 1;
        default: ALUOp = 0;
    endcase
end

always @(*) begin  // Branch
    case (inst[6:0])
        `B, `J, `I_jalr: Branch = 1;
        default: Branch = 0;
    endcase
end

always @(*) begin  // ALUSrc
    case (inst[6:0])
        `I, `L, `S, `U_lui: ALUSrc = 1;
        `U_auipc: ALUSrc = 2;
        default: ALUSrc = 0;
    endcase
end

always @(*) begin  // MemRead, MemtoReg
    if (inst[6:0] == `L) begin
        MemRead = 1;
        MemtoReg = 1;
    end
    else begin
        MemRead = 0;
        MemtoReg = 0;
    end
end

always @(*) begin  // RegWrite, MemWrite
    case (inst[6:0])
        `R, `I, `L, `J, `I_jalr, `U_lui, `U_auipc: begin
            RegWrite = 1;
            MemWrite = 0;
        end
        `S: begin
            RegWrite = 0;
            MemWrite = 1;
        end
        default: begin
            RegWrite = 0;
            MemWrite = 0;
        end
    endcase
end

endmodule
