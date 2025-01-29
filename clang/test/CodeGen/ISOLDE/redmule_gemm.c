// RUN: %clang_cc1 -triple riscv64 -emit-llvm -target-feature +v \
// RUN:   %s -o - \
// RUN:   | FileCheck %s

extern void* x;
extern void* w;
extern void* y;

int main(){
    __builtin_isolde_redmule_gemm(x,w,y,10,20,30);
    //__builtin_rvv_vlenb();
    return 0;
}