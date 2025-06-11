module IFetch(
    input clk, rst, branch, zero,
    input [31:0] rs1Data, 
    input[31:0] imm32,
    output[31:0] inst,
    output reg [31:0] pc,
    output reg [31:0] pcOld
    );

    prgrom urom(.clka(clk), .addra(pc[15:2]), .douta(inst));
    // get instruction at the posedge of clk

    always@ (negedge clk or negedge rst) begin
        if(!rst) begin//initialize
            pcOld <= 32'b0;
            pc<= 32'b0;
        end
        else if(branch & ~zero) begin//branch
            pcOld <= pc;
            if (inst[6:0] != 7'b1100111) begin //besides jalr ,pc+=imm32
                pc<=pc+imm32;
            end else begin // for jalr, pc=rs1Data+imm32
                pc<=rs1Data+imm32;
            end
        end
        else begin //Sequential execution
            pc<=pc+4;
            pcOld <= pc;
        end
    end

endmodule
