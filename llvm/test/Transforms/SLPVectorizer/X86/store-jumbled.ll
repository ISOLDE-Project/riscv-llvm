; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -mtriple=x86_64-unknown -mattr=+avx -passes=slp-vectorizer | FileCheck %s



define i32 @jumbled-load(ptr noalias nocapture %in, ptr noalias nocapture %inn, ptr noalias nocapture %out) {
; CHECK-LABEL: @jumbled-load(
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr [[IN:%.*]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x i32>, ptr [[INN:%.*]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = mul <4 x i32> [[TMP2]], [[TMP4]]
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i32> [[TMP5]], <4 x i32> poison, <4 x i32> <i32 1, i32 3, i32 0, i32 2>
; CHECK-NEXT:    store <4 x i32> [[SHUFFLE]], ptr [[OUT:%.*]], align 4
; CHECK-NEXT:    ret i32 undef
;
  %load.1 = load i32, ptr %in, align 4
  %gep.1 = getelementptr inbounds i32, ptr %in, i64 1
  %load.2 = load i32, ptr %gep.1, align 4
  %gep.2 = getelementptr inbounds i32, ptr %in, i64 2
  %load.3 = load i32, ptr %gep.2, align 4
  %gep.3 = getelementptr inbounds i32, ptr %in, i64 3
  %load.4 = load i32, ptr %gep.3, align 4
  %load.5 = load i32, ptr %inn, align 4
  %gep.4 = getelementptr inbounds i32, ptr %inn, i64 1
  %load.6 = load i32, ptr %gep.4, align 4
  %gep.5 = getelementptr inbounds i32, ptr %inn, i64 2
  %load.7 = load i32, ptr %gep.5, align 4
  %gep.6 = getelementptr inbounds i32, ptr %inn, i64 3
  %load.8 = load i32, ptr %gep.6, align 4
  %mul.1 = mul i32 %load.1, %load.5
  %mul.2 = mul i32 %load.2, %load.6
  %mul.3 = mul i32 %load.3, %load.7
  %mul.4 = mul i32 %load.4, %load.8
  %gep.8 = getelementptr inbounds i32, ptr %out, i64 1
  %gep.9 = getelementptr inbounds i32, ptr %out, i64 2
  %gep.10 = getelementptr inbounds i32, ptr %out, i64 3
  store i32 %mul.1, ptr %gep.9, align 4
  store i32 %mul.2, ptr %out, align 4
  store i32 %mul.3, ptr %gep.10, align 4
  store i32 %mul.4, ptr %gep.8, align 4

  ret i32 undef
}