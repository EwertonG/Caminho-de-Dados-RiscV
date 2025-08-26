module riscv;

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

// Execução simples (apenas mostra o que seria feito)
always @(posedge clk) begin
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
end

// Clock de simulação
reg clk = 0;
always #5 clk = ~clk;

// Programa de teste
initial begin
    pc = 0;

    // Instruções de teste
    instr = 32'b000000000100_00000_010_00001_0000011; #10; // lw x1, 4(x0)
    instr = 32'b0000000_00010_00001_010_00011_0100011; #10; // sw x2, 0(x1)
    instr = 32'b0000000_00010_00001_000_00100_0110011; #10; // add x4, x1, x2
    instr = 32'b0000000_00010_00001_100_00101_0110011; #10; // xor x5, x1, x2
    instr = 32'b0000000_00010_00001_001_00110_0110011; #10; // sll x6, x1, x2
    instr = 32'b000000000101_00001_000_00111_0010011; #10; // addi x7, x1, 5
    instr = 32'b0000000_00010_00001_001_00000_1100011; #10; // bne x1, x2, offset

    $finish;
end

endmodule