`timescale 1ns / 1ps

module IFetch(
    input clk,
    input rst,
    input branch,
    input zero,
    input [31:0] imm32,
    output [31:0] inst
);

reg [31:0] pc;
wire [13:0] rom = pc[15:2];

prgrom urom (
    .clka(clk),
    .addra(rom),
    .douta(inst)
);

always @(negedge clk) begin
    if (~rst)
        pc <= 32'h0000_0000;
    else begin
        case ({branch, zero})
            2'b11: pc <= pc + imm32;
            default: pc <= pc + 4;
        endcase
    end
end

endmodule
