; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the bcmp library call simplifier works correctly.
;
; RUN: opt < %s -passes=instcombine -mtriple=x86_64-unknown-linux-gnu -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32:64"

@foo = constant [4 x i8] c"foo\00"
@hel = constant [4 x i8] c"hel\00"
@hello_u = constant [8 x i8] c"hello_u\00"

declare i32 @bcmp(ptr, ptr, i32)

; Check bcmp(mem, mem, size) -> 0.

define i32 @test_simplify1(ptr %mem, i32 %size) {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    ret i32 0
;
  %ret = call i32 @bcmp(ptr %mem, ptr %mem, i32 %size)
  ret i32 %ret
}

; Check bcmp(mem1, mem2, 0) -> 0.

define i32 @test_simplify2(ptr %mem1, ptr %mem2) {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    ret i32 0
;
  %ret = call i32 @bcmp(ptr %mem1, ptr %mem2, i32 0)
  ret i32 %ret
}

;; Check bcmp(mem1, mem2, 1) -> *(unsigned char*)mem1 - *(unsigned char*)mem2.

define i32 @test_simplify3(ptr %mem1, ptr %mem2) {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    [[LHSC:%.*]] = load i8, ptr [[MEM1:%.*]], align 1
; CHECK-NEXT:    [[LHSV:%.*]] = zext i8 [[LHSC]] to i32
; CHECK-NEXT:    [[RHSC:%.*]] = load i8, ptr [[MEM2:%.*]], align 1
; CHECK-NEXT:    [[RHSV:%.*]] = zext i8 [[RHSC]] to i32
; CHECK-NEXT:    [[CHARDIFF:%.*]] = sub nsw i32 [[LHSV]], [[RHSV]]
; CHECK-NEXT:    ret i32 [[CHARDIFF]]
;
  %ret = call i32 @bcmp(ptr %mem1, ptr %mem2, i32 1)
  ret i32 %ret
}

; Check bcmp(mem1, mem2, size) -> cnst, where all arguments are constants.

define i32 @test_simplify4() {
; CHECK-LABEL: @test_simplify4(
; CHECK-NEXT:    ret i32 0
;
  %ret = call i32 @bcmp(ptr @hel, ptr @hello_u, i32 3)
  ret i32 %ret
}

define i32 @test_simplify5() {
; CHECK-LABEL: @test_simplify5(
; CHECK-NEXT:    ret i32 1
;
  %ret = call i32 @bcmp(ptr @hel, ptr @foo, i32 3)
  ret i32 %ret
}

define i32 @test_simplify6() {
; CHECK-LABEL: @test_simplify6(
; CHECK-NEXT:    ret i32 -1
;
  %ret = call i32 @bcmp(ptr @foo, ptr @hel, i32 3)
  ret i32 %ret
}

; Check bcmp(mem1, mem2, 8)==0 -> *(int64_t*)mem1 == *(int64_t*)mem2

define i1 @test_simplify7(i64 %x, i64 %y) {
; CHECK-LABEL: @test_simplify7(
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[DOTNOT]]
;
  %x.addr = alloca i64, align 8
  %y.addr = alloca i64, align 8
  store i64 %x, ptr %x.addr, align 8
  store i64 %y, ptr %y.addr, align 8
  %call = call i32 @bcmp(ptr %x.addr, ptr %y.addr, i32 8)
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}

; Check bcmp(mem1, mem2, 4)==0 -> *(int32_t*)mem1 == *(int32_t*)mem2

define i1 @test_simplify8(i32 %x, i32 %y) {
; CHECK-LABEL: @test_simplify8(
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[DOTNOT]]
;
  %x.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  store i32 %x, ptr %x.addr, align 4
  store i32 %y, ptr %y.addr, align 4
  %call = call i32 @bcmp(ptr %x.addr, ptr %y.addr, i32 4)
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}

; Check bcmp(mem1, mem2, 2)==0 -> *(int16_t*)mem1 == *(int16_t*)mem2

define i1 @test_simplify9(i16 %x, i16 %y) {
; CHECK-LABEL: @test_simplify9(
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[DOTNOT]]
;
  %x.addr = alloca i16, align 2
  %y.addr = alloca i16, align 2
  store i16 %x, ptr %x.addr, align 2
  store i16 %y, ptr %y.addr, align 2
  %call = call i32 @bcmp(ptr %x.addr, ptr %y.addr, i32 2)
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}

define i1 @test_simplify10(ptr %mem1, ptr %mem2, i32 %size) {
; CHECK-LABEL: @test_simplify10(
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @bcmp(ptr [[MEM1:%.*]], ptr [[MEM2:%.*]], i32 [[SIZE:%.*]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call i32 @bcmp(ptr %mem1, ptr %mem2, i32 %size)
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}