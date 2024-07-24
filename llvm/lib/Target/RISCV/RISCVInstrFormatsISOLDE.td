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

def OPC_64BIT     : RISCVOpcode<"64BIT",     0b0111111>;
def OPC_160BIT    : RISCVOpcode<"160BIT",    0b1111111>;

class ContiRVFunct7<string name, bits<7> val> {
  string Name = name;
  bits<7> Value = val;
}

class ISOLDERVOps <string name,bits<7> _opcode , bits<7> _funct7> {
  string Name = name;
  bits<7> funct7 = _funct7;
  bits<7> opcode = _opcode;
}

def CONTIRV_LOAD      : ContiRVFunct7<"LOAD",      0b0000011>;
def ISOLDERV_LOAD     : ISOLDERVOps<"LDQword",         OPC_160BIT.Value,    0b0000011>;

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