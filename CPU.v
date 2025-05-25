`timescale 1ns / 1ps
module CPU(
    input clk,rst,
    output wire [31:0] pc, // from IFetch to OpMux
    output wire [31:0] pcOld, // from IFetch to Decoder
    output wire [31:0] inst, // from IFetch to Decoder, Controller

    output wire branch, // from Controller(Branch) to IFetch
    output wire [3:0] ALUOp, //from Controller to ALU
    output wire [2:0] ALUSrc, // (determine op2) from Controller to OpMux
    output wire MemRead, // from Controller to DMem
    output wire MemWrite, // from Controller to DMem
    output wire MemtoReg, // from Controller to WriteMux
    output wire RegWrite, // from Controller to Decoder

    output wire [31:0] rs1Data,// from Decoder to ALU
    output wire [31:0] rs2Data, // from Decoder to OpMux, DMem
    output wire [31:0] imm32, //from Decoder to IFetch(<< 1 in IFetch), OpMux
    
    output wire [31:0] op1, op2, // from OpMux to ALU

    output wire [31:0] ALUResult, // from ALU to DMem and WriteMux
    output wire zero, // from ALU to IFetch

    output wire [31:0] dout, // from DMem to WriteMux

    output wire [31:0] writeData, // from WriteMux to Decoder

    output wire [31:0] rs1
    );

// First, at the posedge of clk, IFetch get instruction from prgrom
// Second, Controller update with instruction immediately
// Third, Decoder update the operands with instruction ; writeData at the next posedge of clk
// Fourth, ALU calculate the result with operands
// Fifth, DMem read/write with ALUResult and rs2Data at the negedge of clk
// Sixth, WriteMux update the writeData with ALUResult and dout

    IFetch ife(.clk(clk), .rst(rst), .branch(branch), .zero(zero), .imm32(imm32), .inst(inst), .pc(pc),.pcOld(pcOld),.rs1Data(rs1Data)); 
    Controller ctrl(.inst(inst), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .Branch(branch), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .RegWrite(RegWrite));
    Decoder dc (.clk(clk), .rst(rst), .regWrite(RegWrite), .inst(inst), .writeData(writeData), .pcOld(pcOld), .imm32(imm32), .rs1Data(rs1Data), .rs2Data(rs2Data),.rs1(rs1)); 
    ALUControl ac(.ALUSrc(ALUSrc), .rs1Data(rs1Data), .rs2Data(rs2Data), .imm32(imm32), .pc(pc), .op1(op1), .op2(op2));
    ALU alu(.op1(op1), .op2(op2), .ALUOp(ALUOp), .ALUResult(ALUResult), .zero(zero));
    DMem dm(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALUResult),.din(rs2Data), .dout(dout));
    WriteMux wc(.MemtoReg(MemtoReg), .ALUResult(ALUResult), .dout(dout), .writeData(writeData));
    
endmodule
