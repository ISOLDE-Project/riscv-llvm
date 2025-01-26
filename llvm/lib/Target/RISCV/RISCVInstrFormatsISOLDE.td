//===-- RISCVInstrFormatsISOLDE.td - RISC-V ISOLDE Instruction Formats -*- tablegen -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file describes the RISC-V ISOLDE extension instruction formats.
//
//===----------------------------------------------------------------------===//

//def OPC_32BIT_0   : RISCVOpcode<"32BIT_0",   0b1011011>;
def OPC_64BIT     : RISCVOpcode<"64BIT",     0b0111111>;
//>=80bit custom instructions  share th same opcode
def OPC_96BIT     : RISCVOpcode<"96BIT",     0b1111111>; 
def OPC_160BIT    : RISCVOpcode<"160BIT",    0b1111111>; 

class ISOLDEOps <string name,bits<7> _opcode , bits<7> _funct7> {
  string Name = name;
  bits<7> funct7 = _funct7;
  bits<7> opcode = _opcode;
}

class ISOLDELSOps <string name,bits<7> _opcode , bits<3> _funct3> {
  string Name = name;
  bits<3> funct3 = _funct3;
  bits<7> opcode = _opcode;
}

//160 bit
def ISOLDE_LOADQ            : ISOLDEOps<"LDQword",         OPC_160BIT.Value,    0b0000011>;


//32 bit OPC_CUSTOM_1.Value is reserved for custom  S-type /I-type
def ISOLDE_PUSHQ           : ISOLDELSOps<"PUSHQInstr",    OPC_CUSTOM_1.Value,   0b001>;
def ISOLDE_POPQ            : ISOLDELSOps<"POPQInstr",     OPC_CUSTOM_1.Value,   0b011>;


//32 bit custom-0
class ISOLDEInst32< 
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

//
//S-type 32bit custom instruction
//

 class ISOLDEInst32S<bits<3> _funct3,
                         dag outs, dag ins, 
                         string opcodestr, string dt, string argstr, 
                         list<dag> pattern >
            : ISOLDEInst32< outs, ins, pattern >{
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
class ISOLDEInst32I<bits<3> funct3,
                         dag outs, dag ins, 
                         string opcodestr, string dt, string argstr, 
                         list<dag> pattern >
            : ISOLDEInst32< outs, ins, pattern >{
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


class ISOLDEInst160<dag outs, dag ins, string opcodestr, string argstr, bits<7> _funct7,
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

  let TSFlags{4-0} = InstFormat160bit.Value;
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
