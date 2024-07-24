/*
 * SPDX-License-Identifier: Apache-2.0
 */

//===------ llvm/lib/Target/RISCV/RISCVInstrInfoConti.td---------------------------===//
//
// Copyright 2023
//
// =============================================================================
//
// 
//
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsISOLDE.td"

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def LDQword: ISOLDERVInst160<
             (outs QPR:$qd )
            ,(ins i32imm:$imm1, i32imm:$imm2, i32imm:$imm3, i32imm:$imm4)
            , "vle32.q", "$qd, $imm1, $imm2, $imm3, $imm4"
            ,ISOLDERV_LOAD.funct7
            , /*pattern */[]>{
 let rs1=0;
 let rs2=0;                 
}