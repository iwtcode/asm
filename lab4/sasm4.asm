section .data
    a dw 8318, -5676, 4239
    n db 3
    
    c dw -10000
    d dw 0
    
    count db 0
section .text
global main

main:
    mov rbp, rsp; for correct debugging
    
    mov ebx, 0
    @for_loop:
    mov ax, [a + ebx*2]
    inc bx
    cmp ax, 0
    
    jl @neg_true
    jmp @else
    
    @neg_true:
    mov cx, [c]
    cmp cx, ax
    jg @else
    
    mov cx, [d]
    cmp ax, cx
    jg @else
    
    movzx cx, byte[count]
    inc cx
    mov [count], cx
    
    @else:
    cmp bl, [n]
    jne @for_loop
    
    ret