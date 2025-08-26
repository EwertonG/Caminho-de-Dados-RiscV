`timescale 1ns/1ps
module riscv_tb();

// sinais
reg clk;
reg rst;

// DUT
riscv uut (
    .clk(clk),
    .rst(rst)
);

// clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;

    // instruções de teste (ASM + binário)
    uut.instr = 32'b000000000100_00000_010_00001_0000011; #10; // lw x1, 4(x0)
    uut.instr = 32'b0000000_00010_00001_010_00011_0100011; #10; // sw x2, 0(x1)
    uut.instr = 32'b0000000_00010_00001_000_00100_0110011; #10; // add x4, x1, x2
    uut.instr = 32'b0000000_00010_00001_100_00101_0110011; #10; // xor x5, x1, x2
    uut.instr = 32'b0000000_00010_00001_001_00110_0110011; #10; // sll x6, x1, x2
    uut.instr = 32'b000000000101_00001_000_00111_0010011; #10; // addi x7, x1, 5
    uut.instr = 32'b0000000_00010_00001_001_00000_1100011; #10; // bne x1, x2, offset

    // imprime estado final
    $display("\n==== ESTADO FINAL ====");
    $display("PC = %0d", uut.pc);
    $display("x1 = %0d", uut.registers[1]);
    $display("x2 = %0d", uut.registers[2]);
    $display("x4 = %0d", uut.registers[4]);
    $display("x5 = %0d", uut.registers[5]);
    $display("x6 = %0d", uut.registers[6]);
    $display("x7 = %0d", uut.registers[7]);

    $finish;
end

endmodule