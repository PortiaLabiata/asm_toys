; Greet person

format ELF
section ".text" executable
public _start

extrn 'my_readline' as readline 
extrn 'my_strlen' as strlen

macro print data*, size 
{
    ; Define local string constant,
    ; if we provided quoted string as
    ; an argument. We define it right 
    ; in the code section, so we need to jump
    ; over it immediately
    if data eqtype ""
        local msg
        local label

        jmp label
        msg db data,0x0
        label:
    end if

    ; If we provided quoted string,
    ; load local constant's address, else
    ; load provided address
    if ~ data eqtype ""
        mov ecx, data
    else
        mov ecx, msg
        mov eax, msg
        call strlen
        mov edx, eax
    end if

    if data eqtype "" & ~ size eq
        err "Print macro takes either quoted string, or buffer size"
    end if

    ; If we did not provide size, then we
    ; probably loaded it externally from strlen
    if ~ size eq
        mov edx, size
    end if

    ; Set syscall number and fd
    mov eax, 4
    mov ebx, 1

    int 0x80
}

_start:
    ; Read line, line's length will be 
    ; in eax
    mov eax, buffer
    mov ebx, bufsize
    call readline

    ; We need to backup eax to not calculate
    ; line's length all over again
    push eax

    ; Print greeting message
    print "Hello, "

    pop eax
    mov edx, eax

    ; Print person's name
    print buffer
    int 0x80

    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

section ".data" writable
    buffer rb 64
    bufsize = $ - buffer
