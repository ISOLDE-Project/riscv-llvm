; RUN: llc -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm < %s | FileCheck %s

declare void @llvm.isolde.redmule.gemm2(ptr, ptr, ptr, <4 x i32>)

define void @test_redmule_gemm2(ptr %rd, ptr %rs1, ptr %rs2, <4 x i32> %rs3) {
  ; COM: Call the REDMULE_GEMM2 intrinsic
  call void @llvm.isolde.redmule.gemm2(ptr %rd, ptr %rs1, ptr %rs2, <4 x i32> %rs3)
  ret void
}

;CHECK: redmule.gemm2. a0, a1, a2, Q10
;CHECK-NEXT:        ret
