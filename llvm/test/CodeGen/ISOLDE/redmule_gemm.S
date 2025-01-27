// COM:  this line is a comment
// COM:  cd /home/uic52463/hdd1/c2023-riscv/toolchain/riscv-llvm
// COM:  build/bin/llvm-lit   llvm/test/CodeGen/Conti/dsp.S
// RUN: llvm-mc --arch=riscv32  -show-encoding  < %s | FileCheck %s

 redmule.gemm    a0, a1, a2, 10, 20, 30
 redmule.gemm    t2, t0, t1, 0x10, 0xc, 0x10