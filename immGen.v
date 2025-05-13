`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 18:04:25
// Design Name: 
// Module Name: immGen
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


module immGen(
    input [31:0] inst,
    output reg [31:0] imm
);

always @(*) begin
    if (inst[6:0] == 7'b0110011) begin  // R
        imm = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    end
    else if (inst[6:0] == 7'b0010011 || inst[6:0] == 7'b0000011 || inst[6:0] == 7'b1100111 || inst[6:0] == 7'b1110011) begin  // I
        imm[11:0] = inst[31:20];
        if (~inst[31:31])
            imm[31:12] = 20'b0000_0000_0000_0000_0000;
        else
            imm[31:12] = 20'b1111_1111_1111_1111_1111;
    end
    else if (inst[6:0] == 7'b0100011) begin  // S
        imm[11:5] = inst[31:25];
        imm[4:0] = inst[11:7];
        if (~inst[31:31])
            imm[31:12] = 20'b0000_0000_0000_0000_0000;
        else
            imm[31:12] = 20'b1111_1111_1111_1111_1111;
    end
    else if (inst[6:0] == 7'b1100011) begin  // B
        imm[12:12] = inst[31:31];
        imm[10:5] = inst[30:25];
        imm[4:1] = inst[11:8];
        imm[11:11] = inst[7:7];
        imm[0:0] = 1'b0;
        if (~inst[31:31])
            imm[31:13] = 19'b000_0000_0000_0000_0000;
        else
            imm[31:13] = 19'b111_1111_1111_1111_1111;
    end
    else if (inst[6:0] == 7'b0110111) begin  // U
        imm[31:12] = inst[31:12];
        imm[11:0] = 12'b0000_0000_0000;
    end
    else if (inst[6:0] == 7'b1101111) begin  // J
        imm[20:20] = inst[31:31];
        imm[10:1] = inst[30:21];
        imm[11:11] = inst[20:20];
        imm[19:12] = inst[19:12];
        imm[0:0] = 1'b0;
        if (~inst[31:31])
            imm[31:21] = 11'b000_0000_0000;
        else
            imm[31:21] = 11'b111_1111_1111;
    end
    else begin
        imm = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    end
end

endmodule
