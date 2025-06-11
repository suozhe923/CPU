module WriteMux(
    input MemtoReg,
    input [31:0] ALUResult,
    input [31:0] dout,
    output reg [31:0] writeData
    );

    always @(*) begin
        if (MemtoReg) begin
            writeData = dout;
        end else begin
            writeData = ALUResult;
        end
    end

endmodule
