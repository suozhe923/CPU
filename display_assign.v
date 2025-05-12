`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 16:57:15
// Design Name: 
// Module Name: display_assign
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
    In display_control(if exists or your control module):
    1. Connect `content` to your data output port. 
       Your content should be encoded refer to display_decode.
    2. Connect `com` to seg select signal port.
*/

module display_assign(
    input clk, rst,
    input [47:0] content,
    output reg [5:0] seg_in,
    output reg [7:0] com
);

reg [1:0] dm;
reg [16:0] counter;

// produce 1ms delay
always @(posedge clk or negedge rst)
  begin
    if (~rst)
      counter <= 0;
    else if (counter == 99_999)
      counter <= 0;
    else 
      counter <= counter + 1;
  end

// for every 1ms delay, dm++ to switch between different seg.
always @(posedge clk or negedge rst)
  begin
    if (!rst)
      dm <= 0;
    else if ((counter == 99_999) && (dm == 7))
      dm <= 0;
    else if (counter == 99_999)
      dm <= dm + 1;
    else 
      dm <= dm;
  end

// for every dm, choose a seg to display.
always @(*) begin
    case (dm)
        0: com = 8'b00000001;
        1: com = 8'b00000010;
        2: com = 8'b00000100;
        3: com = 8'b00001000;
        4: com = 8'b00010000;
        5: com = 8'b00100000;
        6: com = 8'b01000000;
        7: com = 8'b10000000;
        default: com = 8'b00000000;
    endcase
end

// for every dm, pass the corresponding value to seg.
always @(*) begin
    case (dm)  // choose (8-dm)th seg
        0: seg_in = content[5:0];  // 8
        1: seg_in = content[11:6];  // 7
        2: seg_in = content[17:12];  // 6
        3: seg_in = content[23:18];  // 5
        4: seg_in = content[29:24];  // 4
        5: seg_in = content[35:30];  // 3
        6: seg_in = content[41:36];  // 2
        7: seg_in = content[47:42];  // 1
        default: seg_in = 6'b000000;  // default in blank
    endcase
end

endmodule
