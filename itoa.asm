; Analog of itoa function in C

format ELF
section ".text" executable
public my_itoa

; itoa - convert number into string
; @parm eax - number
; @returns eax - ptr to buffer
my_itoa:
    ; Setup initial conditions
    mov ebx, _itoa_buffer
    add ebx, _itoa_buffer_size
    mov ecx, 10
    ; Terminate buffer first
    mov [ebx], byte 0x00
    dec ebx
.loop: 
    ; Divide number by 10. Quotient will
    ; be stored in eax and remainder - in edx
    xor edx, edx 
    div ecx

    ; Turn last digit into character by
    ; adding '0' code to it
    add edx, 0x30
    mov [ebx], dl
    dec ebx

    ; We decrement buffer size (ergo, the current offset)
    ; and if we get to zero, we need to finish
    cmp ebx, _itoa_buffer
    je .exit

    cmp eax, 0
    je .exit

    jmp .loop

.exit:
    ; ebx points to the start of the buffer
    mov eax, ebx
    inc eax
    ret

section ".data" writable
    _itoa_buffer rb 16
    _itoa_buffer_size = $ - _itoa_buffer
