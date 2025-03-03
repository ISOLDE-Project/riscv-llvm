; COM:  this line is a comment
; COM:  cd /home/uic52463/hdd1/c2023-riscv/toolchain/riscv-llvm
; COM:  build/bin/llvm-lit   llvm/test/CodeGen/Conti/transpose.ll
; COM:  build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/redmule_gemm.ll
; COM:  build/bin/llc --debug -mtriple riscv32 -mattr +v -target-abi ilp32d -filetype asm -o - llvm/test/CodeGen/ISOLDE/test_q.ll
; RUN: llc -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm < %s | FileCheck %s

declare ptr @_Z12getMemoryf32l(i32)

define void @main_graph( ptr %i
                        , ptr %w
                        , ptr %b
                        )
 {
  %o = call ptr @_Z12getMemoryf32l(i32 22)
                    
  call  <4 x i32>  @llvm.isolde.onnx.conv2df32(ptr  %o, 
                                                       ptr %i, 
                                                       <4 x i32> <i32 1, i32 1, i32 28, i32 28>,
                                                       ptr %w,
                                                       <4 x i32> <i32 1, i32 2, i32 3, i32 3>,
                                                       ptr %b,
                                                       <4 x i32> <i32 0, i32 0, i32 0, i32 0>,
                                                       <4 x i32> <i32 1, i32 1, i32 1, i32 1>
                                                       )
  
  ret void
}

;CHECK:        ld4xi32 Q0, 1, 1, 1, 1
;CHECK-NEXT:        ld4xi32 Q1, 0, 0, 0, 0
;CHECK-NEXT:        ld4xi32 Q2, 1, 2, 3, 3
;CHECK-NEXT:        ld4xi32 Q3, 1, 1, 28, 28
;CHECK-NEXT:        onnx.conv2d.f32        a0, Q0, s2, Q3, s1, Q2, s0, Q1, Q0
