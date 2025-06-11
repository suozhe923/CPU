/*
    Instructions for Use:
    In display_control(if exists or your control module):
    1. Connect `data` to your data output port. 
       Your data should be encoded refer to display_decode.
    2. Connect `com` to seg select signal port.
    3. Connect `seg_out` to tube select signal port.
*/

module display_assign(
    input clk, rst,
    input [31:0] data,
    output reg [7:0] com, seg_out
);

reg [2:0] dm;
reg [5:0] seg_in;
reg [16:0] counter;

// produce 1ms delay
// 100MHz clock: 10ns/period
// 10 * 100000 = 10^6 ns = 1ms
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
        0: seg_in = data[3:0];  // 8
        1: seg_in = data[7:4];  // 7
        2: seg_in = data[11:8];  // 6
        3: seg_in = data[15:12];  // 5
        4: seg_in = data[19:16];  // 4
        5: seg_in = data[23:20];  // 3
        6: seg_in = data[27:24];  // 2
        7: seg_in = data[31:28];  // 1
        default: seg_in = 6'b000000;  // default in blank
    endcase
end

always @(*) begin
    case (seg_in)
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
