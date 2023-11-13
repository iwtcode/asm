section .data
    extern a, b, d, res_up, res_dn, result;
    n dw 0;
    
section .text
global asm_func

; вариант 19
; (-35/b+d-b)/(1+a*b/4)

asm_func:
    mov rbp, rsp; for correct debugging
    
    ;res_up = (-35/b+d-b)
    mov [n], dword -35   ; подскакиваем кабанчиком
    fild dword[n]        ; обкашливаем вопросики
    fdiv dword[b]        ; делаем звоночек человечку
    fiadd dword[d]       ; закупаем
    fsub dword[b]        ; докупаем
    fst qword[res_up]    ; фиксируем прибыль
    
    ;res_dn = (1+a*b/4)
    fld dword[a]         ; идём по ковру
    fmul dword[b]        ; идёт, пока врёт
    mov [n], dword 4     ; идём, пока врём
    fidiv dword[n]       ; хмурим брови
    mov [n], dword 1     ; морщим лоб
    fiadd dword[n]       ; делаем умное лицо
    fst qword[res_dn]    ; изображаем мыслительный процесс
    
    ;result = (-35/b+d-b)/(1+a*b/4)
    fdiv                 ; чёта жмём
    fst qword[result]    ; готово
    
    ret
