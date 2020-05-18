global switch_to_fiber

section .text

    ; mov    [rbp - 0x8], rdi ; 1. argument
    ; mov    [rbp - 0x4], rsi ; 2. argument

; rax, rcx, rdx are free to use for whatever
; rdi: arg 0
; rsi: arg 1
; rcx: from (^Fiber)
; rdx: to   (^Fiber)
switch_to_fiber:
    ; push   rbp
    ; mov    rbp, rsp

    mov rcx, rdi
    mov rdx, rsi

    ; mov rax, [rdx + 32 * 8 + 16]
    ; mov rax, [rdx + 7 * 8]
    ; ret

    ; save registers
    mov [rcx + 0 * 8], rax
    mov [rcx + 1 * 8], rbx
    mov [rcx + 2 * 8], rcx
    mov [rcx + 3 * 8], rdx
    mov [rcx + 4 * 8], rbp
    mov [rcx + 5 * 8], rsp
    mov [rcx + 6 * 8], rsi
    mov [rcx + 7 * 8], rdi
    mov [rcx + 8 * 8], r8
    mov [rcx + 9 * 8], r9
    mov [rcx + 10 * 8], r10
    mov [rcx + 11 * 8], r11
    mov [rcx + 12 * 8], r12
    mov [rcx + 13 * 8], r13
    mov [rcx + 14 * 8], r14
    mov [rcx + 15 * 8], r15

    ; save label as next_address
    mov rax, _returned_from_fiber
    mov [rcx + 32 * 8], rax

    ; restore registers except for rax, rcx, rdx
    ; mov rax, [rdx + 0 * 8]
    mov rbx, [rdx + 1 * 8]
    ; mov rcx, [rdx + 2 * 8]
    ; mov rdx, [rdx + 3 * 8]
    mov rbp, [rdx + 4 * 8]
    mov rsp, [rdx + 5 * 8]
    mov rsi, [rdx + 6 * 8]
    mov rdi, [rdx + 7 * 8]
    mov r8,  [rdx + 8 * 8]
    mov r9,  [rdx + 9 * 8]
    mov r10, [rdx + 10 * 8]
    mov r11, [rdx + 11 * 8]
    mov r12, [rdx + 12 * 8]
    mov r13, [rdx + 13 * 8]
    mov r14, [rdx + 14 * 8]
    mov r15, [rdx + 15 * 8]

    ; jump to next instruction of to_fiber
    jmp [rdx + 32 * 8]

    ; when we resume this fiber we arrive here
_returned_from_fiber:

    ; the registers should already be restored

    ; mov    eax, [rbp - 0x4]
    ; pop    rbp
    ret