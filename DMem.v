module DMem(
    input clk,
    input MemRead,
    input MemWrite,
    input [1:0] load_type,
    input [31:0] addr,
    input [31:0] din,
    output wire [31:0] dout
);

    // Storage core
    wire [31:0] ram_out;
    reg [3:0] wea;
    reg [31:0] dina;

    // Write in register
    reg [1:0]  load_type_reg;
    reg [31:0] addr_reg, din_reg;
    always @(negedge clk) begin
        load_type_reg <= load_type;
        addr_reg      <= addr;
        din_reg       <= din;
    end

    // RAM
    RAM udram(
        .clka(~clk),
        .wea(wea),
        .addra(addr_reg[13:0]),
        .dina(dina),
        .douta(ram_out)
    );

    // Write register
    always @(*) begin
        if (MemWrite) begin
            case(load_type_reg)
                2'b00: wea = 4'b1111;
                2'b01: wea = addr_reg[1] ? 4'b1100 : 4'b0011;
                2'b10: begin
                    case(addr_reg[1:0])
                        2'b00: wea = 4'b0001;
                        2'b01: wea = 4'b0010;
                        2'b10: wea = 4'b0100;
                        2'b11: wea = 4'b1000;
                    endcase
                end
                default: wea = 4'b0000;
            endcase
        end else begin
            wea = 4'b0000;
        end
    end

    
    always @(*) begin
        case(load_type_reg)
            2'b01: dina = {2{din_reg[15:0]}};
            2'b10: dina = {4{din_reg[7:0]}};
            default: dina = din_reg;
        endcase
    end

    reg [31:0] selected_data;
    always @(*) begin
        if (MemRead) begin
            case(load_type)
                2'b00: selected_data = ram_out;
                2'b01: begin
                    if (addr[1])
                        selected_data = {16'b0, ram_out[31:16]};
                    else
                        selected_data = {16'b0, ram_out[15:0]};
                end
                2'b10: begin
                    case(addr[1:0])
                        2'b00: selected_data = {24'b0, ram_out[7:0]};
                        2'b01: selected_data = {24'b0, ram_out[15:8]};
                        2'b10: selected_data = {24'b0, ram_out[23:16]};
                        2'b11: selected_data = {24'b0, ram_out[31:24]};
                    endcase
                end
                default: selected_data = 32'h0;
            endcase
        end
        else begin
            selected_data = 32'h0;
        end
    end

    wire [31:0] sign_extended_data;
    assign sign_extended_data = 
        (load_type == 2'b01) ? {{16{selected_data[15]}}, selected_data[15:0]} :
        (load_type == 2'b10) ? {{24{selected_data[7]}}, selected_data[7:0]} :
        selected_data;

    reg [31:0] read_data_reg;
    always @(posedge clk) begin
        if (MemRead) 
            read_data_reg <= sign_extended_data;
        else
            read_data_reg <= 32'h0;
    end

    assign dout = read_data_reg;

endmodule
