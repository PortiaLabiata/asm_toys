; Greet person

format ELF64
section ".text" executable
public _start

extrn 'my_readline' as readline 
extrn 'my_strlen' as strlen

_start:
    ; Read line, line's length will be 
    ; in eax
    mov eax, buffer
    mov ebx, bufsize
    call readline

    ; We need to backup eax to not calculate
    ; line's length all over again
    push rax

    ; Print greeting message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_size
    int 0x80

    pop rax
    mov edx, eax

    ; Print person's name
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 0x80

    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

section ".data" writable
    msg db "Hello, "
    msg_size = $ - msg
    buffer rb 64
    bufsize = $ - buffer
