section .data
    extern a, c, d, n, count
section .text
global asm_func

asm_func:
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