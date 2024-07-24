
;build/bin/llc  -mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm -o - llvm/test/CodeGen/ISOLDE/test_q.ll 
declare   <4 x i32>  @foo( <4 x i32>  )  

define <4 x i32> @test(){

  %input_shape_0 = insertelement <4 x i32> undef, i32 1, i32 0
  %input_shape_1 = insertelement <4 x i32> %input_shape_0, i32 28, i32 1
  %input_shape_2 = insertelement <4 x i32> %input_shape_1, i32 28, i32 2
  %input_shape = insertelement <4 x i32> %input_shape_2, i32 3, i32 3

  %res = call <4 x i32>  @foo( <4 x i32>  %input_shape )
  ret <4 x i32> %res  
}