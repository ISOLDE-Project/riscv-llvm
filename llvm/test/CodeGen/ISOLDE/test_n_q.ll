;build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_n_q.ll 


define <3 x i32> @test(){

  %input_shape_0 = insertelement <3 x i32> undef,          i32 1,  i32 0
  %input_shape_1 = insertelement <3 x i32> %input_shape_0, i32 28, i32 1
  %input_shape   = insertelement <3 x i32> %input_shape_1, i32 28, i32 2

  ret <3 x i32> %input_shape
}