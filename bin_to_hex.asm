%include "io.mac"

section .data
    length dd 0
    index dd 0
    hex_length dd 0

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length

    ; set an index memory location to 0
    ; and set length to ecx, in order to use ecx
    ; to store other values
    mov dword [index], 0
    mov dword [length], ecx

    ; empty ebx and eax registers
    xor ebx, ebx
    xor eax, eax

    ; divide length by 4, to get the maximum index of the
    ; hexadecimal sequence
    mov al, cl
    mov bl, 4
    div bl

    cmp ah, 0
    ; if remainder is 0, decrement the max index
    je dec_al
start:
    xor ah, ah
    ; set maximum hex index
    mov dword [hex_length], eax

convert:
    cmp ecx, 0
    jle end

    sub ecx, 4
    xor ebx, ebx

    ; obtain the bin sequence's current address
    mov edi, esi
    add edi, ecx

    ; if ecx is -1, then skip the first bit
    cmp ecx, -1
    je second_bit

    cmp ecx, -2
    je third_bit

    cmp ecx, -3
    je fourth_bit

    ;obtain four bits in the binary sequence, then append them
    ;to a register by using logical or and shifting operations

first_bit:
    mov al, byte [edi]
    sub eax, '0'
    shl eax, 3
    or ebx, eax

second_bit:
    mov al, byte [edi + 1]
    sub eax, '0'
    shl eax, 2
    or ebx, eax

third_bit:
    mov al, byte [edi + 2]
    sub eax, '0'
    shl eax, 1
    or ebx, eax

fourth_bit:
    mov al, byte [edi + 3]
    sub eax, '0'
    or ebx, eax

    ; bl contains one hexadecimal character
    ; if it is greater or equal to 10, change it to
    ; a letter instead of digit
    cmp bl, 10
    jge print_letter
    jmp print_digit

dec_al:
    dec al
    jmp start

print_digit:
    ;al will contain the digit to be writen
    mov al, '0'
    add al, bl

    ; ebx contains max index - crt index, because characters are
    ; writen in reverse order
    mov ebx, dword [hex_length]
    sub ebx, dword [index]

    ; move to result register(edx)
    mov byte [edx + ebx], al
    inc dword [index]
    ; go back to conversion until we used all bits
    jmp convert

print_letter:

    mov al, 'A'
    sub al, 10
    add al, bl

    mov ebx, dword [hex_length]
    sub ebx, dword [index]

    mov byte [edx + ebx], al
    inc byte [index]
    jmp convert

end:
    ; add a newline at the end of the result
    ; 10 is '\n' in ASCII
    mov ebx, dword [hex_length]
    inc ebx
    mov byte [edx + ebx], 10
    popa
    leave
    ret