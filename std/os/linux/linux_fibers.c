#include <stdio.h>

typedef void(*FiberFunc)(void*);
typedef unsigned long long u64;

typedef struct {
    union {
        u64 registers[32];
        struct {
            u64 rax, rbx, rcx, rdx;
            u64 rbp, rsp, rsi, rdi;
            u64 r8, r9, r10, r11, r12, r13, r14, r15;
        };
    };
    
    void* next_address;
    void* data;
    void* stack_base;
} FiberData;

int uiaeuiaeuiae(int a, int b) {
    return a - b;
}


void switch_to_fiber(FiberData* from, FiberData* to) {
    printf("switch_to_fiber(0x%lld)\n", (u64)to);
    printf("switch_to_fiber(0x%lld, 0x%lld)\n", (u64)to->next_address, (u64)to->stack_base);

    puts("saving registers 1");
    asm(
        "movq %%rax, %0;"
        "movq %%rbx, %1;"
        "movq %%rcx, %2;"
        "movq %%rdx, %3;"
        "movq %%rbp, %4;"
        "movq %%rsp, %5;"
        "movq %%rsi, %6;"
        "movq %%rdi, %7;"
         :
            "=r"(from->rax),
            "=r"(from->rbx),
            "=r"(from->rcx),
            "=r"(from->rdx),
            "=r"(from->rbp),
            "=r"(from->rsp),
            "=r"(from->rsi),
            "=r"(from->rdi)
    );
    asm(
        "movq %%r8,  %0;"
        "movq %%r9,  %1;"
        "movq %%r10, %2;"
        "movq %%r11, %3;"
        "movq %%r12, %4;"
        "movq %%r13, %5;"
        "movq %%r14, %6;"
        "movq %%r15, %7;"
         :
            "=r"(from->r8),
            "=r"(from->r9),
            "=r"(from->r10),
            "=r"(from->r11),
            "=r"(from->r12),
            "=r"(from->r13),
            "=r"(from->r14),
            "=r"(from->r15)
    );

    asm(
        "movq _returned_from_fiber, %%rax;"
        "movq %%rax, %0;"
        :
            "=r"(from->next_address)
    );

    puts("restoring registers 1");
    asm(
        "movq %0, %%rax;"
        "movq %1, %%rbx;"
        "movq %2, %%rcx;"
        "movq %3, %%rdx;"
        // "movq %4, %%rbp;" // rbp
        // "movq %5, %%rsp;"
        "movq %6, %%rsi;"
        "movq %7, %%rdi;"
        ::
            "r"(to->rax),
            "r"(to->rbx),
            "r"(to->rcx),
            "r"(to->rdx),
            "r"(to->rbp),
            "r"(to->rsp),
            "r"(to->rsi),
            "r"(to->rdi)
    );
    asm(
        "movq %0, %%r8;"
        "movq %1, %%r9;"
        "movq %2, %%r10;"
        "movq %3, %%r11;"
        "movq %4, %%r12;"
        "movq %5, %%r13;"
        "movq %6, %%r14;"
        "movq %7, %%r15;"
        ::
            "r"(to->r8),
            "r"(to->r9),
            "r"(to->r10),
            "r"(to->r11),
            "r"(to->r12),
            "r"(to->r13),
            "r"(to->r14),
            "r"(to->r15)
    );
    asm(
        "movq %0, %%rbp;"
        "movq %1, %%rsp;"
        ::
            "r"(to->rbp),
            "r"(to->rsp)
    );

    // switch to other fiber
    puts("jumping");
    asm(
        "movq %0, %%rdi;"
        "movq %1, %%rax;"
        "jmpq *%%rax;"
        :
        :
            "r"(to->data),
            "r"(to->next_address)
    );
    
    // restore registers

    puts("saving registers");
    asm(
        "_returned_from_fiber:"
        "movq %0, %%rax;"
        "movq %1, %%rbx;"
        "movq %2, %%rcx;"
        "movq %3, %%rdx;"
        "movq %4, %%rbp;"
        "movq %5, %%rsp;"
        "movq %6, %%rsi;"
        "movq %7, %%rdi;"
        ::
            "r"(from->rax),
            "r"(from->rbx),
            "r"(from->rcx),
            "r"(from->rdx),
            "r"(from->rbp),
            "r"(from->rsp),
            "r"(from->rsi),
            "r"(from->rdi)
    );
    asm(
        "movq %0, %%r8;"
        "movq %1, %%r9;"
        "movq %2, %%r10;"
        "movq %3, %%r11;"
        "movq %4, %%r12;"
        "movq %5, %%r13;"
        "movq %6, %%r14;"
        "movq %7, %%r15;"
        ::
            "r"(from->r8),
            "r"(from->r9),
            "r"(from->r10),
            "r"(from->r11),
            "r"(from->r12),
            "r"(from->r13),
            "r"(from->r14),
            "r"(from->r15)
    );
}

void create_fiber() {
    puts("create_fiber");
}

