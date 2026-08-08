extrn 'my_readline' as readline 
extrn 'my_strlen' as strlen
extrn 'my_itoa' as itoa

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

macro exit code* 
{
    mov eax, 1
    mov ebx, code
    int 0x80
}

macro debug_print string*, register*
{
    if ~ string eqtype ""
        err "debug_print: first arg must be a string literal"
    end if

    pusha
    mov eax, register
    call itoa

    push eax
    print "[Debug] "
    print string
    pop eax

    push eax
    call strlen
    mov edx, eax
    pop eax

    print eax
    print line_feed, 1
    popa
}

section ".rodata"
    line_feed db 0xa
