; Database of employees

format ELF
section ".text" executable
public _start

include "macros.inc"

_start:
    println "Type commands after prompt"
_loop:
    print prompt, prompt_size
    
    mov eax, command_buffer
    mov ebx, command_bufsize
    call readline

    strcmp command_buffer, help_name
    je help_func

    strcmp command_buffer, exit_name
    je exit_func

    strcmp command_buffer, noop_name
    je noop_func

    jmp _loop

help_func:
    println "This is a simple database. Available commands:"
    println "help - prints this message"
    println "exit - exits the program"
    println "noop - no operation"
    jmp _loop

exit_func:
    println "Exiting"
    exit 0

noop_func:
    println "NOP"
    jmp _loop

section ".data" writable
    command_buffer rb command_bufsize

section ".rodata"
    prompt db "> "
    prompt_size = $ - prompt
    command_bufsize = 128

    help_name db "help",0x0
    exit_name db "exit",0x0
    noop_name db "noop",0x0
