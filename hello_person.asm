; Greet person

format ELF
section ".text" executable
public _start

include "macros.inc"

_start:
    print "Enter your name: "
    ; Read line, line's length will be 
    ; in eax
    mov eax, buffer
    mov ebx, bufsize
    call readline

    mov eax, buffer
    call strlen

    ; Print greeting message
    push eax
    print "Hello, "
    pop eax
    mov edx, eax

    ; Print person's name
    print buffer
    print "!"
    print line_feed, 1
    exit 0

section ".data" writable
    buffer rb 64
    bufsize = $ - buffer
