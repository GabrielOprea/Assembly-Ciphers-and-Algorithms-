%include "io.mac"

section .data
    key_pos dd 0
    letter db 0
    key db 0
    key_length dd 0
    text_length dd 0

section .text
    global vigenere
    extern printf

vigenere:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len

    ; store key_length and text_length in memory in order
    ; to free these registers
    mov [key_length], ebx
    mov [text_length], ecx

    ; index for iterating through key
    mov dword [key_pos], 0
encrypt:
    mov ebx, [text_length]
    sub ebx, ecx
    mov al, byte [esi + ebx]
    mov byte [letter], al

    ; check if each character in plaintext is alphabetical or not
    cmp eax, 'A'
    jb non_alpha

checkUpper:
    cmp eax, 'Z'
    jbe addUpper

    cmp eax, 'z'
    ja non_alpha

checkLower:
    cmp eax, 'a'
    jae addLower

non_alpha:
    ; mov al to result if it is not alphabetical or if it was
    ; encrypted
    mov ebx, [text_length]
    sub ebx, ecx
    mov byte [edx + ebx], al
    loop encrypt
    popa
    leave
    ret

addLower:
    ; store the key for current char in key variable
    xor eax, eax
    mov ebx, [key_pos]
    mov al, byte [edi + ebx]
    mov ebx, [key_length]
    sub al, 'A'
    mov [key], al

    ; set al to converted char
    mov al, [letter]
    add al, [key]

    ; increment key position
    inc byte [key_pos]
    cmp [key_pos], bl
    jne carryLower

    ; iterate from start of the key if last element is reached
    mov byte [key_pos], 0

carryLower:

    cmp eax, 'z'
    jbe non_alpha
    ; if eax character is outside lowercase boundaries, decrement 'z' - 'a'

    sub eax, 'z'
    add eax, 'a'
    dec eax
    jmp non_alpha

addUpper:
    xor eax, eax
    mov bl, [key_pos]
    mov al, byte [edi + ebx]
    mov bl, [key_length]
    sub al, 'A'
    mov [key], al

    mov al, [letter]
    add al, [key]

    inc dword [key_pos]
    cmp [key_pos], bl
    jne carryUpper
    mov dword [key_pos], 0

carryUpper:
    cmp eax, 'Z'
    jbe non_alpha

    sub eax, 'Z'
    add eax, 'A'
    dec eax
    jmp non_alpha