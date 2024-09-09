#!/bin/bash

#TO RUN THE SCRIPT PLEASE USE ./run_tests.sh in ISOLDE TEST FOLDER

#1.You need to add PATH to LLC , please be careful to change /home/uig89066/Desktop/Work with your full path to llc .
LLC_PATH="/home/uig89066/Desktop/Work/task5.2/toolchain/riscv-llvm/build/bin/llc"

#2.Here you add test's that you need to compile .
TESTS=(
    "/home/uig89066/Desktop/Work/task5.2/toolchain/riscv-llvm/llvm/test/CodeGen/ISOLDE/test_build_vector.ll"
    "/home/uig89066/Desktop/Work/task5.2/toolchain/riscv-llvm/llvm/test/CodeGen/ISOLDE/test_q.ll"
    "/home/uig89066/Desktop/Work/task5.2/toolchain/riscv-llvm/llvm/test/CodeGen/ISOLDE/test_n_q.ll"
)

#3.Here you add options for llc .
OPTIONS="-mtriple=riscv32 -mattr=+v -target-abi=ilp32d -filetype=asm"

# Run llc on the test files .
if [ -x "$LLC_PATH" ]; then
    echo "Running llc on the following test files:"
    for TEST in "${TESTS[@]}"; do
        if [ -f "$TEST" ]; then
            echo "Compiling: $TEST"
            "$LLC_PATH" $OPTIONS -o - "$TEST"
        else
            echo "Test file not found: $TEST"
        fi
    done
else
    echo "llc not found at the specified path: $LLC_PATH"
    exit 1
fi
