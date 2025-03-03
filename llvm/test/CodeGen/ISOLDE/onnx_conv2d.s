// COM:  this line is a comment
// RUN: llvm-mc --arch=riscv32  -show-encoding  < %s | FileCheck %s

 
onnx.conv2d.f32 a0, Q0, s2, Q3, s1, Q2, s0, Q1, Q0

// CHECK:          onnx.conv2d.f32 a0, Q0, s2, Q3, s1, Q2, s0, Q1, Q0 # encoding: [0x7f,0x15,0x99,0x00,0x00,0x80,0x21,0x10,0x00,0x80,0x00,0x00]
