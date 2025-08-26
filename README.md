# Caminho-de-Dados-RiscV

Simulador básico de instruções RISC-V implementado em Verilog.  
Inclui unidade de controle, registradores e testes via instruções codificadas.

## Participantes

Ewerton Gomes Barcia - 22.2.8066  
Ana Clara Francisca Barbosa - 22.2.8096

## Descrição

Implementação em Verilog de um caminho de dados simplificado baseado no conjunto de instruções RISC-V.  
O projeto simula instruções como `lw`, `sw`, `add`, `addi`, `xor`, `sll` e `bne`, com controle e testes em nível de registradores.

## Como rodar

Para simular este projeto, foi usado o Icarus Verilog e executado no terminal do Windows:

cd C:\TP02_RiscV
iverilog -o riscv_tb riscv.v
vvp riscv_tb
