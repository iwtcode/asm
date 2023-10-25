section .data
    a dw 0
    b dw 0
    res dq 0
    
    ma db 0
    mb db 0
    
    fres dq 0
    i db 0
    
    msg db '1 - int (-32768 to 32767), 2 - uint(0 to 65535)', 0xa, 'input mode, a, b: '
    lenmsg equ $-msg
    dbz db 'exception: divizion by zero', 0xa
    lendbz equ $-dbz
    errmsg db 'exception: wrong input', 0xa
    lenerrmsg equ $-errmsg
    resl db 'result: '
    lenresl equ $-resl
    s db 8 dup(0)
    
section .text
    global main
    global input_int
    global input_uint
    global int16_asm
    global uint16_asm
    global exit
    global err_exit

    ;вариант 19
    ;(a == b) : a/(b-4)
    ;(a > b) : 64
    ;(a < b) : a*b+8

main:
    mov rbp, rsp
    call clear
    
    ; вывести сообщение
    mov edx, lenmsg ; длина строки
    mov ecx, msg ; строка
    mov ebx, 1 ; stdout
    mov eax, 4 ; sys_write()
    int 0x80   ; call kernel
    
    ; прочитать ввод
    mov eax, 3 ; sys_read()
    mov ebx, 0 ; stdin
    mov ecx, s ; куда читаем
    mov edx, 128 ; сколько читаем
    int 0x80
    
    ; выбор типа данных
    @choice:
    cmp byte[ecx], '1'
    je input_int
    cmp byte[ecx], '2'
    je input_uint
    call err_exit
    
; очистка регистров
clear:
    xor eax, eax
    xor ecx, ecx
    xor ebx, ebx
    xor edx, edx
    ret

; ввод unsigned int
input_uint:
    inc ecx
    cmp byte[ecx], 0x20
    jne input_uint
    inc ecx
    jmp @string_to_uintA
    
    @string_to_uintA:
    ; посимвольный перевод строки в число
    mov eax, 10
    movzx ebx, word[a]
    mul ebx
    cwd
    mov word[a], ax
    mov ebx, eax
    movzx eax, byte[ecx]
    sub eax, '0'
    
    ; проверки
    cmp eax, 0
    jb err_exit
    cmp eax, 9
    ja err_exit
    
    add ebx, eax
    add word[a], ax
    
    cmp ebx, [a]
    jne err_exit
    
    ; цикл пока s[i] != ' '
    inc ecx
    cmp byte[ecx], 0x20
    jne @string_to_uintA
    inc ecx
    je @string_to_uintB
    
    @string_to_uintB:
    ; посимвольный перевод строки в число
    mov eax, 10
    movzx ebx, word[b]
    mul ebx
    cwd
    mov word[b], ax
    mov ebx, eax
    movzx eax, byte[ecx]
    sub eax, '0'
    
    ; проверки
    cmp eax, 0
    jb err_exit
    cmp eax, 9
    ja err_exit
    
    add ebx, eax
    add word[b], ax
    
    cmp ebx, [b]
    jne err_exit
    
    ; цикл пока s[i] != '\n'
    inc ecx
    cmp byte[ecx], 0x20
    je err_exit
    cmp byte[ecx], 0xa
    jne @string_to_uintB
    call division_by_zero
    call uint16_asm
    call printres

; ввод signed int
input_int:
    inc ecx
    cmp byte[ecx], 0x20
    jne input_int
    inc ecx
    cmp byte[ecx], 0x2D
    je @minus_A
    jmp @string_to_intA
    
    @minus_A:
    mov ax, 1
    mov [ma], ax
    inc ecx
    cmp byte[ecx], 0x2D
    je @minus_A
    jmp @string_to_intA
    
    @string_to_intA:
    ; посимвольный перевод строки в число
    mov eax, 10
    movsx ebx, word[a]
    mul ebx
    cwd
    mov word[a], ax
    mov ebx, eax
    movzx eax, byte[ecx]
    sub eax, '0'
    
    ; проверки
    cmp eax, 0
    jb err_exit
    cmp eax, 9
    ja err_exit
    
    add word[a], ax
    add ebx, eax
    
    cmp ebx, [a]
    jne err_exit
    
    ; цикл пока s[i] != ' '
    inc ecx
    cmp byte[ecx], 0x20
    jne @string_to_intA
    inc ecx
    mov ax, [ma]
    cmp ax, 1
    je @minus_A_true
    
    movsx rax, dword[a]
    mov rbx, -32768
    cmp rax, rbx
    jl err_exit
    mov rbx, 32767
    cmp rax, rbx
    jg err_exit
    
    cmp byte[ecx], 0x2D
    je @minus_B
    jmp @string_to_intB
    
    @minus_A_true:
    mov eax, [a]
    neg eax
    mov [a], eax
    
    movsx rax, dword[a]
    mov rbx, -32768
    cmp rax, rbx
    jl err_exit
    mov rbx, 32767
    cmp rax, rbx
    jg err_exit
    
    cmp byte[ecx], 0x2D
    je @minus_B
    jmp @string_to_intB
    
    @minus_B:
    mov ax, 1
    mov [mb], ax
    inc ecx
    cmp byte[ecx], 0x2D
    je @minus_B
    jmp @string_to_intB
    
    @string_to_intB:
    ; посимвольный перевод строки в число
    mov eax, 10
    movsx ebx, word[b]
    mul ebx
    cwd
    mov word[b], ax
    mov ebx, eax
    movzx eax, byte[ecx]
    sub eax, '0'
    
    ; проверки
    cmp eax, 0
    jb err_exit
    cmp eax, 9
    ja err_exit
    
    add word[b], ax
    add ebx, eax
    
    cmp ebx, [b]
    jne err_exit
    
    ; цикл пока s[i] != '\n'
    inc ecx
    cmp byte[ecx], 0x20
    je err_exit
    cmp byte[ecx], 0xa
    jne @string_to_intB
    mov ax, [mb]
    cmp ax, 1
    je @minus_B_true
    
    movsx rax, dword[b]
    mov rbx, -32768
    cmp rax, rbx
    jl err_exit
    mov rbx, 32767
    cmp rax, rbx
    jg err_exit
    
    call division_by_zero
    call int16_asm
    call printres
    
    @minus_B_true:
    mov eax, [b]
    neg eax
    mov [b], eax
    
    movsx rax, dword[b]
    mov rbx, -32768
    cmp rax, rbx
    jl err_exit
    mov rbx, 32767
    cmp rax, rbx
    jg err_exit
    
    call division_by_zero
    call int16_asm
    call printres
    
; проверка деления на ноль
division_by_zero:
    xor ax, ax
    movsx ax, [b]
    sbb ax, 4
    cmp ax, 0
    je @dbz_true
    ret
    
    @dbz_true:
    mov edx, lendbz ; длина строки
    mov ecx, dbz ; строка
    mov ebx, 1 ; stdout
    mov eax, 4 ; sys_write()
    int 0x80   ; call kernel
    call exit

; вывод ошибки
err_exit:
    mov edx, lenerrmsg ; длина строки
    mov ecx, errmsg ; строка
    mov ebx, 1 ; stdout
    mov eax, 4 ; sys_write()
    int 0x80   ; call kernel
    call exit

; выход
exit:
    mov eax, 1 ; sys_exit()
    int 0x80   ; call kernel
    
; вывод результата
printres:
    call clear
    
    mov edx, lenresl ; длина строки
    mov ecx, resl ; строка
    mov ebx, 1 ; stdout
    mov eax, 4 ; sys_write()
    int 0x80   ; call kernel
    
    call clear
    mov rax, [res]
    mov [fres], rax
    cmp rax, 0
    jl @print_minus
    mov ax, [s]
    mov ax, 0
    mov [s], ax
    jmp @print_else
    
    @print_minus:
    mov rax, [fres]
    neg rax
    mov [fres], rax
    
    mov ecx, '-'
    mov [s], ecx
    mov edx, 1 ; длина строки
    mov ecx, s ; строка
    mov ebx, 1 ; stdout
    mov eax, 4 ; sys_write()
    int 0x80   ; call kernel
    mov ax, [s]
    mov ax, 0
    mov [s], ax
    jmp @print_else
    
    @print_else:
    call clear
    mov rax, [fres]
    mov rbx, 10
    cqo
    div rbx
    mov [fres], rax
    
    movzx ecx, byte[i]
    add edx, '0'
    mov [s + ecx], edx
    
    movzx edx, byte[i]
    inc edx
    mov [i], edx
    
    mov rcx, [fres]
    cmp rcx, 0
    jne @print_else
    jmp @final_print
    
    @final_print:
    call clear
    movzx eax, byte[i]
    dec eax
    mov [i], eax
    mov ebx, s
    add ebx, eax
    
    mov edx, 1 ; длина строки
    mov ecx, ebx ; строка
    mov ebx, 1 ; stdout
    mov eax, 4 ; sys_write()
    int 0x80   ; call kernel
    movzx eax, byte[i]
    cmp eax, 0
    jne @final_print
    
    mov eax, 0xa
    mov [s], eax
    mov edx, 1 ; длина строки
    mov ecx, s ; строка
    mov ebx, 1 ; stdout
    mov eax, 4 ; sys_write()
    int 0x80   ; call kernel
    
    call exit

int16_asm:
    
    
    movsx rax, dword[b]
    mov rbx, -32768
    cmp rax, rbx
    jl err_exit
    mov rbx, 32767
    cmp rax, rbx
    jg err_exit
    
    xor eax, eax
    xor ecx, ecx
    xor ebx, ebx
    xor edx, edx
    
    mov ax, [a]
    mov cx, [b]
    cmp ax, cx
    
    je @int_equal
    jg @int_great
    jl @int_less
    
    @int_equal:
    xor eax, eax
    xor ecx, ecx
    mov ax, [b]
    cwde
    sbb eax, 4
    mov ecx, eax
    xor eax, eax
    mov ax, [a]
    cwde
    cdq
    idiv ecx
    mov [res], eax
    jmp @int_exit
    
    @int_great:
    xor eax, eax
    mov eax, 64
    mov [res], eax
    jmp @int_exit
    
    @int_less:
    cwde
    xor ecx, ecx
    mov ecx, eax
    mov eax, [b]
    cwde
    imul ecx
    adc eax, 8
    mov [res], eax
    jmp @int_exit
    
    @int_exit:
    ret

uint16_asm:
    xor eax, eax
    xor ecx, ecx
    xor ebx, ebx
    xor edx, edx
    
    mov ax, [a]
    mov cx, [b]
    cmp ax, cx
    
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
    xor rcx, rcx
    mov rcx, rax
    movzx rax, word[b]
    cdq
    imul rcx
    adc rax, 8
    mov [res], rax
    jmp @uint_exit
    
    @uint_exit:
    ret
