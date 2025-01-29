//==- BuiltinsISOLDE.td - RISC-V Builtin function database ---*- tablegen -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the RISC-V-specific builtin function database.
//
//===----------------------------------------------------------------------===//

include "clang/Basic/BuiltinsBase.td"

class ISOLDEBuiltin<string prototype, string features = ""> : TargetBuiltin {
  let Spellings = ["__builtin_isolde_" # NAME];
  let Prototype = prototype;
  let Features = features;
}

let Attributes = [NoThrow] in {

//===----------------------------------------------------------------------===//
// REDMULE extension.
//===----------------------------------------------------------------------===//
let Features = "v,32bit" in {
def redmule_gemm : ISOLDEBuiltin<"void(void*,void*,void*,int32_t, int32_t, int32_t)">;
} // Features = "v,32bit"



} // Attributes = [Const]

