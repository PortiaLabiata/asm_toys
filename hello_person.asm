; Greet person

format ELF64
section ".text" executable
public _start

_start:
    mov eax, 1
    mov ebx, 0
    int 0x80
