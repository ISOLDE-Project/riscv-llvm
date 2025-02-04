// RUN: %clang -cc1 -triple riscv32-unknown-elf -target-feature +v  \
// RUN: -target-abi ilp32d -O0 -emit-llvm  -o - \
// RUN:   %s | FileCheck %s

// RUN: %clang -cc1 -triple riscv32-unknown-elf -target-feature +v  \
// RUN: -target-abi ilp32d -O0 -S  -o - \
// RUN:   %s | FileCheck %s --check-prefix=ASM-CHECK

extern void* x;
extern void* w;
extern void* y;

int main(){
    __builtin_isolde_redmule_gemm(x,w,y,10,20,30);
    return 0;
}

// CHECK:  %0 = load ptr, ptr @x, align 4
// CHECK:  %1 = load ptr, ptr @w, align 4
// CHECK:  %2 = load ptr, ptr @y, align 4
// CHECK:  call void @llvm.isolde.redmule.gemm(ptr %0, ptr %1, ptr %2, i32 10, i32 20, i32 30)
// CHECK:  ret i32 0

// ASM-CHECK:        redmule.gemm    a1, a2, a3, 10, 20, 30
// ASM-CHECK:        addi    sp, sp, 16