; COM:  this line is a comment
; COM:  cd /home/uic52463/hdd1/c2023-riscv/toolchain/riscv-llvm
; COM:  build/bin/llvm-lit   llvm/test/CodeGen/Conti/transpose.ll
; COM:  build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_q1.ll
; COM:  build/bin/llc  -mtriple=arm64 -mattr=+neon -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_q1.ll
; COM:  build/bin/llc --debug -mtriple riscv32 -mattr +v -target-abi ilp32d -filetype asm -o - llvm/test/CodeGen/ISOLDE/test_q1.ll
; RUN: llc -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm < %s | FileCheck %s


;build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_q1.ll


declare ptr @_Z12getMemoryf32l(i32)
declare  void @foo(ptr %o, ptr %i, <4 x i32> %i_shape, <4 x i32> %perm)

define void  @main_graph(ptr %o, ptr %i, <4 x i32> %i_shape, <4 x i32> %perm) {
  %tmp = call ptr @_Z12getMemoryf32l(i32 22)

  call  void  @foo(ptr  %o, ptr %i,  <4 x i32> %i_shape,  <4 x i32> %perm)
 
  ret void
}