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

//include "llvm/IR/Intrinsics.td"

def OPC_64BIT     : RISCVOpcode<"64BIT",     0b0111111>;
def OPC_160BIT    : RISCVOpcode<"160BIT",    0b1111111>;

class ISOLDERVFunct7<string name, bits<7> val> {
  string Name = name;
  bits<7> Value = val;
}

class ISOLDERVOps <string name,bits<7> _opcode , bits<7> _funct7> {
  string Name = name;
  bits<7> funct7 = _funct7;
  bits<7> opcode = _opcode;
}

class ISOLDERVLSOps <string name,bits<7> _opcode , bits<3> _funct3> {
  string Name = name;
  bits<3> funct3 = _funct3;
  bits<7> opcode = _opcode;
}

def ISOLDERV_LOAD     : ISOLDERVOps<"LDQword",         OPC_160BIT.Value,    0b0000011>;
def ISOLDERV_GEMM     : ISOLDERVOps<"GEMMInstr",       OPC_64BIT.Value,     0b0000111>;
//32 bit OPC_CUSTOM_1.Value is reserved for custom  S-type /I-type
def ISOLDERV_PUSHQ           : ISOLDERVLSOps<"PUSHQInstr",    OPC_CUSTOM_1.Value,   0b001>;
def ISOLDERV_POPQ            : ISOLDERVLSOps<"POPQInstr",     OPC_CUSTOM_1.Value,   0b011>;

class ISOLDERVInst32< 
                     dag outs, dag ins, 
                     list<dag> pattern >
    : Instruction {
  field bits<32> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table. Must have the same size as Inst
  field bits<32> SoftFail = 0;
  let Size = 4; //number of bytes


  let Namespace = "RISCV";
  let OutOperandList = outs;
  let InOperandList = ins;  
  let Pattern = pattern;

  let Inst{6-0} = OPC_CUSTOM_0.Value;
}

 class ISOLDERVInst32S<bits<3> _funct3,
                         dag outs, dag ins, 
                         string opcodestr, string dt, string argstr, 
                         list<dag> pattern >
            : ISOLDERVInst32< outs, ins, pattern >{
  let AsmString = !strconcat(opcodestr, ".", dt, "\t", argstr);
  let TSFlags{4-0} = InstFormatS.Value;
  bits<12> imm12;
  bits<5> rs2;
  bits<5> rs1;
  bits<3> funct3 = _funct3;
  //
  let Inst{31-25} = imm12{11-5};
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = imm12{4-0};
//
  let Inst{6-0} = OPC_CUSTOM_1.Value;
}      

//
//I-type 32bit custom instruction
//
class ISOLDERVInst32I<bits<3> funct3,
                         dag outs, dag ins, 
                         string opcodestr, string dt, string argstr, 
                         list<dag> pattern >
            : ISOLDERVInst32< outs, ins, pattern >{
  let AsmString = !strconcat(opcodestr, ".", dt, "\t", argstr);
  let TSFlags{4-0} = InstFormatI.Value;
  bits<12> imm12;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-20} = imm12;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
//
  let Inst{6-0} = OPC_CUSTOM_1.Value;
}

class ISOLDERVInst160<dag outs, dag ins, string opcodestr, string argstr, bits<7> _funct7,
               list<dag> pattern>
    : Instruction {
  field bits<160> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  field bits<160> SoftFail = 0;
  let Size = 20;



  bits<5>  qd;
  bits<5>  rs1;
  bits<5>  rs2;

  bits<32> imm1;
  bits<32> imm2;
  bits<32> imm3;
  bits<32> imm4;
  bits<7>  funct7 =_funct7;

  let Namespace = "RISCV";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;

  //let TSFlags{4-0} = InstFormat160bit.Value;
  //first 32 bits
  let Inst{6-0} = OPC_160BIT.Value;
  let Inst{11-7} = qd;
  let Inst{14-12} = 0b101; //nnn=b101
  let Inst{19-15} = rs1; 
  let Inst{24-20} = rs2; 
  let Inst{31-25} = funct7; 
//immediate values
  let Inst{63-32} = imm1;
  let Inst{95-64} = imm2;
  let Inst{127-96} = imm3;
  let Inst{159-128} = imm4;

}

class ISOLDERVInst64< 
                     dag outs, dag ins, 
                     list<dag> pattern >
    : Instruction {
  field bits<64> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table. Must have the same size as Inst
  field bits<64> SoftFail = 0;
  let Size = 8; //number of bytes
  let TSFlags{4-0} = InstFormat64bit.Value;

  let Namespace = "RISCV";
  let OutOperandList = outs;
  let InOperandList = ins;  
  let Pattern = pattern;

  let Inst{6-0} = OPC_64BIT.Value;
}

class ISOLDERVV64Base< bits<7> _funct7, bits<3> _funct3, bits<3> _ext_funct3,dag outs, dag ins, string opcodestr, string dt, string argstr, 
            list<dag> pattern>
            : ISOLDERVInst64< outs, ins, pattern >{
  let AsmString = !strconcat(opcodestr, ".", dt, "\t", argstr);
  //let AsmString = opcodestr # "\t" # argstr;
  //let isPseudo = 1;
  
  bits<5>  rd1;
  bits<3>  funct3 = _funct3;
  bits<5>  rs1;
  bits<5>  rs2;
  bits<7>  funct7 =_funct7;
//extension
  bits<5>  rd2;
  bits<5>  rs3;
  bits<5>  rs4;
  bits<5>  rs5;
  bits<5>  rs6;

  //first 32 bits
  let Inst{31-25} = funct7; 
  let Inst{24-20} = rs2; 
  let Inst{19-15} = rs1; 
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd1;
  //Inst{6-0} equals OPC_64BIT.Value, already set in ISOLDERVInst64
//extension
  let Inst{63-62} = 0b00;
  let Inst{61-57} = rs6;
  let Inst{56-52} = rs5;
  let Inst{51-47} = rs4;
  let Inst{46-44} = _ext_funct3; 
  let Inst{43-39} = rd2;
  let Inst{38-37} = 0b00;
  let Inst{36-32} = rs3;
}

class ONNXBase< bits<7> _funct7, bits<3> _funct3,dag outs, dag ins, string opcodestr, string dt, string argstr, 
            list<dag> pattern>:ISOLDERVV64Base<  _funct7, _funct3, 0b000, outs,  ins,  opcodestr,  dt,  argstr,  pattern>;

class GEMMInstr < bits<3> funct3
                ,string Dt 
                ,SDPatternOperator IntOp >
    : ONNXBase <  ISOLDERV_GEMM.funct7,
                  funct3,
                  (outs QPR:$rd2), 
                  (ins GPR:$rd1, GPR:$rs1, QPR:$rs4, GPR:$rs2, QPR:$rs5, GPR:$rs3, i32imm:$transA, i32imm:$transB),
                  "gemm",Dt, 
                  "$rd1, $rd2, $rs1, $rs4, $rs2, $rs5, $rs3, $transA, $transB",
                  [
                    ( set 
                      
                        (v4i32 QPR:$rd2),  ( IntOp   (  iPTR  GPR:$rd1)
                                                  ,(  iPTR     GPR:$rs1)
                                                  ,(  v4i32    QPR:$rs4)
                                                  ,(  iPTR     GPR:$rs2)
                                                  ,(  v4i32    QPR:$rs5)
                                                  ,(  iPTR     GPR:$rs3)
                                                  ,(  i32       imm:$transA)
                                                  ,(  i32       imm:$transB)
                                                  
                          
                          )
                    )
                    
                  ]
                >
                {
  //
  bits<32>  transA;
  bits<32>  transB;
  let Inst{39-32} = transA{7-0}; // Example encoding for an 8-bit slice
  let Inst{47-40} = transB{7-0}; // Extend as needed
  let rs6 = 0b00000; //it should hold alpha and beta paramaeters, f32 format
  let hasSideEffects = true;
  let mayLoad = true;
  let mayStore = true;
}
