section .data
    a dw -1
    b dw 65000
    d dw -2
    res dd ?
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    xor eax, eax
    xor ecx, ecx
    
    ;---dividend---
    ;-35/b+d-b
    mov ax, [b]
    cwd
    
    mov ecx, eax
    xor eax, eax
    mov eax, -35
    cdq
    idiv ecx
    
    xor ecx, ecx
    mov ecx, eax
    xor eax, eax
    mov ax, [d]
    cwd
    adc eax, ecx
    
    xor ecx, ecx
    mov ecx, eax
    xor eax, eax
    mov ax, [b]
    cwd
    sbb ecx, eax
    mov [res], ecx
    
    ;---divider---
    ;1+a*b/4
    xor eax, eax
    xor ecx, ecx
    mov ax, [a]
    cwd
    mov cx, [b]
    mul ecx
    
    mov ecx, 4
    div ecx
    inc eax
    xor ecx, ecx
    cwd
    mov ecx, eax
    
    ;---dividend/divider---
    xor eax, eax
    xor edx, edx
    mov eax, [res]
    cdq
    idiv ecx
    mov [res], eax
    
    ret