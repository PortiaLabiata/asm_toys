; Readline function

format ELF64
section ".text" executable
public my_readline

extrn my_getc as getc

; readline - reads one line into specified buffer.
; If line doesn't fit in buffer, it will be truncated
; and function will return early.
; @parm eax - buffer address
; @parm ebx - buffer size
; @returns - number of read bytes
my_readline:
.loop:
    ; Backup buffer address and call getc
    call getc

    ; Char code is now in eax
    mov [eax], ecx
    add eax, 0x1
    cmp ecx, 10
    je .exit
