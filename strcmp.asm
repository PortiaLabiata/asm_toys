; Analog of C's strcmp function

format ELF
section ".text" executable
public my_strcmp

; strcmp - compares two zero-terminated strings. 
; Returns 1 if strings are different (including different
; length) and 0 otherwise
; @parm eax - ptr to first string
; @parm ebx - ptr to second string
; @returns eax - 1 if strings are different, 0 if not
my_strcmp:
.loop:
    mov cl, byte [eax]
    mov ch, byte [ebx]
    cmp cl, ch 
    jne .exit_different

    cmp cl, byte 0 
    je .exit_same

    inc eax
    inc ebx
    jmp .loop

.exit_same:
    mov eax, 0
    ret
.exit_different:
    mov eax, 1
    ret
