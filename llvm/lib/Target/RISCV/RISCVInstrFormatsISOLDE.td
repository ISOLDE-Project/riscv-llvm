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
def OPC_128BIT    : RISCVOpcode<"128BIT",    0b1111111>; 
def OPC_160BIT    : RISCVOpcode<"160BIT",    0b1111111>; 


//
class ISOLDE_OP_TYPE <string _type, bits<3> _funct3> {
  string   opstype =   _type;
  bits<3>  funct3         =   _funct3;
}

def ISOLDE_OP_F32 : ISOLDE_OP_TYPE<"f32",0b000>;

class ISOLDEOps <string _name,bits<7> _opcode , bits<7> _funct7> {
  string name = _name;
  bits<7> funct7 = _funct7;
  bits<7> opcode = _opcode;
}

class ISOLDELSOps <string name,bits<7> _opcode , bits<3> _funct3> {
  string Name = name;
  bits<3> funct3 = _funct3;
  bits<7> opcode = _opcode;
}

//160 bit
def ISOLDE_LOAD_4XI32       : ISOLDEOps<"ld4xi32",           OPC_160BIT.Value,    0b0000011>;
//128 bit
def ISOLDE_LOAD_3XI32       : ISOLDEOps<"ld3xi32",           OPC_128BIT.Value,    0b0000011>;
def ISOLDE_REDMULE_GEMM     : ISOLDEOps<"redmule.gemm",      OPC_128BIT.Value,    0b0000100>;

//96 bit
def ISOLDE_ONNX_CONV2D      : ISOLDEOps<"onnx.conv2d",       OPC_96BIT.Value,     0b0000000>;
def ISOLDE_LOAD_2XI32       : ISOLDEOps<"ld2xi32",           OPC_96BIT.Value,     0b0000011>;

//32 bit OPC_CUSTOM_1.Value is reserved for custom  S-type /I-type
def ISOLDE_REDMULE_GEMM2 : ISOLDELSOps<"redmule.gemm2", OPC_CUSTOM_1.Value,   0b000>;

def ISOLDE_PUSHQ            : ISOLDELSOps<"PUSHQInstr",      OPC_CUSTOM_1.Value,   0b001>;
def ISOLDE_POPQ             : ISOLDELSOps<"POPQInstr",       OPC_CUSTOM_1.Value,   0b011>;


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

class ISOLDEInst32Ext<bits<3> _funct3,
                      dag outs, dag ins, 
                      string opcodestr, string dt, string argstr, 
                      list<dag> pattern>
    : ISOLDEInst32< outs, ins, pattern > {
  
  let AsmString = !strconcat(opcodestr, ".", dt, "\t", argstr);
  let TSFlags{4-0} = InstFormatS.Value;

  bits<5> rd;
  bits<5> rs1;
  bits<5> rs2;
  bits<5> rs3;   
  bits<3> funct3 = _funct3;

 
  let Inst{6-0}   = OPC_CUSTOM_1.Value;     
  let Inst{11-7}  = rd;
  let Inst{14-12} = funct3;        
  let Inst{19-15} = rs1;
  let Inst{24-20} = rs2;
  let Inst{29-25} = rs3;           
  let Inst{31-30} = 0b00;               
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


//96bit
class ISOLDEInst96<dag outs, dag ins, string opcodestr, string argstr, bits<7> _funct7,
               list<dag> pattern>
    : Instruction {
  field bits<96> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  field bits<96> SoftFail = 0;
  let Size = 12;



  bits<5>  rd;
  bits<5>  rs1;
  bits<5>  rs2;

  bits<32> imm1;
  bits<32> imm2;
  
  
  bits<7>  funct7 =_funct7;

  let Namespace = "RISCV";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;

  let TSFlags{4-0} = InstFormat96bit.Value;
  //first 32 bits
  let Inst{6-0} = OPC_96BIT.Value;
  let Inst{11-7} = rd;
  let Inst{14-12} = 0b001; //nnn = 1, instrLen = 80+16*1 = 96 bits
  let Inst{19-15} = rs1; 
  let Inst{24-20} = rs2; 
  let Inst{31-25} = funct7; 
//immediate values
  let Inst{63-32} = imm1;
  let Inst{95-64} = imm2;
}

//96bit
class ISOLDEInst96R<dag outs, dag ins
                        ,string opcodestr, string opstype, string argstr 
                        ,bits<7> _funct7, bits<3> _funct3
                        ,list<dag> pattern>
    : Instruction {
  field bits<96> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  field bits<96> SoftFail = 0;
  let Size = 12;



  bits<5>  rd;
  bits<5>  rd2;
  bits<5>  rd3;
  //
  bits<5>  rs1;
  bits<5>  rs3;
  bits<5>  rs6;
  //
  bits<5>  rs2;
  bits<5>  rs4;
  bits<5>  rs7;
  //
  bits<5>  rs5;
  bits<5>  rs8;
  
  
  bits<7>  funct7 =_funct7;

  let Namespace = "RISCV";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = !strconcat(opcodestr, ".", opstype, "\t", argstr);
  let Pattern = pattern;

  let TSFlags{4-0} = InstFormat96bit.Value;
  //BASE
  let Inst{6-0} = OPC_96BIT.Value;
  let Inst{11-7} = rd;
  let Inst{14-12} = 0b001; //nnn = 1, instrLen = 80+16*1 = 96 bits
  let Inst{19-15} = rs1; 
  let Inst{24-20} = rs2; 
  let Inst{31-25} = funct7; 
  //BASE + 4
  let Inst{38-32} = 0;
  let Inst{43-39} = rd2;
  let Inst{46-44} = _funct3; 
  let Inst{51-47} = rs3; 
  let Inst{56-52} = rs4; 
  let Inst{61-57} = rs5;
  let Inst{63-62} = 0b00; //reserved
  //BASE + 8
  let Inst{70-64} = 0;
  let Inst{75-71} = rd3;
  let Inst{78-76} = 0b000; //reserved
  let Inst{83-79} = rs6; 
  let Inst{88-84} = rs7; 
  let Inst{93-89} = rs8;
  let Inst{95-94} = 0b00; //reserved
}

//128bit
class ISOLDEInst128<dag outs, dag ins, string opcodestr, string argstr, bits<7> _funct7,
               list<dag> pattern>
    : Instruction {
  field bits<128> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  field bits<128> SoftFail = 0;
  let Size = 16;



  bits<5>  rd;
  bits<5>  rs1;
  bits<5>  rs2;

  bits<32> imm1;
  bits<32> imm2;
  bits<32> imm3;
  
  bits<7>  funct7 =_funct7;

  let Namespace = "RISCV";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;

  let TSFlags{4-0} = InstFormat128bit.Value;
  //first 32 bits
  let Inst{6-0} = OPC_128BIT.Value;
  let Inst{11-7} = rd;
  let Inst{14-12} = 0b011; //nnn = 3, instrLen = 80+16*3 = 128 bits
  let Inst{19-15} = rs1; 
  let Inst{24-20} = rs2; 
  let Inst{31-25} = funct7; 
//immediate values
  let Inst{63-32} = imm1;
  let Inst{95-64} = imm2;
  let Inst{127-96} = imm3;
}

//160 bit
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