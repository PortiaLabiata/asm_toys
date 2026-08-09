; Database of employees

format ELF
section ".text" executable

; Declare all functions as public for ease
; of debugging
public _start
public help_func
public adde_func 
public list_func
public save_func
public load_func
public exit_func

include "macros.inc"

macro read_line bufname*, bufsize* 
{
    if ~ bufname eq eax 
        mov eax, bufname
    end if
    mov ebx, bufsize
    call readline
}

macro open filename*
{
    local label
    local path
    jmp label
    path db filename,0x0
    label:

    mov eax, 5
    mov ebx, path
    mov ecx, 2
    mov edx, 0
    int 0x80
    mov [db_fd], eax
}

macro write fd*, buf*, size
{
    mov eax, 4
    mov ebx, fd
    mov ecx, buf

    if ~ size eq
        mov edx, size
    end if
    int 0x80
}

macro seek fd*, offset*
{
    mov eax, 19
    mov ebx, fd
    mov ecx, offset
    mov edx, 0
    int 0x80
}

macro read fd*, buf*, size*
{
    mov eax, 3
    mov ebx, fd
    mov ecx, buf
    mov edx, size
    int 0x80
}

struc db_entry
{
    .name   rb name_max_size
    .age    rb age_max_size
}

_start:
    open "./database.db"

    cmp [db_fd], 0x0
    jl could_not_open
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

    strcmp command_buffer, save_name
    je save_func

    strcmp command_buffer, load_name
    je load_func

    jmp invalid_func

could_not_open:
    println "Could not open file!"
    exit 1

help_func:
    print help_string, help_string_len 
    jmp _loop

exit_func:
    println "Exiting"
    exit 0

virtual at employees
    employee_name rb name_max_size
    employee_age rb age_max_size
    size = $ - employee_name
    age_offset = employee_age - employee_name
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

save_func:
    seek [db_fd], 0
    mov edx, [employee_counter]
    imul edx, size
    write [db_fd], employees
    debug_print "RET=", eax

    cmp eax, 0x0
    jg _loop

    println "Error writing to file!"
    jmp _loop

load_func:
    seek [db_fd], 0
    read [db_fd], employees, db_max_size * db_entry_size
    mov ebx, db_entry_size
    xor edx, edx
    div ebx
    mov [employee_counter], eax
    debug_print "CNT=", eax
    jmp _loop

invalid_func:
    println "Invalid command"
    jmp _loop

section ".bss" writable
    command_buffer      rb command_bufsize
    employees           rb db_max_size * db_entry_size
    employee_counter    dd 0
    db_fd               dd 0

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
        "list - list all registered employees",0xa, \
        "save - save list to database.db",0xa, \
        "load - read list from database.db",0xa
    help_string_len = $ - help_string

    help_name db "help",0x0
    exit_name db "exit",0x0
    adde_name db "adde",0x0
    list_name db "list",0x0
    save_name db "save",0x0
    load_name db "load",0x0
