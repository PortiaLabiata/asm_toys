; Database of employees

format ELF
section ".text" executable
public _start

include "macros.inc"

macro read_line bufname*, bufsize* 
{
    if ~ bufname eq eax 
        mov eax, bufname
    end if
    mov ebx, bufsize
    call readline
}

struc db_entry
{
    .name   rb name_max_size
    .age    rb age_max_size
}

_start:
    println "Type commands after prompt"
_loop:
    print prompt, prompt_size
    
    read_line command_buffer, command_bufsize

    strcmp command_buffer, help_name
    je help_func

    strcmp command_buffer, exit_name
    je exit_func

    strcmp command_buffer, adde_name
    je adde_func

    strcmp command_buffer, list_name
    je list_func

    jmp invalid_func

help_func:
    print help_string, help_string_len 
    jmp _loop

exit_func:
    println "Exiting"
    exit 0

virtual at employees
        employee_name rb name_max_size
        employee_age rb age_max_size
        age_offset = employee_age - employee_name
        size = $ - employee_name
end virtual

adde_func:
    print "Name: "
    mov eax, size
    imul eax, [employee_counter]
    add eax, employee_name
    read_line eax, name_max_size

    print "Age: "
    mov eax, size
    imul eax, [employee_counter]
    add eax, employee_age
    read_line eax, age_max_size

    inc [employee_counter]
    mov eax, [employee_counter]

    jmp _loop

list_func:
    mov eax, employees
    mov ebx, size
    imul ebx, [employee_counter]
    add ebx, employees
list_loop:

    print "Name: "
    println eax
    add eax, age_offset
    print "Age: "
    println eax

    add eax, age_max_size
    cmp eax, ebx
    jne list_loop

    jmp _loop

invalid_func:
    println "Invalid command"
    jmp _loop

; Returns a pointer to the beginning of a struct
; by index.
; @parm eax - index
; @returns eax - ptr to db entry
get_entry:
    imul eax, db_entry_size
    add eax, employees
    ret

section ".bss" writable
    command_buffer rb command_bufsize
    employees rb db_max_size * db_entry_size
    employee_counter dd 0

section ".rodata"
    prompt db "> "
    prompt_size = $ - prompt

    command_bufsize     = 128
    db_max_size         = 16
    name_max_size       = 32
    age_max_size        = 4
    db_entry_size       = name_max_size + age_max_size

    help_string db "This is a simple database. Available commands:",0xa, \
        "help - prints this message",0xa, \
        "exit - exits the program",0xa, \
        "adde - add database entry",0xa, \
        "list - list all registered employees",0xa
    help_string_len = $ - help_string

    help_name db "help",0x0
    exit_name db "exit",0x0
    adde_name db "adde",0x0
    list_name db "list",0x0
