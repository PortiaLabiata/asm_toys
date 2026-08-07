; getc function

format ELF64
section ".text" executable
public my_getc

; my_getc - reads one char from stdin
; @returns - read character
my_getc:
    ; sys_read syscall
    mov eax, 3
    mov ebx, 0
    mov ecx, _getc_buf
    mov edx, 1
    int 0x80

    cmp eax, 0x0
    jz my_getc

    mov al, [_getc_buf]
    ret

section ".data" writable
    _getc_buf rb 1
