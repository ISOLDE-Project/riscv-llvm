; COM:  this line is a comment
; COM:  cd /home/uic52463/hdd1/c2023-riscv/toolchain/riscv-llvm
; COM:  build/bin/llvm-lit   llvm/test/CodeGen/Conti/transpose.ll
; COM:  build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_q.ll
; COM:  build/bin/llc  -mtriple=arm64 -mattr=+neon -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_q.ll
; COM:  build/bin/llc --debug -mtriple riscv32 -mattr +v -target-abi ilp32d -filetype asm -o - llvm/test/CodeGen/ISOLDE/test_q.ll
; RUN: llc -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm < %s | FileCheck %s


;build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_q.ll
declare   <3 x i32>  @foo( <3 x i32>  )  
define <3 x i32> @test(){
  %input_shape_0 = insertelement <3 x i32> undef, i32 1, i32 0
  %input_shape_1 = insertelement <3 x i32> %input_shape_0, i32 28, i32 1
  %res = insertelement <3 x i32> %input_shape_1, i32 28, i32 2
;  %res = call <3 x i32>  @foo( <3 x i32>  %input_shape )
  ret <3 x i32> %res  
}


;CHECK:  ld3xi32 Q10, 1, 28, 28

