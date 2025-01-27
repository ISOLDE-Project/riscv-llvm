; COM:  this line is a comment
; COM:  cd /home/uic52463/hdd1/c2023-riscv/toolchain/riscv-llvm
; COM:  build/bin/llvm-lit   llvm/test/CodeGen/Conti/transpose.ll
; COM:  build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/redmule_gemm.ll
; COM:  build/bin/llc --debug -mtriple riscv32 -mattr +v -target-abi ilp32d -filetype asm -o - llvm/test/CodeGen/ISOLDE/test_q.ll
; RUN: llc -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm < %s | FileCheck %s

;declare ptr @_Z12getMemoryf32l(i32)
;int_isolde_redmule_gemm
;declare  ptr @llvm.isolde.redmule.gemm(ptr %x, ptr %w, i32 %M, i32 %N, i32 %K)


define void  @main_graph(ptr %z, ptr %x, ptr %w ) {
    call void  @llvm.isolde.redmule.gemm(ptr%z, ptr %x, ptr %w, i32 10, i32 20, i32 30)
    ret void
}


;CHECK:        redmule.gemm    a0, a1, a2, 10, 20, 30
;CHECK-NEXT:        ret
