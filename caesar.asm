%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

    xor eax, eax
    xor ebx, ebx

encrypt:
    ; move each character in al register
    mov al, byte [esi + ecx - 1]
    cmp al, 'A'
    ; if it has lower ASCII code than 'A', then it is non-alphabetic
    jb non_alpha

checkUpper:
    ; if it is situated between 'A' and 'Z', then it is uppercase
    cmp al, 'Z'
    jbe addUpper

    cmp al, 'z'
    ja non_alpha

checkLower:
    ; check if current char is lowercase
    cmp al, 'a'
    jae addLower

non_alpha:
    ; if the character was non-alphabetic or if we already added
    ; the key to eax, add eax to the result
    mov byte [edx + ecx - 1], al
    loop encrypt

    popa
    leave
    ret

addLower:
    add eax, edi

carryLower:
    ; now check if al is too big to be stored as an ASCII alphabetical
    cmp al, 'z'
    jbe non_alpha

    ; decrement 'z' - 'a' from al until it contains a valid lowercase
    ; character
    sub al, 'z'
    add al, 'a'
    dec al
    jmp carryLower

addUpper:
    add eax, edi

carryUpper:
    cmp al, 'Z'
    jbe non_alpha

    ; decrement 'Z' - 'A' from al until it contains a valid upperrcase
    ; character
    sub al, 'Z'
    add al, 'A'
    dec al
    jmp carryUpper
