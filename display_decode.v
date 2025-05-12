`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 16:57:15
// Design Name: 
// Module Name: display_decode
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


/*
    Instructions for Use:
    Connect `seg_out` to the tube control signal.
*/

module display_decode(
    input [5:0] data_in,
    output reg [7:0] seg_out
);

display_assign da(.seg_in(data_in));

always @(data_in) begin
    case (data_in)
        0: seg_out = 8'b11111100;  // 0
        1: seg_out = 8'b01100000;  // 1
        2: seg_out = 8'b11011010;  // 2
        3: seg_out = 8'b11110010;  // 3
        4: seg_out = 8'b01100110;  // 4
        5: seg_out = 8'b10110110;  // 5
        6: seg_out = 8'b10111110;  // 6
        7: seg_out = 8'b11100000;  // 7
        8: seg_out = 8'b11111110;  // 8
        9: seg_out = 8'b11100110;  // 9
        10: seg_out = 8'b11101110;  // A
        11: seg_out = 8'b00111110;  // B
        12: seg_out = 8'b10011100;  // C
        13: seg_out = 8'b01111010;  // D
        14: seg_out = 8'b10011110;  // E
        15: seg_out = 8'b10001110;  // F
        16: seg_out = 8'b10111100;  // G
        17: seg_out = 8'b00101110;  // H(looks like 'h')
        18: seg_out = 8'b00001100;  // I(vertical at left)
        19: seg_out = 8'b01110000;  // J
        20: seg_out = 8'b00011110;  // K(looks like 't')
        21: seg_out = 8'b00011100;  // L
        22: seg_out = 8'b11101100;  // M(looks like high 'n')
        23: seg_out = 8'b00101010;  // N(looks like 'n')
        24: seg_out = 8'b00111010;  // O(looks like 'o')
        25: seg_out = 8'b11001110;  // P
        26: seg_out = 8'b11100110;  // Q(looks like 'q')
        27: seg_out = 8'b00001010;  // R(looks like 'r')
        28: seg_out = 8'b10110100;  // S
        29: seg_out = 8'b10001100;  // T
        30: seg_out = 8'b01111100;  // U
        31: seg_out = 8'b01001110;  // V
        32: seg_out = 8'b00111000;  // W(looks like 'u')
        33: seg_out = 8'b01101110;  // X
        34: seg_out = 8'b01110110;  // Y(looks like 'y')
        35: seg_out = 8'b11011000;  // Z
        36: seg_out = 8'b00000000;  // blank
        default: seg_out = 8'b00000000;  // default in blank
    endcase
end

endmodule
