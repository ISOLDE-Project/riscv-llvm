// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs --replace-value-regex "__omp_offloading_[0-9a-z]+_[0-9a-z]+" "reduction_  size[.].+[.]" "pl_cond[.].+[.|,]" --prefix-filecheck-ir-name _
// RUN: %clang_cc1 -fopenmp-enable-irbuilder -verify -fopenmp -fopenmp-version=45 -x c++ -triple x86_64-unknown-unknown -emit-llvm %s -o - | FileCheck %s
// expected-no-diagnostics

#ifndef HEADER
#define HEADER


extern "C" void workshareloop_unsigned_down(float *a) {
#pragma omp for
  for (unsigned i = 32000000; i > 33; i -= 7) {
    a[i] = i;
  }
}

#endif // HEADER





// CHECK-LABEL: define {{[^@]+}}@workshareloop_unsigned_down
// CHECK-SAME: (ptr noundef [[A:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[AGG_CAPTURED:%.*]] = alloca [[STRUCT_ANON:%.*]], align 8
// CHECK-NEXT:    [[AGG_CAPTURED1:%.*]] = alloca [[STRUCT_ANON_0:%.*]], align 4
// CHECK-NEXT:    [[DOTCOUNT_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_LASTITER:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_LOWERBOUND:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_UPPERBOUND:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_STRIDE:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store i32 32000000, ptr [[I]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [[STRUCT_ANON]], ptr [[AGG_CAPTURED]], i32 0, i32 0
// CHECK-NEXT:    store ptr [[I]], ptr [[TMP0]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_ANON_0]], ptr [[AGG_CAPTURED1]], i32 0, i32 0
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    store i32 [[TMP2]], ptr [[TMP1]], align 4
// CHECK-NEXT:    call void @__captured_stmt(ptr [[DOTCOUNT_ADDR]], ptr [[AGG_CAPTURED]])
// CHECK-NEXT:    [[DOTCOUNT:%.*]] = load i32, ptr [[DOTCOUNT_ADDR]], align 4
// CHECK-NEXT:    br label [[OMP_LOOP_PREHEADER:%.*]]
// CHECK:       omp_loop.preheader:
// CHECK-NEXT:    store i32 0, ptr [[P_LOWERBOUND]], align 4
// CHECK-NEXT:    [[TMP3:%.*]] = sub i32 [[DOTCOUNT]], 1
// CHECK-NEXT:    store i32 [[TMP3]], ptr [[P_UPPERBOUND]], align 4
// CHECK-NEXT:    store i32 1, ptr [[P_STRIDE]], align 4
// CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(ptr @[[GLOB1:[0-9]+]])
// CHECK-NEXT:    call void @__kmpc_for_static_init_4u(ptr @[[GLOB1]], i32 [[OMP_GLOBAL_THREAD_NUM]], i32 34, ptr [[P_LASTITER]], ptr [[P_LOWERBOUND]], ptr [[P_UPPERBOUND]], ptr [[P_STRIDE]], i32 1, i32 0)
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[P_LOWERBOUND]], align 4
// CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr [[P_UPPERBOUND]], align 4
// CHECK-NEXT:    [[TMP6:%.*]] = sub i32 [[TMP5]], [[TMP4]]
// CHECK-NEXT:    [[TMP7:%.*]] = add i32 [[TMP6]], 1
// CHECK-NEXT:    br label [[OMP_LOOP_HEADER:%.*]]
// CHECK:       omp_loop.header:
// CHECK-NEXT:    [[OMP_LOOP_IV:%.*]] = phi i32 [ 0, [[OMP_LOOP_PREHEADER]] ], [ [[OMP_LOOP_NEXT:%.*]], [[OMP_LOOP_INC:%.*]] ]
// CHECK-NEXT:    br label [[OMP_LOOP_COND:%.*]]
// CHECK:       omp_loop.cond:
// CHECK-NEXT:    [[OMP_LOOP_CMP:%.*]] = icmp ult i32 [[OMP_LOOP_IV]], [[TMP7]]
// CHECK-NEXT:    br i1 [[OMP_LOOP_CMP]], label [[OMP_LOOP_BODY:%.*]], label [[OMP_LOOP_EXIT:%.*]]
// CHECK:       omp_loop.body:
// CHECK-NEXT:    [[TMP8:%.*]] = add i32 [[OMP_LOOP_IV]], [[TMP4]]
// CHECK-NEXT:    call void @__captured_stmt.1(ptr [[I]], i32 [[TMP8]], ptr [[AGG_CAPTURED1]])
// CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[CONV:%.*]] = uitofp i32 [[TMP9]] to float
// CHECK-NEXT:    [[TMP10:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP11:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[IDXPROM:%.*]] = zext i32 [[TMP11]] to i64
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, ptr [[TMP10]], i64 [[IDXPROM]]
// CHECK-NEXT:    store float [[CONV]], ptr [[ARRAYIDX]], align 4
// CHECK-NEXT:    br label [[OMP_LOOP_INC]]
// CHECK:       omp_loop.inc:
// CHECK-NEXT:    [[OMP_LOOP_NEXT]] = add nuw i32 [[OMP_LOOP_IV]], 1
// CHECK-NEXT:    br label [[OMP_LOOP_HEADER]]
// CHECK:       omp_loop.exit:
// CHECK-NEXT:    call void @__kmpc_for_static_fini(ptr @[[GLOB1]], i32 [[OMP_GLOBAL_THREAD_NUM]])
// CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM2:%.*]] = call i32 @__kmpc_global_thread_num(ptr @[[GLOB1]])
// CHECK-NEXT:    call void @__kmpc_barrier(ptr @[[GLOB2:[0-9]+]], i32 [[OMP_GLOBAL_THREAD_NUM2]])
// CHECK-NEXT:    br label [[OMP_LOOP_AFTER:%.*]]
// CHECK:       omp_loop.after:
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define {{[^@]+}}@__captured_stmt
// CHECK-SAME: (ptr noundef nonnull align 4 dereferenceable(4) [[DISTANCE:%.*]], ptr noalias noundef [[__CONTEXT:%.*]]) #[[ATTR1:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DISTANCE_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[__CONTEXT_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTSTART:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTSTOP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTSTEP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store ptr [[DISTANCE]], ptr [[DISTANCE_ADDR]], align 8
// CHECK-NEXT:    store ptr [[__CONTEXT]], ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_ANON:%.*]], ptr [[TMP0]], i32 0, i32 0
// CHECK-NEXT:    [[TMP2:%.*]] = load ptr, ptr [[TMP1]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[TMP2]], align 4
// CHECK-NEXT:    store i32 [[TMP3]], ptr [[DOTSTART]], align 4
// CHECK-NEXT:    store i32 33, ptr [[DOTSTOP]], align 4
// CHECK-NEXT:    store i32 -7, ptr [[DOTSTEP]], align 4
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[DOTSTART]], align 4
// CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr [[DOTSTOP]], align 4
// CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[TMP4]], [[TMP5]]
// CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
// CHECK:       cond.true:
// CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[DOTSTART]], align 4
// CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[DOTSTOP]], align 4
// CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[TMP6]], [[TMP7]]
// CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[DOTSTEP]], align 4
// CHECK-NEXT:    [[SUB1:%.*]] = sub nsw i32 0, [[TMP8]]
// CHECK-NEXT:    [[SUB2:%.*]] = sub i32 [[SUB1]], 1
// CHECK-NEXT:    [[ADD:%.*]] = add i32 [[SUB]], [[SUB2]]
// CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[DOTSTEP]], align 4
// CHECK-NEXT:    [[SUB3:%.*]] = sub nsw i32 0, [[TMP9]]
// CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[ADD]], [[SUB3]]
// CHECK-NEXT:    br label [[COND_END:%.*]]
// CHECK:       cond.false:
// CHECK-NEXT:    br label [[COND_END]]
// CHECK:       cond.end:
// CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[DIV]], [[COND_TRUE]] ], [ 0, [[COND_FALSE]] ]
// CHECK-NEXT:    [[TMP10:%.*]] = load ptr, ptr [[DISTANCE_ADDR]], align 8
// CHECK-NEXT:    store i32 [[COND]], ptr [[TMP10]], align 4
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define {{[^@]+}}@__captured_stmt.1
// CHECK-SAME: (ptr noundef nonnull align 4 dereferenceable(4) [[LOOPVAR:%.*]], i32 noundef [[LOGICAL:%.*]], ptr noalias noundef [[__CONTEXT:%.*]]) #[[ATTR1]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[LOOPVAR_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[LOGICAL_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[__CONTEXT_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[LOOPVAR]], ptr [[LOOPVAR_ADDR]], align 8
// CHECK-NEXT:    store i32 [[LOGICAL]], ptr [[LOGICAL_ADDR]], align 4
// CHECK-NEXT:    store ptr [[__CONTEXT]], ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_ANON_0:%.*]], ptr [[TMP0]], i32 0, i32 0
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[TMP1]], align 4
// CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[LOGICAL_ADDR]], align 4
// CHECK-NEXT:    [[MUL:%.*]] = mul i32 -7, [[TMP3]]
// CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP2]], [[MUL]]
// CHECK-NEXT:    [[TMP4:%.*]] = load ptr, ptr [[LOOPVAR_ADDR]], align 8
// CHECK-NEXT:    store i32 [[ADD]], ptr [[TMP4]], align 4
// CHECK-NEXT:    ret void
//