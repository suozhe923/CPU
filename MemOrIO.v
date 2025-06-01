module MemOrIO(
    input clk, rst,

    input MemRead,  // read memory, from Controller
    input MemWrite,  // write memory, from Controller
    input ioRead,  // read IO, from Controller
    input ioWrite,  // write IO, from Controller
    input is_signed,  // signed or not, from Controller

    input [31:0] addr_in,  // from ALUResult

    input [7:0] switch,  // data from little switch
    input [7:0] SWITCH,  // data from big switch
    input button0, button1, button2, button3,

    input [31:0] din,  // data read from Decoder(register file)
    output reg [31:0] dout,  // data to Decoder(register file)

    output reg [7:0] LED,  // data to big LED
    output reg [7:0] led,  // data to little LED
    output reg [31:0] seg  // data to 7-segment tube
);

wire [31:0] MemData;
DMem m(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(addr_in), .din(din), .dout(MemData));

// The data write to register file may be from memory or IO.
reg [31:0] ioData;  // data from IO

// Chip Select signal of LEDs and switches are all active high;
wire LEDCtrl, SwitchCtrl, ButtonCtrl, SegCtrl;
assign SwitchCtrl = (ioRead && (addr_in == 32'hFFFF0008 || addr_in == 32'hFFFF000C)) ? 1 : 0;
assign LEDCtrl = (ioWrite && (addr_in == 32'hFFFF0000 || addr_in == 32'hFFFF0004)) ? 1 : 0;
assign ButtonCtrl = (ioRead && (addr_in == 32'hFFFF0010 || addr_in == 32'hFFFF0014 || addr_in == 32'hFFFF0018 || addr_in == 32'hFFFF001C)) ? 1 : 0;
assign SegCtrl = (ioWrite && addr_in == 32'hFFFF0020) ? 1 : 0;

// data written to reg
always @* begin
    if (MemRead || ioRead)
        dout = (MemRead) ? MemData : ioData;
    else
        dout = 32'h0;
end

// data from IO
always @(*) begin
    case (addr_in)
        32'hFFFF0008:  // Switchbig
            ioData = SwitchCtrl ? is_signed ? {{24{SWITCH[7]}}, SWITCH} : {24'h0, SWITCH} : 32'h0;
        32'hFFFF000C:  // Switchlittle
            ioData = SwitchCtrl ? is_signed ? {{24{switch[7]}}, switch} : {24'h0, switch} : 32'h0;
        32'hFFFF0010:  // Button0
            ioData = ButtonCtrl ? {31'h0, button0} : 32'h0;
        32'hFFFF0014:  // Button1
            ioData = ButtonCtrl ? {31'h0, button1} : 32'h0;
        32'hFFFF0018:  // Button2
            ioData = ButtonCtrl ? {31'h0, button2} : 32'h0;
        32'hFFFF001C:  // Button3
            ioData = ButtonCtrl ? {31'h0, button3} : 32'h0;
        default: ioData = 32'h0;
    endcase
end

// data from Memory to IO
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        LED <= 8'h0;
        led <= 8'h0;
        seg <= 32'h0;
    end
    else begin
        case (addr_in)
            32'hFFFF0000: begin  // LEDbig
                LED <= LEDCtrl ? din[7:0] : LED;
                led <= led;
                seg <= seg;
            end
            32'hFFFF0004: begin  // LEDlittle
                LED <= LED;
                led <= LEDCtrl ? din[7:0] : led;
                seg <= seg;
            end
            32'hFFFF0020: begin  // 7-Seg Tubes
                LED <= LED;
                led <= led;
                seg <= SegCtrl ? din : seg;
            end
            default: begin
                LED <= LED;
                led <= led;
                seg <= seg;
            end
        endcase
    end
end

endmodule


// LEDbig: 0xFFFF0000 - 0xFFFF0003
// LEDlittle: 0xFFFF0004 - 0xFFFF0007
// Switchbig: 0xFFFF0008 - 0xFFFF000B
// Switchlittle: 0xFFFF000C - 0xFFFF000F
// Button0: 0xFFFF0010 - 0xFFFF0013
// Button1: 0xFFFF0014 - 0xFFFF0017
// Button2: 0xFFFF0018 - 0xFFFF001B
// Button3: 0xFFFF001C - 0xFFFF001F
// 7-Seg Tubes: 0xFFFF0020 - 0xFFFF0023
