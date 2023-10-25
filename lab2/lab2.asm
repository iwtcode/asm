section .data
    extern a_i
    extern b_i
    extern res_i

    extern a_ui
    extern b_ui
    extern res_ui
section .text

global int16_asm
global uint16_asm

; вариант 19
; (a == b) : a/(b-4)
; (a > b) : 64
; (a < b) : a*b+8

int16_asm:
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    
    mov ax, [a_i]
    mov cx, [b_i]
    cmp ax, cx
    
    je @int_equal
    jg @int_great
    jl @int_less
    
    @int_equal:
    xor eax, eax
    xor ecx, ecx
    mov ax, [b_i]
    cwde
    sbb eax, 4
    mov ecx, eax
    xor eax, eax
    mov ax, [a_i]
    cwde
    cdq
    idiv ecx
    mov [res_i], eax
    jmp @int_exit
    
    @int_great:
    xor eax, eax
    mov eax, 64
    mov [res_i], eax
    jmp @int_exit
    
    @int_less:
    cwde
    xor ecx, ecx
    mov ecx, eax
    mov eax, [b_i]
    cwde
    imul ecx
    adc eax, 8
    mov [res_i], eax
    jmp @int_exit
    
    
    @int_exit:
    ret

uint16_asm:
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    
    mov ax, [a_ui]
    mov cx, [b_ui]
    cmp ax, cx
    
    je @uint_equal
    ja @uint_great
    jb @uint_less
    
    @uint_equal:
    xor eax, eax
    xor ecx, ecx
    mov ax, [b_ui]
    cwd
    sbb eax, 4
    mov ecx, eax
    xor eax, eax
    mov ax, [a_ui]
    cwd
    cdq
    idiv ecx
    mov [res_ui], eax
    jmp @uint_exit
    
    @uint_great:
    xor eax, eax
    mov eax, 64
    mov [res_ui], eax
    jmp @uint_exit
    
    @uint_less:
    cwd
    xor ecx, ecx
    mov ecx, eax
    mov eax, [b_ui]
    cwd
    imul ecx
    adc eax, 8
    mov [res_ui], eax
    jmp @uint_exit
    
    
    @uint_exit:
    ret