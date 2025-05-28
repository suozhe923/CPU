module CPU(
    input clk_in, rst,
    input [7:0] switch,  // data from little switch
    input [7:0] SWITCH,  // data from big switch
    input button,

    output [7:0] LED,  // data to big LED
    output [7:0] led,  // data to little LED
    output [7:0] com,
    output [7:0] seg_out_left, seg_out_right
);

// First, at the posedge of clk, IFetch get instruction from prgrom
// Second, Controller update with instruction immediately
// Third, Decoder update the operands with instruction ; writeData at the next posedge of clk
// Fourth, ALU calculate the result with operands
// Fifth, DMem read/write with ALUResult and rs2Data at the negedge of clk
// Sixth, WriteMux update the writeData with ALUResult and dout

wire clk;
wire [31:0] pc; // from IFetch to OpMux
wire [31:0] pcOld; // from IFetch to Decoder
wire [31:0] inst; // from IFetch to Decoder, Controller

wire branch; // from Controller(Branch) to IFetch
wire [3:0] ALUOp; //from Controller to ALU
wire [2:0] ALUSrc; // (determine op2) from Controller to OpMux
wire MemRead; // from Controller to DMem
wire MemWrite; // from Controller to DMem
wire MemtoReg; // from Controller to WriteMux
wire RegWrite; // from Controller to Decoder
wire ioRead;
wire ioWrite;

wire [31:0] rs1Data;// from Decoder to ALU
wire [31:0] rs2Data; // from Decoder to OpMux, DMem
wire [31:0] imm32; //from Decoder to IFetch(<< 1 in IFetch), OpMux

wire [31:0] op1, op2; // from OpMux to ALU

wire [31:0] ALUResult; // from ALU to DMem and WriteMux
wire zero; // from ALU to IFetch

wire [31:0] dout; // from DMem to WriteMux

wire [31:0] writeData; // from WriteMux to Decoder

wire [31:0] segData; // data to 7-segment tube

cpuclk c(.clk_in1(clk_in), .cpu_clk(clk));
IFetch ife(.clk(clk), .rst(rst), .branch(branch), .zero(zero), .imm32(imm32), .inst(inst), .pc(pc),.pcOld(pcOld),.rs1Data(rs1Data)); 
Controller ctrl(.inst(inst), .addr(ALUResult), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .Branch(branch), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .ioRead(ioRead), .ioWrite(ioWrite));
Decoder dc (.clk(clk), .rst(rst), .regWrite(RegWrite), .inst(inst), .writeData(writeData), .imm32(imm32), .rs1Data(rs1Data), .rs2Data(rs2Data)); 
ALUControl ac(.ALUSrc(ALUSrc), .rs1Data(rs1Data), .rs2Data(rs2Data), .imm32(imm32), .pc(pc), .op1(op1), .op2(op2));
ALU alu(.op1(op1), .op2(op2), .ALUOp(ALUOp), .ALUResult(ALUResult), .zero(zero));
MemOrIO m(.clk(clk), .rst(rst), .MemRead(MemRead), .MemWrite(MemWrite), .ioRead(ioRead), .ioWrite(ioWrite), .addr_in(ALUResult), .din(rs2Data), .dout(dout), .LED(LED), .led(led), .seg(segData), .switch(switch), .SWITCH(SWITCH), .button(button));
WriteMux wc(.MemtoReg(MemtoReg), .ALUResult(ALUResult), .dout(dout), .writeData(writeData));
display_assign da(.clk(clk_in), .rst(rst), .data(segData), .com(com), .seg_out_left(seg_out_left), .seg_out_right(seg_out_right));
    
endmodule
