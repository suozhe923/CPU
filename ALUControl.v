`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 22:56:08
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
    input [1:0] ALUSrc,
    input [31:0] regData2, imm, pc,
    output reg [31:0] op2
);
always @(*) begin
    case(ALUSrc)
        0: op2 = regData2;
        1: op2 = imm;
        2: op2 = pc;
        default: op2 = 0;
    endcase
end
endmodule
