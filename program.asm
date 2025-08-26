    addi x1, x0, 7     
    addi x2, x0, 2     
    add  x5, x1, x2     
    sll  x6, x1, x2     
    bne  x1, x2, L1    
    addi x7, x0, 5      
L1:
    sw   x2, 0(x1)      
    lw   x3, 4(x0)      