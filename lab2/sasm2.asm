section .data
    a dw 5
    b dw 6
    res dd ?
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    
    mov ax, [a]
    mov cx, [b]
    cmp ax, cx
    
    ; вариант 19
    ; (a == b) : a/(b-4)
    ; (a > b) : 64
    ; (a < b) : a*b+8
    
    je @uint_equal
    ja @uint_great
    jb @uint_less
    
    @uint_equal:
    xor eax, eax
    xor ecx, ecx
    mov ax, [b]
    cwd
    sbb eax, 4
    mov ecx, eax
    xor eax, eax
    mov ax, [a]
    cwd
    cdq
    idiv ecx
    mov [res], eax
    jmp @uint_exit
    
    @uint_great:
    xor eax, eax
    mov eax, 64
    mov [res], eax
    jmp @uint_exit
    
    @uint_less:
    cwd
    xor ecx, ecx
    mov ecx, eax
    mov eax, [b]
    cwd
    imul ecx
    adc eax, 8
    mov [res], eax
    jmp @uint_exit
    
    
    @uint_exit:
    ret