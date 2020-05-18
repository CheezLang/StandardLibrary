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
    ; mov rsp, [rsi]

    mov [rdi + 0 * 8], rsp
    mov [rdi + 1 * 8], r15
    mov [rdi + 2 * 8], r14
    mov [rdi + 3 * 8], r13
    mov [rdi + 4 * 8], r12
    mov [rdi + 5 * 8], rbx
    mov [rdi + 6 * 8], rbp
    mov [rdi + 7 * 8], rdi

    mov rsp, [rsi + 0 * 8]
    mov r15, [rsi + 1 * 8]
    mov r14, [rsi + 2 * 8]
    mov r13, [rsi + 3 * 8]
    mov r12, [rsi + 4 * 8]
    mov rbx, [rsi + 5 * 8]
    mov rbp, [rsi + 6 * 8]
    mov rdi, [rsi + 7 * 8]
    ret


    ; mov    [rbp - 0x8], rdi ; 1. argument
    ; mov    [rbp - 0x4], rsi ; 2. argument

; rax, rcx, rdx are free to use for whatever
; rdi: arg 0
; rsi: arg 1
; rcx: from (^Fiber)
; rdx: to   (^Fiber)
switch_to_fiber2:
    sub rsp, 8
    ; push   rbp
    ; mov    rbp, rsp

    ; save registers
    mov [rdi + 0 * 8], rax
    mov [rdi + 1 * 8], rbx
    mov [rdi + 2 * 8], rcx
    mov [rdi + 3 * 8], rdx
    mov [rdi + 4 * 8], rbp
    mov [rdi + 5 * 8], rsp
    mov [rdi + 6 * 8], rsi
    mov [rdi + 7 * 8], rdi
    mov [rdi + 8 * 8], r8
    mov [rdi + 9 * 8], r9
    mov [rdi + 10 * 8], r10
    mov [rdi + 11 * 8], r11
    mov [rdi + 12 * 8], r12
    mov [rdi + 13 * 8], r13
    mov [rdi + 14 * 8], r14
    mov [rdi + 15 * 8], r15

    ; save label as next_address
    mov rax, _returned_from_fiber
    mov [rdi + 32 * 8], rax

    mov rcx, rdi
    mov rdx, rsi

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
    add rsp, 8
    ret