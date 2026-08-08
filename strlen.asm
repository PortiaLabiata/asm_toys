; Strlen function implementation

format ELF
section ".text" executable
public my_strlen

; strlen - finds string's length (until terminator)
; @parm eax - string's address
; @returns eax - string's length
my_strlen:
    mov ecx, eax
.loop:
    mov bl, [eax]
    add eax, 1
    cmp bl, 0x00
    jnz .loop 
    sub eax, ecx
    dec eax
    ret
