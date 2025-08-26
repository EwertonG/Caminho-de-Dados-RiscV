module riscv(
    input wire clk,
    input wire rst
);

// Registradores
reg [31:0] registers [0:31];
reg [31:0] memory [0:255];
reg [31:0] pc;
reg [31:0] instr;

// Sinais de controle
reg RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch;
reg [1:0] ALUOp;

// Saídas do decoder
wire [6:0] opcode = instr[6:0];
wire [4:0] rd     = instr[11:7];
wire [2:0] funct3 = instr[14:12];
wire [4:0] rs1    = instr[19:15];
wire [4:0] rs2    = instr[24:20];
wire [6:0] funct7 = instr[31:25];

// Unidade de Controle
always @(*) begin
    case (opcode)
        // lw
        7'b0000011: {RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} =
                    {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 2'b00};
        // sw
        7'b0100011: {RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} =
                    {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00};
        // add, xor, sll
        7'b0110011: {RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} =
                    {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10};
        // addi
        7'b0010011: {RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} =
                    {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10};
        // bne
        7'b1100011: {RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} =
                    {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01};
        default:     {RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} = 9'b0;
    endcase
end

// Execução simples
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 0;
    end else begin
        case (opcode)
            7'b0000011: // lw
                $display("LW x%0d, %0d(x%0d)", rd, {{20{instr[31]}}, instr[31:20]}, rs1);
            7'b0100011: // sw
                $display("SW x%0d, %0d(x%0d)", rs2, {{20{instr[31]}}, {instr[31:25], instr[11:7]}}, rs1);
            7'b0110011: begin
                case ({funct7,funct3})
                    10'b0000000000: $display("ADD x%0d, x%0d, x%0d", rd, rs1, rs2);
                    10'b0000000100: $display("XOR x%0d, x%0d, x%0d", rd, rs1, rs2);
                    10'b0000000001: $display("SLL x%0d, x%0d, x%0d", rd, rs1, rs2);
                endcase
            end
            7'b0010011: // addi
                $display("ADDI x%0d, x%0d, %0d", rd, rs1, {{20{instr[31]}}, instr[31:20]});
            7'b1100011: // bne
                $display("BNE x%0d, x%0d, %0d", rs1, rs2, {{20{instr[31]}}, {instr[7], instr[30:25], instr[11:8], 1'b0}});
            default:
                $display("Instrucao nao reconhecida: %b", instr);
        endcase

        // PC incrementa
        pc <= pc + 4;
    end
end

endmodule
