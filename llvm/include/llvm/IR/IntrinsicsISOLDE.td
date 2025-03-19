//===- IntrinsicsISOLDE.td - Defines ISOLDE intrinsics -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the ISOLDE-specific intrinsics.
// how to build
// 1.  cd build
// 2.  make -j$(nproc) intrinsics_gen 
// 3.  make -j$(nproc) llc 
//===----------------------------------------------------------------------===//


let TargetPrefix = "isolde" in {
/**
* REDMULE_GEMM
**/

def int_isolde_redmule_gemm : Intrinsic<
/*** return types*/       [    
                          ],
/*** param types*/        [ 
/* ptr %z         */        llvm_ptr_ty  
/*  ptr %x        */       ,llvm_ptr_ty
/*  ptr %w        */       ,llvm_ptr_ty
/*  i32 %M        */       ,llvm_i32_ty
/*  i32 %N        */       ,llvm_i32_ty
/*  i32 %K        */       ,llvm_i32_ty
                          ],
                          [ IntrHasSideEffects]>;

def int_isolde_redmule_gemm2 : Intrinsic<
/*** return types*/       [    
                          ],
/*** param types*/        [ 
/* ptr %z         */        llvm_ptr_ty  
/*  ptr %x        */       ,llvm_ptr_ty
/*  ptr %w        */       ,llvm_ptr_ty
/*  v4i32 %Q      */       ,llvm_v4i32_ty
                          ],
                          [ IntrHasSideEffects]>;

//ONNX                          

def int_isolde_onnx_conv2df32  : Intrinsic<
/*** return types*/                [
/*  %y_s */            llvm_v4i32_ty
/*** param types*/                 ],[ 
/* %y    */            llvm_ptr_ty
/* %x    */          , llvm_ptr_ty
/* %x_s  */          , llvm_v4i32_ty
/* %w    */          , llvm_ptr_ty
/* %w_s  */          , llvm_v4i32_ty
/* %b    */          , llvm_ptr_ty 
/** conv2d  attributes            **/
/* %p    */          , llvm_v4i32_ty
/* %s_d  */          , llvm_v4i32_ty 

                                   ],
                                   [ IntrHasSideEffects]>;
}

class ISOLDEStoreQ 
    : DefaultAttrsIntrinsic<
          [], 
          [llvm_v4i32_ty, llvm_ptr_ty, llvm_anyint_ty], 
          [NoCapture<ArgIndex<1>>, IntrWriteMem]> 
{
}

class ISOLDELoadQ 
    : DefaultAttrsIntrinsic<
          [llvm_v4i32_ty], 
          [llvm_ptr_ty, llvm_anyint_ty], 
          [IntrReadMem]> 
{
}   



//QWORD
def int_isolde_vse : ISOLDEStoreQ;
def int_isolde_vle : ISOLDELoadQ;