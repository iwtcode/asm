section .data
    extern a_sc
    extern b_sc
    extern d_sc
    extern dividend_sc
    extern divider_sc
    extern res_sc

    extern a_uc
    extern b_uc
    extern d_uc
    extern dividend_uc
    extern divider_uc
    extern res_uc

    extern a_si
    extern b_si
    extern d_si
    extern dividend_si
    extern divider_si
    extern res_si

    extern a_ui
    extern b_ui
    extern d_ui
    extern dividend_ui
    extern divider_ui
    extern res_ui
section .text

global int8_asm
global uint8_asm
global int16_asm
global uint16_asm

;var 19: (-35/b+d-b)/(1+a*b/4)

int8_asm:
    xor ax, ax
    xor cx, cx
    
    ;---dividend---
    ;-35/b+d-b
    mov ax, [b_sc]
    cbw
    mov cx, ax
    mov ax, -35
    cwd
    idiv cx
    
    mov cx, ax
    xor ax, ax
    mov ax, [d_sc]
    cbw
    adc ax, cx
    
    mov cx, ax
    xor ax, ax
    mov ax, [b_sc]
    cbw
    sbb cx, ax
    mov [dividend_sc], cx
    
    ;---divider---
    ;1+a*b/4
    xor ax, ax
    mov ax, [a_sc]
    xor ah, ah
    mov cx, [b_sc]
    xor ch, ch
    imul cl
    
    mov cx, 4
    xor ch, ch
    cwd
    idiv cx
    
    mov cx, 1
    xor ch, ch
    adc ax, cx
    cwd
    mov [divider_sc], ax
    
    ;---dividend/divider---
    mov ax, [dividend_sc]
    mov cx, [divider_sc]
    cwd
    idiv cx
    mov [res_sc], ax
    
    ret

uint8_asm:
    xor ax, ax
    xor cx, cx
    
    ;---dividend---
    ;-35/b+d-b
    mov ax, -35
    mov cx, [b_uc]
    xor ch, ch
    cwd
    idiv cx
    
    mov cx, [d_uc]
    xor ch, ch
    add ax, cx
    
    mov cx, [b_uc]
    xor ch, ch
    sub ax, cx
    mov [dividend_uc], ax
    
    ;---divider---
    ;1+a*b/4
    mov ax, [a_uc]
    xor ah, ah
    mov cx, [b_uc]
    xor ch, ch
    mul cx
    
    mov cx, 4
    div cx
    
    mov cx, 1
    add ax, cx
    mov [divider_uc], ax
    
    ;---dividend/divider---
    mov ax, [dividend_uc]
    mov cx, [divider_uc]
    xor dx, dx
    cwd
    idiv cx
    mov [res_uc], ax
    
    ret

int16_asm:
    xor eax, eax
    xor ecx, ecx
    
    ;---dividend---
    ;-35/b+d-b
    mov ax, [b_si]
    cwde
    
    mov ecx, eax
    xor eax, eax
    mov eax, -35
    cdq
    idiv ecx
    
    xor ecx, ecx
    mov ecx, eax
    xor eax, eax
    mov ax, [d_si]
    cwde
    adc eax, ecx
    
    xor ecx, ecx
    mov ecx, eax
    xor eax, eax
    mov ax, [b_si]
    cwde
    sbb ecx, eax
    mov [dividend_si], ecx
    
    ;---divider---
    ;1+a*b/4
    xor eax, eax
    xor ecx, ecx
    mov ax, [a_si]
    cwde
    mov ecx, eax
    xor eax, eax
    mov ax, [b_si]
    cwde
    imul ecx
    
    mov ecx, 4
    cdq
    idiv ecx
    inc eax
    xor ecx, ecx
    mov [divider_si], eax
    
    ;---dividend/divider---
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    mov eax, [dividend_si]
    mov ecx, [divider_si]
    cdq
    idiv ecx
    mov [res_si], eax
    
    ret

uint16_asm:
    xor eax, eax
    xor ecx, ecx
    
    ;---dividend---
    ;-35/b+d-b
    mov ax, [b_ui]
    cwd
    
    mov ecx, eax
    xor eax, eax
    mov eax, -35
    cdq
    idiv ecx
    
    xor ecx, ecx
    mov ecx, eax
    xor eax, eax
    mov ax, [d_ui]
    cwd
    adc eax, ecx
    
    xor ecx, ecx
    mov ecx, eax
    xor eax, eax
    mov ax, [b_ui]
    cwd
    sbb ecx, eax
    mov [dividend_ui], ecx
    
    ;---divider---
    ;1+a*b/4
    xor eax, eax
    xor ecx, ecx
    mov ax, [a_ui]
    cwd
    mov ecx, eax
    xor eax, eax
    mov ax, [b_ui]
    cwd
    mul ecx
    
    mov ecx, 4
    div ecx
    inc eax
    xor ecx, ecx
    cwd
    mov ecx, eax
    mov [divider_ui], eax
    
    ;---dividend/divider---
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    mov eax, [dividend_ui]
    mov ecx, [divider_ui]
    cdq
    idiv ecx
    mov [res_ui], eax
    
    ret