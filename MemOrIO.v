module MemOrIO(
    input clk, rst,

    input MemRead,  // read memory, from Controller
    input MemWrite,  // write memory, from Controller
    input ioRead,  // read IO, from Controller
    input ioWrite,  // write IO, from Controller

    input [31:0] addr_in,  // from ALUResult
    output [31:0] addr_out,  // address to DMem

    input [31:0] MemData,  // data read from DMem
    input [7:0] switch,  // data from little switch
    input [7:0] SWITCH,  // data from big switch
    input button,

    input [31:0] din,  // data read from Decoder(register file)
    output reg [31:0] dout,  // data to Decoder(register file)

    output reg [31:0] writeData,  // data to Memory
    output reg [7:0] LED,  // data to big LED
    output reg [7:0] led,  // data to little LED
    output reg [31:0] seg  // data to 7-segment tube
);

DMem m(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(addr_in), .din(writeData), .dout(MemData));

assign addr_out = addr_in;

// The data write to register file may be from memory or IO.
reg [31:0] ioData;  // data from IO

// Chip Select signal of LEDs and switches are all active high;
wire LEDCtrl, SwitchCtrl, ButtonCtrl, SegCtrl;
assign SwitchCtrl = (ioRead && (addr_in == 32'hFFFF0008 || addr_in == 32'hFFFF000C)) ? 1 : 0;
assign LEDCtrl = (ioWrite && (addr_in == 32'hFFFF0000 || addr_in == 32'hFFFF0004)) ? 1 : 0;
assign ButtonCtrl = (ioRead && addr_in == 32'hFFFF0010) ? 1 : 0;
assign SegCtrl = (ioWrite && addr_in == 32'hFFFF0014) ? 1 : 0;

// data written to reg
always @* begin
    if (MemRead || ioRead)
        dout = (MemRead) ? MemData : ioData;
    else
        dout = 32'h0;
end

// data written to Memory
always @* begin
    if (MemWrite || ioWrite)
        writeData = (MemWrite) ? din : ioData;
    else
        writeData = 32'h0;
end

// data from IO
always @(*) begin
    case (addr_in)
        32'hFFFF0008:  // Switchbig
            ioData = SwitchCtrl ? {24'h0, SWITCH} : 32'h0;
        32'hFFFF000C:  // Switchlittle
            ioData = SwitchCtrl ? {24'h0, switch} : 32'h0;
        32'hFFFF0010:  // Buttons
            ioData = ButtonCtrl ? {31'b0, button} : 32'h0;
    endcase
end

// data from Memory to IO
always @(*) begin
    if (!rst) begin
        LED <= 8'h0;
        led <= 8'h0;
        seg <= 32'h0;
    end
    else begin
        case (addr_in)
            32'hFFFF0000: begin  // LEDbig
                LED <= LEDCtrl ? MemData[7:0] : LED;
                led <= led;
                seg <= seg;
            end
            32'hFFFF0004: begin  // LEDlittle
                LED <= LED;
                led <= LEDCtrl ? MemData[7:0] : led;
                seg <= seg;
            end
            32'hFFFF0014: begin
                LED <= LED;
                led <= led;
                seg <= SegCtrl ? MemData : seg;
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
// Button: 0xFFFF0010 - 0xFFFF0013, 
// 7-Seg Tubes: 0xFFFF0014 - 0xFFFF0017
