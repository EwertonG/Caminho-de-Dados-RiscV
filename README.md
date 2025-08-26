# Caminho-de-Dados-RiscV

Simulador básico de instruções RISC-V implementado em Verilog.  
Inclui unidade de controle, registradores e testes via instruções codificadas.

## Participantes

Ewerton Gomes Barcia - 22.2.8066  
Ana Clara Francisca Barbosa - 22.2.8096

## Descrição

Este projeto consiste na implementação de uma unidade de controle RISC-V em Verilog capaz de decodificar e simular a execução de instruções como:

- `lw` (load word)  
- `sw` (store word)  
- `add`, `xor`, `sll` (operações aritméticas)  
- `addi` (add imediato)  
- `bne` (branch not equal)

## Como rodar

Para simular este projeto, foi usado o Icarus Verilog e executado no terminal do Windows:

cd C:\TP02_RiscV
iverilog -o riscv_tb riscv.v
vvp riscv_tb
