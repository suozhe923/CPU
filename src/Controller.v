module Controller(
    input [31:0] inst, addr,
    output reg [3:0] ALUOp,
    output reg [2:0] ALUSrc,
    output reg Branch, MemRead, MemWrite, MemtoReg, RegWrite, ioRead, ioWrite, is_signed
);

parameter R = 7'b0110011, I = 7'b0010011, L = 7'b0000011, S = 7'b0100011, B = 7'b1100011;
parameter J = 7'b1101111, I_jalr = 7'b1100111, U_lui = 7'b0110111, U_auipc = 7'b0010111, I_sys = 7'b1110011;

always @(*) begin  // ALUOp
    case (inst[6:0])
        L, S, I_jalr, J, U_lui, U_auipc: ALUOp = 0;
        B: begin
            case (inst[14:12])
                0: ALUOp = 8;  // beq
                1: ALUOp = 9;  // bne
                4: ALUOp = 10;  // blt
                5: ALUOp = 11;  // bge
                6: ALUOp = 12;  // bltu
                7: ALUOp = 13;  // bgeu
                default: ALUOp = 0;
            endcase
        end
        R, I: begin
            case (inst[14:12])
                0: begin
                    if (inst[31:25] == 7'h20) ALUOp = 1;  // sub
                    else ALUOp = 0;  // add
                end
                1: ALUOp = 2;  // sll
                2: ALUOp = 10;  // slt
                3: ALUOp = 12;  // sltu
                4: ALUOp = 5;  // xor
                5: begin
                    if (inst[31:25] == 7'h20) ALUOp = 4;  // sra
                    else ALUOp = 3;  // srl
                end
                6: ALUOp = 6;  // or
                7: ALUOp = 7;  // and
                default: ALUOp = 0;
            endcase
        end
        default: ALUOp = 0;
    endcase
end

always @(*) begin  // Branch
    case (inst[6:0])
        B, J, I_jalr: Branch = 1;
        default: Branch = 0;
    endcase
end

always @(*) begin  // ALUSrc
    case (inst[6:0])
        I: begin
            if (inst[14:12] == 1 || inst[14:12] == 5) ALUSrc = 5;  // slli, srli, srai
            else ALUSrc = 1;  // other i-type
        end
        L, S: ALUSrc = 1;
        J, I_jalr: ALUSrc = 2;
        U_lui: ALUSrc = 3;
        U_auipc: ALUSrc = 4;
        default: ALUSrc = 0;
    endcase
end

always @(*) begin  // MemtoReg, MemRead, ioRead, is_signed
    case (inst[6:0])
        L: begin
            MemtoReg = 1;
            if (addr[31:16] == 16'hFFFF) begin
                MemRead = 0;
                ioRead = 1;
            end
            else begin
                MemRead = 1;
                ioRead = 0;
            end
            is_signed = inst[14:12] == 0 || inst[14:12] == 1;  // lw, lb, lbu
        end
        default: begin
            MemtoReg = 0;
            MemRead = 0;
            ioRead = 0;
            is_signed = 0;
        end
    endcase
end

always @(*) begin  // RegWrite, MemWrite, ioWrite
    case (inst[6:0])
        R, I, L, J, I_jalr, U_lui, U_auipc: begin
            RegWrite = 1;
            MemWrite = 0;
            ioWrite = 0;
        end
        S: begin
            RegWrite = 0;
            if (addr[31:16] == 16'hFFFF) begin
                MemWrite = 0;
                ioWrite = 1;
            end
            else begin
                MemWrite = 1;
                ioWrite = 0;
            end
        end
        default: begin
            RegWrite = 0;
            MemWrite = 0;
            ioWrite = 0;
        end
    endcase
end



endmodule
