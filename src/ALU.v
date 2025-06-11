`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 12:03:59
// Design Name: 
// Module Name: ALU
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


module ALU(
    input signed [31:0] op1, op2,
    input [3:0] ALUOp,
    output reg [31:0] ALUResult,
    output reg zero
);

always @(*) begin
    case (ALUOp)
        0: ALUResult = op1 + op2;  // add
        1: ALUResult = op1 - op2;  // sub
        2: ALUResult = op1 << op2;  // sll
        3: ALUResult = op1 >> op2;  // srl
        4: ALUResult = op1 >>> op2;  // sra
        5: ALUResult = op1 ^ op2;  // xor
        6: ALUResult = op1 | op2;  // or
        7: ALUResult = op1 & op2;  // and
        8: ALUResult = (op1 == op2) ? 1 : 0;  // seq
        9: ALUResult = (op1 != op2) ? 1 : 0;  // sne
        10: ALUResult = (op1 < op2) ? 1 : 0;  // slt
        11: ALUResult = (op1 >= op2) ? 1 : 0;  // sge
        12: ALUResult = ($unsigned(op1) < $unsigned(op2)) ? 1 : 0;  // sltu
        13: ALUResult = ($unsigned(op1) >= $unsigned(op2)) ? 1 : 0;  // sgeu
        default: ALUResult = 0;
    endcase
    zero = (ALUResult) ? 0 : 1;
end

endmodule