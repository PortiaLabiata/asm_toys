; Readline function

format ELF
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
    mov edx, 0
.loop:
    ; Character code will be in eax
    push ebx
    push ecx

    call getc

    pop ecx
    pop ebx

    mov [ebx], eax
    inc ebx
    inc edx

    ; Check if we hit the last char
    cmp eax, 0xa
    je .trim

    ; Check if we hit the last cell
    cmp ebx, ecx
    je .exit

    jmp .loop
.trim:
    dec edx
.exit:
    mov eax, edx
    ret
