; Readline function

format ELF64
section ".text" executable
public my_readline

extrn 'my_getc' as getc

; readline - reads one line into specified buffer.
; If line doesn't fit in buffer, it will be truncated
; and function will return early.
; @parm eax - buffer address
; @parm ebx - buffer size
; @returns - number of read bytes
my_readline:
    ; Address of the last cell of buffer 
    ; is now stored in ecx and current cell address
    ; is in ebx
    mov ecx, eax
    add ecx, ebx
    mov ebx, eax
.loop:
    ; Character code will be in eax
    push rbx
    push rcx

    call getc

    pop rcx
    pop rbx

    mov [ebx], eax
    add ebx, 1

    ; Check if we hit the last char
    cmp eax, 0xa
    je .exit

    ; Check if we hit the last cell
    cmp ebx, ecx
    je .exit

    jmp .loop
.exit:
    mov eax, ecx
    sub eax, ebx
    ret
