// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 2
// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +zve32x -O0 \
// RUN:   -emit-llvm %s -o - | FileCheck %s --check-prefix=O0
// RUN: %clang_cc1 -triple riscv64 -target-feature +zve32x -disable-O0-optnone \
// RUN:   -emit-llvm %s -o - | opt -S -passes=mem2reg | FileCheck %s --check-prefix=AFTER_MEM2REG

// This test case tests the lowering of RVV tuple types into LLVM IR.

#include <riscv_vector.h>

// Declare local variable
// O0-LABEL: define dso_local void @foo
// O0-SAME: () #[[ATTR0:[0-9]+]] {
// O0-NEXT:  entry:
// O0-NEXT:    [[V_TUPLE:%.*]] = alloca { <vscale x 2 x i32>, <vscale x 2 x i32> }, align 4
// O0-NEXT:    ret void
//
// AFTER_MEM2REG-LABEL: define dso_local void @foo
// AFTER_MEM2REG-SAME: () #[[ATTR0:[0-9]+]] {
// AFTER_MEM2REG-NEXT:  entry:
// AFTER_MEM2REG-NEXT:    ret void
//
void foo() {
  __rvv_int32m1x2_t v_tuple;
}

// Declare local variable and return
// O0-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @bar
// O0-SAME: () #[[ATTR0]] {
// O0-NEXT:  entry:
// O0-NEXT:    [[V_TUPLE:%.*]] = alloca { <vscale x 2 x i32>, <vscale x 2 x i32> }, align 4
// O0-NEXT:    [[TMP0:%.*]] = load { <vscale x 2 x i32>, <vscale x 2 x i32> }, ptr [[V_TUPLE]], align 4
// O0-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]]
//
// AFTER_MEM2REG-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @bar
// AFTER_MEM2REG-SAME: () #[[ATTR0]] {
// AFTER_MEM2REG-NEXT:  entry:
// AFTER_MEM2REG-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } undef
//
__rvv_int32m1x2_t bar() {
  __rvv_int32m1x2_t v_tuple;
  return v_tuple;
}

// Pass as function parameter
// O0-LABEL: define dso_local void @baz
// O0-SAME: ({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE:%.*]]) #[[ATTR0]] {
// O0-NEXT:  entry:
// O0-NEXT:    [[V_TUPLE_ADDR:%.*]] = alloca { <vscale x 2 x i32>, <vscale x 2 x i32> }, align 4
// O0-NEXT:    store { <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE]], ptr [[V_TUPLE_ADDR]], align 4
// O0-NEXT:    ret void
//
// AFTER_MEM2REG-LABEL: define dso_local void @baz
// AFTER_MEM2REG-SAME: ({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE:%.*]]) #[[ATTR0]] {
// AFTER_MEM2REG-NEXT:  entry:
// AFTER_MEM2REG-NEXT:    ret void
//
void baz(__rvv_int32m1x2_t v_tuple) {
}

// Pass as function parameter and return
// O0-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @qux
// O0-SAME: ({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE:%.*]]) #[[ATTR0]] {
// O0-NEXT:  entry:
// O0-NEXT:    [[V_TUPLE_ADDR:%.*]] = alloca { <vscale x 2 x i32>, <vscale x 2 x i32> }, align 4
// O0-NEXT:    store { <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE]], ptr [[V_TUPLE_ADDR]], align 4
// O0-NEXT:    [[TMP0:%.*]] = load { <vscale x 2 x i32>, <vscale x 2 x i32> }, ptr [[V_TUPLE_ADDR]], align 4
// O0-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]]
//
// AFTER_MEM2REG-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @qux
// AFTER_MEM2REG-SAME: ({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE:%.*]]) #[[ATTR0]] {
// AFTER_MEM2REG-NEXT:  entry:
// AFTER_MEM2REG-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE]]
//
__rvv_int32m1x2_t qux(__rvv_int32m1x2_t v_tuple) {
  return v_tuple;
}

// O0-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @quux
// O0-SAME: ({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE:%.*]]) #[[ATTR0]] {
// O0-NEXT:  entry:
// O0-NEXT:    [[V_TUPLE_ADDR:%.*]] = alloca { <vscale x 2 x i32>, <vscale x 2 x i32> }, align 4
// O0-NEXT:    store { <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE]], ptr [[V_TUPLE_ADDR]], align 4
// O0-NEXT:    [[TMP0:%.*]] = load { <vscale x 2 x i32>, <vscale x 2 x i32> }, ptr [[V_TUPLE_ADDR]], align 4
// O0-NEXT:    [[CALL:%.*]] = call { <vscale x 2 x i32>, <vscale x 2 x i32> } @qux({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]])
// O0-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } [[CALL]]
//
// AFTER_MEM2REG-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @quux
// AFTER_MEM2REG-SAME: ({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE:%.*]]) #[[ATTR0]] {
// AFTER_MEM2REG-NEXT:  entry:
// AFTER_MEM2REG-NEXT:    [[CALL:%.*]] = call { <vscale x 2 x i32>, <vscale x 2 x i32> } @qux({ <vscale x 2 x i32>, <vscale x 2 x i32> } [[V_TUPLE]])
// AFTER_MEM2REG-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } [[CALL]]
//
__rvv_int32m1x2_t quux(__rvv_int32m1x2_t v_tuple) {
  return qux(v_tuple);
}