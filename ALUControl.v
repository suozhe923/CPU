module ALUControl(
    input [2:0] ALUSrc,
    input [31:0] rs1Data, rs2Data, imm32, pc,
    output reg [31:0] op1, op2
);
always @(*) begin
    case (ALUSrc)
        0: begin  // common
            op1 = rs1Data;
            op2 = rs2Data;
        end
        1 : begin  // I-type
            op1 = rs1Data;
            op2 = imm32;
        end
        2: begin  // jal/jalr
            op1 = pc;
            op2 = 4;
        end
        3: begin  // lui
            op1 = 0;
            op2 = imm32;
        end
        4: begin  // auipc
            op1 = pc;
            op2 = imm32;
        end
        default: begin
            op1 = 0;
            op2 = 0;
        end
    endcase
end
endmodule
