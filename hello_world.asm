; Hello world in assembly

format ELF64
section ".text" executable
public _start

extrn 'my_strlen' as strlen

_start:
    mov eax, msg
    call strlen

    mov edx, eax
    mov eax, 4 
    mov ebx, 1
    mov ecx, msg
    int 0x80

    mov eax, 1
    mov ebx, 0x0
    int 0x80

section ".data" 
    msg db "Hello, world!",0xa,0x0
