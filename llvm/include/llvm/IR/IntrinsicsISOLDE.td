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
// 2.  make intrinsics_gen -j6
// 3.  make llc -j30
//===----------------------------------------------------------------------===//


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