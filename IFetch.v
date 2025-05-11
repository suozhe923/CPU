module IFetch(
    input clk, rst, branch, zero,
    input[31:0] imm32,
    output[31:0] inst,
    output reg [31:0] pc
    );

    prgrom urom(.clka(clk), .addra(pc[15:2]), .douta(inst));

    always@ (negedge clk or negedge rst) begin
        if(!rst) //initialize
            pc<= 32'b0;
        else if(branch & zero) //branch
            pc<=pc+imm32;
        else //Sequential execution
            pc<=pc+4;
    end

endmodule
