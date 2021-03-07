%include "io.mac"

section .text
    global otp
    extern printf

otp:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

    ; The One Time Pad cipher
    ; Empty the eax and ebx registers
    xor eax, eax
    xor ebx, ebx
encrypt:
    ; iterate through plaintext and ciphertext using ecx
    mov al, byte [esi + ecx - 1]
    xor al, byte [edi + ecx - 1]
    ; store the result in edx(cipertext)
    mov byte [edx + ecx - 1], al
    loop encrypt

    popa
    leave
    ret