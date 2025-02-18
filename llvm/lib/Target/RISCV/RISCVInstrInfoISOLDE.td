//===-- RISCVInstrInfoISOLDE.td - RISC-V 'ISOLDE' instructions -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the RISC-V ISOLDE instructions .
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction class templates
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsISOLDE.td"


def simm32 : 
  Operand<i32>, ImmLeaf<i32, "return isInt<32>(Imm);">;

let hasSideEffects = 1, mayLoad = 1, mayStore = 0 in
def LD4XWORD: ISOLDEInst160<
             (outs QPR:$qd )
            ,(ins i32imm:$imm1, i32imm:$imm2, i32imm:$imm3, i32imm:$imm4)
            ,ISOLDE_LOAD_4XW.name, "$qd, $imm1, $imm2, $imm3, $imm4"
            ,ISOLDE_LOAD_4XW.funct7
            , /*pattern */[]>{
 let rs1=0;
 let rs2=0;                 
}

let hasSideEffects = 1, mayLoad = 1, mayStore = 0 in
def LD3XWORD: ISOLDEInst128<
             (outs QPR:$rd )
            ,(ins i32imm:$imm1, i32imm:$imm2, i32imm:$imm3 )
            ,ISOLDE_LOAD_3XW.name, "$rd, $imm1, $imm2, $imm3"
            ,ISOLDE_LOAD_3XW.funct7
            , /*pattern */[]>{
 let rs1=0;
 let rs2=0;                 
}

let hasSideEffects = 1, mayLoad = 1, mayStore = 0 in
def LD2XWORD: ISOLDEInst96<
             (outs QPR:$rd )
            ,(ins i32imm:$imm1, i32imm:$imm2 )
            ,ISOLDE_LOAD_2XW.name, "$rd, $imm1, $imm2"
            ,ISOLDE_LOAD_2XW.funct7
            , /*pattern */[]>{
 let rs1=0;
 let rs2=0;                 
}

let hasSideEffects = 1, mayLoad = 1, mayStore = 1 in
def REDMULE_GEMM: ISOLDEInst128<
             (outs)
            ,(ins  GPR:$rd, GPR:$rs1, GPR:$rs2, simm32:$imm1, simm32:$imm2, simm32:$imm3)
            ,ISOLDE_REDMULE_GEMM.name, "$rd, $rs1, $rs2, $imm1, $imm2, $imm3"
            ,ISOLDE_REDMULE_GEMM.funct7
            ,[
                (set 
                     ( int_isolde_redmule_gemm                 (  iPTR    GPR:$rd)
                                                              ,(  iPTR    GPR:$rs1)
                                                              ,(  iPTR    GPR:$rs2)
                                                              ,(  i32    simm32:$imm1)
                                                              ,(  i32    simm32:$imm2)
                                                              ,(  i32    simm32:$imm3)

                                    )
                       
                    )
             ]>{                 
}

//push, pop Q registers
def PUSHQWORD
    : ISOLDEInst32S <  ISOLDE_PUSHQ.funct3,
                  (outs), 
                  (ins  QPR:$rs2, GPRMem:$rs1, simm12:$imm12),
                  "store","v4i32", 
                  "$rs2, ${imm12}(${rs1})",
                  [
                    ( set
                        ( int_isolde_vse (  v4i32  QPR:$rs2)
                                       ,(  i32    GPRMem:$rs1)
                                       ,(  i32    simm12:$imm12)

                        )

                    )
                  ]
                >
                {
  let hasSideEffects = true;
  let mayStore = true;
  let mayLoad  = false;
  //
}

def POPQWORD 
    : ISOLDEInst32I <  ISOLDE_POPQ.funct3,
                  (outs  QPR:$rd), 
                  (ins   GPRMem:$rs1, simm12:$imm12),
                  "load","v4i32", 
                  "$rd, ${imm12}(${rs1})",
                  [ 
                    (set 
                        (v4i32 QPR:$rd), ( int_isolde_vle (  i32    GPRMem:$rs1)
                                                        ,(  i32    simm12:$imm12)

                                         )
                       
                    )
                  ]
                >
                {
  let hasSideEffects = true;
  let mayStore = false;
  let mayLoad  = true;
}

