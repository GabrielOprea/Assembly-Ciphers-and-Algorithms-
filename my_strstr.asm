
%include "io.mac"

section .data
    error dd 0
    haystack_len dd 0
    needle_len dd 0
    compare db 0
    substr_adr dd 0

section .text
    global my_strstr
    extern printf

my_strstr:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len

    ; move edi content to memory
    mov dword [substr_adr], edi

    ; set an error variable in case substring is not found
    mov [error], ecx
    inc dword [error]

    ; iterate through haystack_len - needle_len elements in the
    ; haystack string, then needle_len elements from this index

    ; store these two indexes in two registers
    sub ecx, edx
    mov [haystack_len], ecx
    mov [needle_len], edx

    ; set ecx to 0(first index)
    xor ecx, ecx

begin:
    ; if maximum len is reached without finding occurence, strstr returns
    ; an error
    cmp ecx, dword [haystack_len]
    ja fail

    mov eax, [ebx + edx]
    mov byte [compare], al

    ; store the char at the sum of the two indexes
    mov eax, ecx
    add eax, edx
    mov al, byte [esi + eax]

    cmp byte [compare], al
    je matching_char

non_matching_char:
    ; empty edx(second index), increment ecx, try again
    xor edx, edx
    inc ecx
    jmp begin

matching_char:
    ; increment edx, if all characters of needle are found
    ; then strstr returns positive result
    inc edx
    cmp dl, [needle_len]
    je found
    jmp begin

found:
    ; write in substr_adr, which was in edi register initially
    mov edi, dword [substr_adr]
    mov dword [edi], ecx
    popa
    leave
    ret

fail:
    ; write error code(max len + 1)
    mov edi, dword [substr_adr]
    mov eax, dword [error]
    mov dword [edi], eax
    popa
    leave
    ret