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

    ; We need to backup eax to not calculate
    ; line's length all over again
    push eax
    debug_print "EAX: ", eax 

    ; Print greeting message
    print "Hello, "

    pop eax
    mov edx, eax

    ; Print person's name
    print buffer
    print "!"
    exit 0

section ".data" writable
    buffer rb 64
    bufsize = $ - buffer
