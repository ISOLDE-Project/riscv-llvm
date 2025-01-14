/*
 * SPDX-License-Identifier: Apache-2.0
 */

//===------ llvm/lib/Target/RISCV/RISCVInstrInfoISOLDE.td---------------------------===//
//
// Copyright 2023
//
// =============================================================================
//
// 
//
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsISOLDE.td"
//include "llvm/IR/IntrinsicsISOLDE.td"

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

//GEMM

def GEMMF32: GEMMInstr<0b000, "f32", int_ISOLDE_onnx_gemmf32> {
  // Define output and input operand lists
  let Size = 4;
  let OutOperandList = (outs QPR:$rd2);
  let InOperandList = (ins GPR:$rd1,
                          GPR:$rs1,    
                          GPR:$rs2,    
                          GPR:$rs3,   
                          QPR:$rs4,    
                          QPR:$rs5,    
                          i32imm:$transA, 
                          i32imm:$transB);
                          let Size = 4;

  // Instruction pattern wrapped as  a list
  /*let Pattern = [
    (set QPR:$rd2, 
         (int_ISOLDE_onnx_gemmf32
            GPR:$rd1, 
            GPR:$rs1, 
            GPR:$rs2, 
            GPR:$rs3, 
            QPR:$rs4, 
            QPR:$rs5,  
            (imm i32imm:$transA), 
            (imm i32imm:$transB)))
  ];*/
    let rd1 = 0b00000;
    let rd2 = 0b00000;
    let rs1 = 0b00000; 
    let rs2 = 0b00000;
    let rs3 = 0b00000;
    let rs4 = 0b00000;
    let rs5 = 0b00000;
    let rs6 = 0b00000;

    let funct7 = 0b0000111;
    let funct3 = 0b010;
  
}

def GEMMI32: GEMMInstr<0b001,"i32", int_ISOLDE_onnx_gemmi32>
 {
  // Define output and input operand lists
  let Size = 4;
  let OutOperandList = (outs QPR:$rd2);  
  let InOperandList = (ins GPR:$rd1,
                          GPR:$rs1,    
                          GPR:$rs2,    
                          GPR:$rs3,   
                          QPR:$rs4,    
                          QPR:$rs5,    
                          i32imm:$transA, 
                          i32imm:$transB);

  // Instruction pattern wrapped as  a list
  /*let Pattern = [
    (set QPR:$rd2, 
         (int_ISOLDE_onnx_gemmi32
            GPR:$rd1, 
            GPR:$rs1, 
            GPR:$rs2, 
            GPR:$rs3, 
            QPR:$rs4, 
            QPR:$rs5,  
            (imm i32imm:$transA), 
            (imm i32imm:$transB)))
  ];*/
    let rd1 = 0b00000;
    let rd2 = 0b00000;
    let rs1 = 0b00000; 
    let rs2 = 0b00000;
    let rs3 = 0b00000;
    let rs4 = 0b00000;
    let rs5 = 0b00000;
    let rs6 = 0b00000;

    let funct7 = 0b0000111;
    let funct3 = 0b010;
  
}

def GEMMI16 : GEMMInstr<0b010, "i16", int_ISOLDE_onnx_gemmi16> {
  // Define output and input operand lists
  let Size = 4;
  let OutOperandList = (outs QPR:$rd2);  
  let InOperandList = (ins GPR:$rd1,
                          GPR:$rs1,    
                          GPR:$rs2,    
                          GPR:$rs3,   
                          QPR:$rs4,    
                          QPR:$rs5,    
                          i32imm:$transA, 
                          i32imm:$transB);

  // Instruction pattern wrapped as  a list
  /*let Pattern = [
    (set QPR:$rd2, 
         (int_ISOLDE_onnx_gemmi16
            GPR:$rd1, 
            GPR:$rs1, 
            GPR:$rs2, 
            GPR:$rs3, 
            QPR:$rs4, 
            QPR:$rs5,  
            (imm i32imm:$transA), 
            (imm i32imm:$transB)))
  ];*/
    let rd1 = 0b00000;
    let rd2 = 0b00000;
    let rs1 = 0b00000; 
    let rs2 = 0b00000;
    let rs3 = 0b00000;
    let rs4 = 0b00000;
    let rs5 = 0b00000;
    let rs6 = 0b00000;

    let funct7 = 0b0000111;
    let funct3 = 0b010;
  
}

def GEMMI8 : GEMMInstr<0b011, "i8", int_ISOLDE_onnx_gemmi8>
 {
  // Define output and input operand lists
  let Size = 4;
  let OutOperandList = (outs QPR:$rd2);  
  let InOperandList = (ins GPR:$rd1,
                          GPR:$rs1,    
                          GPR:$rs2,    
                          GPR:$rs3,   
                          QPR:$rs4,    
                          QPR:$rs5,    
                          i32imm:$transA, 
                          i32imm:$transB);

  // Instruction pattern wrapped as  a list
  /*let Pattern = [
    (set QPR:$rd2, 
         (int_ISOLDE_onnx_gemmi8
            GPR:$rd1, 
            GPR:$rs1, 
            GPR:$rs2, 
            GPR:$rs3, 
            QPR:$rs4, 
            QPR:$rs5,  
            (imm i32imm:$transA), 
            (imm i32imm:$transB)))
  ];*/
    let rd1 = 0b00000;
    let rd2 = 0b00000;
    let rs1 = 0b00000; 
    let rs2 = 0b00000;
    let rs3 = 0b00000;
    let rs4 = 0b00000;
    let rs5 = 0b00000;
    let rs6 = 0b00000;

    let funct7 = 0b0000111;
    let funct3 = 0b010;
  
}

def PUSHQWORD
    : ISOLDERVInst32S <  ISOLDERV_PUSHQ.funct3,
                  (outs), 
                  (ins  QPR:$rs2, GPRMem:$rs1, simm12:$imm12),
                  "store","v4i32", 
                  "$rs2, ${imm12}(${rs1})",
                  [
                    ( set
                        ( int_ISOLDE_vse (  v4i32  QPR:$rs2)
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
    : ISOLDERVInst32I <  ISOLDERV_POPQ.funct3,
                  (outs  QPR:$rd), 
                  (ins   GPRMem:$rs1, simm12:$imm12),
                  "load","v4i32", 
                  "$rd, ${imm12}(${rs1})",
                  [ 
                    (set 
                        (v4i32 QPR:$rd), ( int_ISOLDE_vle (  i32    GPRMem:$rs1)
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