`timescale 1ns / 1ps
module CPU(
    input clk,rst
    );
    wire [31:0] pc; // from IFetch to OpMux
    wire [31:0] inst; // from IFetch to Decoder, Controller

    wire [31:0] rs1Data;// from Decoder to ALU
    wire [31:0] rs2Data; // from Decoder to OpMux, Dmem
    wire [31:0] imm32; //from Decoder to IFetch(<< 1 in IFetch), OpMux
    
    wire branch; // from Controller(Branch) to IFetch
    wire [3:0] ALUOp; //from Controller to ALU
    wire [1:0] ALUSrc; // (determine op2) from Controller to OpMux
    wire MemRead; // from Controller to Dmem
    wire MemWrite; // from Controller to Dmem
    wire MemtoReg; // from Controller to WriteMux
    wire RegWrite; // from Controller to Decoder

    wire [31:0] op2; // from OpMux to ALU

    wire [31:0] ALUResult; // from ALU to Dmem and WriteMux
    wire zero; // from ALU to IFetch

    wire [31:0] dout; // from Dmem to WriteMux

    wire [31:0] writeData; // from WriteMux to Decoder


    IFetch ife(.clk(clk), .rst(rst), .branch(branch), .zero(zero), .imm32(imm32), .inst(inst), .pc(pc)); //finish
    Decoder dc (.clk(clk), .rst(rst), .regWrite(RegWrite), .inst(inst), .writeData(writeData), .imm32(imm32), .rs1Data(rs1Data), .rs2Data(rs2Data)); //finish
    Controller ctrl(.inst(inst), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .Branch(branch), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .RegWrite(RegWrite));
    OpMux om(.ALUSrc(ALUSrc), .rs2Data(rs2Data), .imm(imm32), .pc(pc), .op2(op2));
    ALU alu(.op1(rs1Data), .op2(op2), .ALUOp(ALUOp), .ALUResult(ALUResult), .zero(zero));
    DMem dm(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALUResult),.din(rs2Data), .dout(dout));
    WriteMux wc(.MemtoReg(MemtoReg), .ALUResult(ALUResult), .dout(dout), .writeData(writeData));


    
endmodule
