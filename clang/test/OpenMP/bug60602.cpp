// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --include-generated-funcs --replace-value-regex "__omp_offloading_[0-9a-z]+_[0-9a-z]+" "reduction_size[.].+[.]" "pl_cond[.].+[.|,]" --prefix-filecheck-ir-name _ --version 2
// Test host codegen.
// RUN: %clang_cc1 -verify -fopenmp -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-llvm %s -o - | FileCheck %s
// expected-no-diagnostics

int kernel_within_loop(int *a, int *b, int N, int num_iters) {
  int i;
  for (i = 0; i < num_iters; ++i) {
#pragma omp target parallel for map(a[0:N]) map(b[0:N])
    for (int j = 0; j< N; j++)
      a[j] = b[j];

#pragma omp target teams distribute parallel for map(a[0:N]) map(b[0:N])
    for (int j = 0; j< N; j+=3)
      a[j] = b[j] * 2;
  }
  return a[N-1];
}
// CHECK-LABEL: define dso_local noundef signext i32 @_Z18kernel_within_loopPiS_ii
// CHECK-SAME: (ptr noundef [[A:%.*]], ptr noundef [[B:%.*]], i32 noundef signext [[N:%.*]], i32 noundef signext [[NUM_ITERS:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[NUM_ITERS_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[N_CASTED:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[DOTOFFLOAD_BASEPTRS:%.*]] = alloca [3 x ptr], align 8
// CHECK-NEXT:    [[DOTOFFLOAD_PTRS:%.*]] = alloca [3 x ptr], align 8
// CHECK-NEXT:    [[DOTOFFLOAD_MAPPERS:%.*]] = alloca [3 x ptr], align 8
// CHECK-NEXT:    [[DOTOFFLOAD_SIZES:%.*]] = alloca [3 x i64], align 8
// CHECK-NEXT:    [[KERNEL_ARGS:%.*]] = alloca [[STRUCT___TGT_KERNEL_ARGUMENTS:%.*]], align 8
// CHECK-NEXT:    [[N_CASTED3:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[DOTOFFLOAD_BASEPTRS8:%.*]] = alloca [3 x ptr], align 8
// CHECK-NEXT:    [[DOTOFFLOAD_PTRS9:%.*]] = alloca [3 x ptr], align 8
// CHECK-NEXT:    [[DOTOFFLOAD_MAPPERS10:%.*]] = alloca [3 x ptr], align 8
// CHECK-NEXT:    [[DOTOFFLOAD_SIZES11:%.*]] = alloca [3 x i64], align 8
// CHECK-NEXT:    [[TMP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_12:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[KERNEL_ARGS14:%.*]] = alloca [[STRUCT___TGT_KERNEL_ARGUMENTS]], align 8
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store ptr [[B]], ptr [[B_ADDR]], align 8
// CHECK-NEXT:    store i32 [[N]], ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[NUM_ITERS]], ptr [[NUM_ITERS_ADDR]], align 4
// CHECK-NEXT:    store i32 0, ptr [[I]], align 4
// CHECK-NEXT:    br label [[FOR_COND:%.*]]
// CHECK:       for.cond:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[NUM_ITERS_ADDR]], align 4
// CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP0]], [[TMP1]]
// CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
// CHECK:       for.body:
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP2]], ptr [[N_CASTED]], align 4
// CHECK-NEXT:    [[TMP3:%.*]] = load i64, ptr [[N_CASTED]], align 8
// CHECK-NEXT:    [[TMP4:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP5:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP6:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP7:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, ptr [[TMP7]], i64 0
// CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[TMP8]] to i64
// CHECK-NEXT:    [[TMP9:%.*]] = mul nuw i64 [[CONV]], 4
// CHECK-NEXT:    [[TMP10:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP11:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, ptr [[TMP11]], i64 0
// CHECK-NEXT:    [[TMP12:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    [[CONV2:%.*]] = sext i32 [[TMP12]] to i64
// CHECK-NEXT:    [[TMP13:%.*]] = mul nuw i64 [[CONV2]], 4
// CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[DOTOFFLOAD_SIZES]], ptr align 8 @.offload_sizes, i64 24, i1 false)
// CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 0
// CHECK-NEXT:    store i64 [[TMP3]], ptr [[TMP14]], align 8
// CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 0
// CHECK-NEXT:    store i64 [[TMP3]], ptr [[TMP15]], align 8
// CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_MAPPERS]], i64 0, i64 0
// CHECK-NEXT:    store ptr null, ptr [[TMP16]], align 8
// CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 1
// CHECK-NEXT:    store ptr [[TMP6]], ptr [[TMP17]], align 8
// CHECK-NEXT:    [[TMP18:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 1
// CHECK-NEXT:    store ptr [[ARRAYIDX]], ptr [[TMP18]], align 8
// CHECK-NEXT:    [[TMP19:%.*]] = getelementptr inbounds [3 x i64], ptr [[DOTOFFLOAD_SIZES]], i32 0, i32 1
// CHECK-NEXT:    store i64 [[TMP9]], ptr [[TMP19]], align 8
// CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_MAPPERS]], i64 0, i64 1
// CHECK-NEXT:    store ptr null, ptr [[TMP20]], align 8
// CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 2
// CHECK-NEXT:    store ptr [[TMP10]], ptr [[TMP21]], align 8
// CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 2
// CHECK-NEXT:    store ptr [[ARRAYIDX1]], ptr [[TMP22]], align 8
// CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds [3 x i64], ptr [[DOTOFFLOAD_SIZES]], i32 0, i32 2
// CHECK-NEXT:    store i64 [[TMP13]], ptr [[TMP23]], align 8
// CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_MAPPERS]], i64 0, i64 2
// CHECK-NEXT:    store ptr null, ptr [[TMP24]], align 8
// CHECK-NEXT:    [[TMP25:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 0
// CHECK-NEXT:    [[TMP26:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 0
// CHECK-NEXT:    [[TMP27:%.*]] = getelementptr inbounds [3 x i64], ptr [[DOTOFFLOAD_SIZES]], i32 0, i32 0
// CHECK-NEXT:    [[TMP28:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 0
// CHECK-NEXT:    store i32 2, ptr [[TMP28]], align 4
// CHECK-NEXT:    [[TMP29:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 1
// CHECK-NEXT:    store i32 3, ptr [[TMP29]], align 4
// CHECK-NEXT:    [[TMP30:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 2
// CHECK-NEXT:    store ptr [[TMP25]], ptr [[TMP30]], align 8
// CHECK-NEXT:    [[TMP31:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 3
// CHECK-NEXT:    store ptr [[TMP26]], ptr [[TMP31]], align 8
// CHECK-NEXT:    [[TMP32:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 4
// CHECK-NEXT:    store ptr [[TMP27]], ptr [[TMP32]], align 8
// CHECK-NEXT:    [[TMP33:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 5
// CHECK-NEXT:    store ptr @.offload_maptypes, ptr [[TMP33]], align 8
// CHECK-NEXT:    [[TMP34:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 6
// CHECK-NEXT:    store ptr null, ptr [[TMP34]], align 8
// CHECK-NEXT:    [[TMP35:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 7
// CHECK-NEXT:    store ptr null, ptr [[TMP35]], align 8
// CHECK-NEXT:    [[TMP36:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 8
// CHECK-NEXT:    store i64 0, ptr [[TMP36]], align 8
// CHECK-NEXT:    [[TMP37:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 9
// CHECK-NEXT:    store i64 0, ptr [[TMP37]], align 8
// CHECK-NEXT:    [[TMP38:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 10
// CHECK-NEXT:    store [3 x i32] [i32 1, i32 0, i32 0], ptr [[TMP38]], align 4
// CHECK-NEXT:    [[TMP39:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 11
// CHECK-NEXT:    store [3 x i32] zeroinitializer, ptr [[TMP39]], align 4
// CHECK-NEXT:    [[TMP40:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 12
// CHECK-NEXT:    store i32 0, ptr [[TMP40]], align 4
// CHECK-NEXT:    [[TMP41:%.*]] = call i32 @__tgt_target_kernel(ptr @[[GLOB2:[0-9]+]], i64 -1, i32 1, i32 0, ptr @.{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l9.region_id, ptr [[KERNEL_ARGS]])
// CHECK-NEXT:    [[TMP42:%.*]] = icmp ne i32 [[TMP41]], 0
// CHECK-NEXT:    br i1 [[TMP42]], label [[OMP_OFFLOAD_FAILED:%.*]], label [[OMP_OFFLOAD_CONT:%.*]]
// CHECK:       omp_offload.failed:
// CHECK-NEXT:    call void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l9(i64 [[TMP3]], ptr [[TMP4]], ptr [[TMP5]]) #[[ATTR2:[0-9]+]]
// CHECK-NEXT:    br label [[OMP_OFFLOAD_CONT]]
// CHECK:       omp_offload.cont:
// CHECK-NEXT:    [[TMP43:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP43]], ptr [[N_CASTED3]], align 4
// CHECK-NEXT:    [[TMP44:%.*]] = load i64, ptr [[N_CASTED3]], align 8
// CHECK-NEXT:    [[TMP45:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP46:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP47:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP48:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i32, ptr [[TMP48]], i64 0
// CHECK-NEXT:    [[TMP49:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    [[CONV5:%.*]] = sext i32 [[TMP49]] to i64
// CHECK-NEXT:    [[TMP50:%.*]] = mul nuw i64 [[CONV5]], 4
// CHECK-NEXT:    [[TMP51:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP52:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[TMP52]], i64 0
// CHECK-NEXT:    [[TMP53:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    [[CONV7:%.*]] = sext i32 [[TMP53]] to i64
// CHECK-NEXT:    [[TMP54:%.*]] = mul nuw i64 [[CONV7]], 4
// CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[DOTOFFLOAD_SIZES11]], ptr align 8 @.offload_sizes.1, i64 24, i1 false)
// CHECK-NEXT:    [[TMP55:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS8]], i32 0, i32 0
// CHECK-NEXT:    store i64 [[TMP44]], ptr [[TMP55]], align 8
// CHECK-NEXT:    [[TMP56:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS9]], i32 0, i32 0
// CHECK-NEXT:    store i64 [[TMP44]], ptr [[TMP56]], align 8
// CHECK-NEXT:    [[TMP57:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_MAPPERS10]], i64 0, i64 0
// CHECK-NEXT:    store ptr null, ptr [[TMP57]], align 8
// CHECK-NEXT:    [[TMP58:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS8]], i32 0, i32 1
// CHECK-NEXT:    store ptr [[TMP47]], ptr [[TMP58]], align 8
// CHECK-NEXT:    [[TMP59:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS9]], i32 0, i32 1
// CHECK-NEXT:    store ptr [[ARRAYIDX4]], ptr [[TMP59]], align 8
// CHECK-NEXT:    [[TMP60:%.*]] = getelementptr inbounds [3 x i64], ptr [[DOTOFFLOAD_SIZES11]], i32 0, i32 1
// CHECK-NEXT:    store i64 [[TMP50]], ptr [[TMP60]], align 8
// CHECK-NEXT:    [[TMP61:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_MAPPERS10]], i64 0, i64 1
// CHECK-NEXT:    store ptr null, ptr [[TMP61]], align 8
// CHECK-NEXT:    [[TMP62:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS8]], i32 0, i32 2
// CHECK-NEXT:    store ptr [[TMP51]], ptr [[TMP62]], align 8
// CHECK-NEXT:    [[TMP63:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS9]], i32 0, i32 2
// CHECK-NEXT:    store ptr [[ARRAYIDX6]], ptr [[TMP63]], align 8
// CHECK-NEXT:    [[TMP64:%.*]] = getelementptr inbounds [3 x i64], ptr [[DOTOFFLOAD_SIZES11]], i32 0, i32 2
// CHECK-NEXT:    store i64 [[TMP54]], ptr [[TMP64]], align 8
// CHECK-NEXT:    [[TMP65:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_MAPPERS10]], i64 0, i64 2
// CHECK-NEXT:    store ptr null, ptr [[TMP65]], align 8
// CHECK-NEXT:    [[TMP66:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_BASEPTRS8]], i32 0, i32 0
// CHECK-NEXT:    [[TMP67:%.*]] = getelementptr inbounds [3 x ptr], ptr [[DOTOFFLOAD_PTRS9]], i32 0, i32 0
// CHECK-NEXT:    [[TMP68:%.*]] = getelementptr inbounds [3 x i64], ptr [[DOTOFFLOAD_SIZES11]], i32 0, i32 0
// CHECK-NEXT:    [[TMP69:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP69]], ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[TMP70:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[TMP70]], -2
// CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[SUB]], 3
// CHECK-NEXT:    [[SUB13:%.*]] = sub i32 [[DIV]], 1
// CHECK-NEXT:    store i32 [[SUB13]], ptr [[DOTCAPTURE_EXPR_12]], align 4
// CHECK-NEXT:    [[TMP71:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_12]], align 4
// CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP71]], 1
// CHECK-NEXT:    [[TMP72:%.*]] = zext i32 [[ADD]] to i64
// CHECK-NEXT:    [[TMP73:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 0
// CHECK-NEXT:    store i32 2, ptr [[TMP73]], align 4
// CHECK-NEXT:    [[TMP74:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 1
// CHECK-NEXT:    store i32 3, ptr [[TMP74]], align 4
// CHECK-NEXT:    [[TMP75:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 2
// CHECK-NEXT:    store ptr [[TMP66]], ptr [[TMP75]], align 8
// CHECK-NEXT:    [[TMP76:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 3
// CHECK-NEXT:    store ptr [[TMP67]], ptr [[TMP76]], align 8
// CHECK-NEXT:    [[TMP77:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 4
// CHECK-NEXT:    store ptr [[TMP68]], ptr [[TMP77]], align 8
// CHECK-NEXT:    [[TMP78:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 5
// CHECK-NEXT:    store ptr @.offload_maptypes.2, ptr [[TMP78]], align 8
// CHECK-NEXT:    [[TMP79:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 6
// CHECK-NEXT:    store ptr null, ptr [[TMP79]], align 8
// CHECK-NEXT:    [[TMP80:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 7
// CHECK-NEXT:    store ptr null, ptr [[TMP80]], align 8
// CHECK-NEXT:    [[TMP81:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 8
// CHECK-NEXT:    store i64 [[TMP72]], ptr [[TMP81]], align 8
// CHECK-NEXT:    [[TMP82:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 9
// CHECK-NEXT:    store i64 0, ptr [[TMP82]], align 8
// CHECK-NEXT:    [[TMP83:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 10
// CHECK-NEXT:    store [3 x i32] zeroinitializer, ptr [[TMP83]], align 4
// CHECK-NEXT:    [[TMP84:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 11
// CHECK-NEXT:    store [3 x i32] zeroinitializer, ptr [[TMP84]], align 4
// CHECK-NEXT:    [[TMP85:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS14]], i32 0, i32 12
// CHECK-NEXT:    store i32 0, ptr [[TMP85]], align 4
// CHECK-NEXT:    [[TMP86:%.*]] = call i32 @__tgt_target_kernel(ptr @[[GLOB2]], i64 -1, i32 0, i32 0, ptr @.{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l13.region_id, ptr [[KERNEL_ARGS14]])
// CHECK-NEXT:    [[TMP87:%.*]] = icmp ne i32 [[TMP86]], 0
// CHECK-NEXT:    br i1 [[TMP87]], label [[OMP_OFFLOAD_FAILED15:%.*]], label [[OMP_OFFLOAD_CONT16:%.*]]
// CHECK:       omp_offload.failed15:
// CHECK-NEXT:    call void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l13(i64 [[TMP44]], ptr [[TMP45]], ptr [[TMP46]]) #[[ATTR2]]
// CHECK-NEXT:    br label [[OMP_OFFLOAD_CONT16]]
// CHECK:       omp_offload.cont16:
// CHECK-NEXT:    br label [[FOR_INC:%.*]]
// CHECK:       for.inc:
// CHECK-NEXT:    [[TMP88:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP88]], 1
// CHECK-NEXT:    store i32 [[INC]], ptr [[I]], align 4
// CHECK-NEXT:    br label [[FOR_COND]], !llvm.loop [[LOOP5:![0-9]+]]
// CHECK:       for.end:
// CHECK-NEXT:    [[TMP89:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP90:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    [[SUB17:%.*]] = sub nsw i32 [[TMP90]], 1
// CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[SUB17]] to i64
// CHECK-NEXT:    [[ARRAYIDX18:%.*]] = getelementptr inbounds i32, ptr [[TMP89]], i64 [[IDXPROM]]
// CHECK-NEXT:    [[TMP91:%.*]] = load i32, ptr [[ARRAYIDX18]], align 4
// CHECK-NEXT:    ret i32 [[TMP91]]
//
//
// CHECK-LABEL: define internal void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l9
// CHECK-SAME: (i64 noundef [[N:%.*]], ptr noundef [[A:%.*]], ptr noundef [[B:%.*]]) #[[ATTR1:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[N_ADDR:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[N_CASTED:%.*]] = alloca i64, align 8
// CHECK-NEXT:    store i64 [[N]], ptr [[N_ADDR]], align 8
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store ptr [[B]], ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP0]], ptr [[N_CASTED]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr [[N_CASTED]], align 8
// CHECK-NEXT:    [[TMP2:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @[[GLOB2]], i32 3, ptr @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l9.omp_outlined, i64 [[TMP1]], ptr [[TMP2]], ptr [[TMP3]])
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define internal void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l9.omp_outlined
// CHECK-SAME: (ptr noalias noundef [[DOTGLOBAL_TID_:%.*]], ptr noalias noundef [[DOTBOUND_TID_:%.*]], i64 noundef [[N:%.*]], ptr noundef [[A:%.*]], ptr noundef [[B:%.*]]) #[[ATTR1]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[N_ADDR:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTOMP_IV:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[TMP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_1:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[J:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_LB:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_UB:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_STRIDE:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_IS_LAST:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[J3:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store ptr [[DOTGLOBAL_TID_]], ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    store ptr [[DOTBOUND_TID_]], ptr [[DOTBOUND_TID__ADDR]], align 8
// CHECK-NEXT:    store i64 [[N]], ptr [[N_ADDR]], align 8
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store ptr [[B]], ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP0]], ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 [[TMP1]], 0
// CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[SUB]], 1
// CHECK-NEXT:    [[SUB2:%.*]] = sub nsw i32 [[DIV]], 1
// CHECK-NEXT:    store i32 [[SUB2]], ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    store i32 0, ptr [[J]], align 4
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 0, [[TMP2]]
// CHECK-NEXT:    br i1 [[CMP]], label [[OMP_PRECOND_THEN:%.*]], label [[OMP_PRECOND_END:%.*]]
// CHECK:       omp.precond.then:
// CHECK-NEXT:    store i32 0, ptr [[DOTOMP_LB]], align 4
// CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    store i32 [[TMP3]], ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    store i32 1, ptr [[DOTOMP_STRIDE]], align 4
// CHECK-NEXT:    store i32 0, ptr [[DOTOMP_IS_LAST]], align 4
// CHECK-NEXT:    [[TMP4:%.*]] = load ptr, ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr [[TMP4]], align 4
// CHECK-NEXT:    call void @__kmpc_for_static_init_4(ptr @[[GLOB1:[0-9]+]], i32 [[TMP5]], i32 34, ptr [[DOTOMP_IS_LAST]], ptr [[DOTOMP_LB]], ptr [[DOTOMP_UB]], ptr [[DOTOMP_STRIDE]], i32 1, i32 1)
// CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    [[CMP4:%.*]] = icmp sgt i32 [[TMP6]], [[TMP7]]
// CHECK-NEXT:    br i1 [[CMP4]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
// CHECK:       cond.true:
// CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    br label [[COND_END:%.*]]
// CHECK:       cond.false:
// CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    br label [[COND_END]]
// CHECK:       cond.end:
// CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[TMP8]], [[COND_TRUE]] ], [ [[TMP9]], [[COND_FALSE]] ]
// CHECK-NEXT:    store i32 [[COND]], ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[DOTOMP_LB]], align 4
// CHECK-NEXT:    store i32 [[TMP10]], ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    br label [[OMP_INNER_FOR_COND:%.*]]
// CHECK:       omp.inner.for.cond:
// CHECK-NEXT:    [[TMP11:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[TMP12:%.*]] = load i32, ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    [[CMP5:%.*]] = icmp sle i32 [[TMP11]], [[TMP12]]
// CHECK-NEXT:    br i1 [[CMP5]], label [[OMP_INNER_FOR_BODY:%.*]], label [[OMP_INNER_FOR_END:%.*]]
// CHECK:       omp.inner.for.body:
// CHECK-NEXT:    [[TMP13:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[MUL:%.*]] = mul nsw i32 [[TMP13]], 1
// CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 0, [[MUL]]
// CHECK-NEXT:    store i32 [[ADD]], ptr [[J3]], align 4
// CHECK-NEXT:    [[TMP14:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP15:%.*]] = load i32, ptr [[J3]], align 4
// CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[TMP15]] to i64
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, ptr [[TMP14]], i64 [[IDXPROM]]
// CHECK-NEXT:    [[TMP16:%.*]] = load i32, ptr [[ARRAYIDX]], align 4
// CHECK-NEXT:    [[TMP17:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP18:%.*]] = load i32, ptr [[J3]], align 4
// CHECK-NEXT:    [[IDXPROM6:%.*]] = sext i32 [[TMP18]] to i64
// CHECK-NEXT:    [[ARRAYIDX7:%.*]] = getelementptr inbounds i32, ptr [[TMP17]], i64 [[IDXPROM6]]
// CHECK-NEXT:    store i32 [[TMP16]], ptr [[ARRAYIDX7]], align 4
// CHECK-NEXT:    br label [[OMP_BODY_CONTINUE:%.*]]
// CHECK:       omp.body.continue:
// CHECK-NEXT:    br label [[OMP_INNER_FOR_INC:%.*]]
// CHECK:       omp.inner.for.inc:
// CHECK-NEXT:    [[TMP19:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[ADD8:%.*]] = add nsw i32 [[TMP19]], 1
// CHECK-NEXT:    store i32 [[ADD8]], ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    br label [[OMP_INNER_FOR_COND]]
// CHECK:       omp.inner.for.end:
// CHECK-NEXT:    br label [[OMP_LOOP_EXIT:%.*]]
// CHECK:       omp.loop.exit:
// CHECK-NEXT:    [[TMP20:%.*]] = load ptr, ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    [[TMP21:%.*]] = load i32, ptr [[TMP20]], align 4
// CHECK-NEXT:    call void @__kmpc_for_static_fini(ptr @[[GLOB1]], i32 [[TMP21]])
// CHECK-NEXT:    br label [[OMP_PRECOND_END]]
// CHECK:       omp.precond.end:
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define internal void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l13
// CHECK-SAME: (i64 noundef [[N:%.*]], ptr noundef [[A:%.*]], ptr noundef [[B:%.*]]) #[[ATTR1]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[N_ADDR:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[N_CASTED:%.*]] = alloca i64, align 8
// CHECK-NEXT:    store i64 [[N]], ptr [[N_ADDR]], align 8
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store ptr [[B]], ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP0]], ptr [[N_CASTED]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr [[N_CASTED]], align 8
// CHECK-NEXT:    [[TMP2:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    call void (ptr, i32, ptr, ...) @__kmpc_fork_teams(ptr @[[GLOB2]], i32 3, ptr @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l13.omp_outlined, i64 [[TMP1]], ptr [[TMP2]], ptr [[TMP3]])
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define internal void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l13.omp_outlined
// CHECK-SAME: (ptr noalias noundef [[DOTGLOBAL_TID_:%.*]], ptr noalias noundef [[DOTBOUND_TID_:%.*]], i64 noundef [[N:%.*]], ptr noundef [[A:%.*]], ptr noundef [[B:%.*]]) #[[ATTR1]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[N_ADDR:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTOMP_IV:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[TMP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_1:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[J:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_COMB_LB:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_COMB_UB:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_STRIDE:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_IS_LAST:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[J3:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[N_CASTED:%.*]] = alloca i64, align 8
// CHECK-NEXT:    store ptr [[DOTGLOBAL_TID_]], ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    store ptr [[DOTBOUND_TID_]], ptr [[DOTBOUND_TID__ADDR]], align 8
// CHECK-NEXT:    store i64 [[N]], ptr [[N_ADDR]], align 8
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store ptr [[B]], ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP0]], ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[TMP1]], -2
// CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[SUB]], 3
// CHECK-NEXT:    [[SUB2:%.*]] = sub i32 [[DIV]], 1
// CHECK-NEXT:    store i32 [[SUB2]], ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    store i32 0, ptr [[J]], align 4
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 0, [[TMP2]]
// CHECK-NEXT:    br i1 [[CMP]], label [[OMP_PRECOND_THEN:%.*]], label [[OMP_PRECOND_END:%.*]]
// CHECK:       omp.precond.then:
// CHECK-NEXT:    store i32 0, ptr [[DOTOMP_COMB_LB]], align 4
// CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    store i32 [[TMP3]], ptr [[DOTOMP_COMB_UB]], align 4
// CHECK-NEXT:    store i32 1, ptr [[DOTOMP_STRIDE]], align 4
// CHECK-NEXT:    store i32 0, ptr [[DOTOMP_IS_LAST]], align 4
// CHECK-NEXT:    [[TMP4:%.*]] = load ptr, ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr [[TMP4]], align 4
// CHECK-NEXT:    call void @__kmpc_for_static_init_4u(ptr @[[GLOB3:[0-9]+]], i32 [[TMP5]], i32 92, ptr [[DOTOMP_IS_LAST]], ptr [[DOTOMP_COMB_LB]], ptr [[DOTOMP_COMB_UB]], ptr [[DOTOMP_STRIDE]], i32 1, i32 1)
// CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[DOTOMP_COMB_UB]], align 4
// CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    [[CMP4:%.*]] = icmp ugt i32 [[TMP6]], [[TMP7]]
// CHECK-NEXT:    br i1 [[CMP4]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
// CHECK:       cond.true:
// CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    br label [[COND_END:%.*]]
// CHECK:       cond.false:
// CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[DOTOMP_COMB_UB]], align 4
// CHECK-NEXT:    br label [[COND_END]]
// CHECK:       cond.end:
// CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[TMP8]], [[COND_TRUE]] ], [ [[TMP9]], [[COND_FALSE]] ]
// CHECK-NEXT:    store i32 [[COND]], ptr [[DOTOMP_COMB_UB]], align 4
// CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[DOTOMP_COMB_LB]], align 4
// CHECK-NEXT:    store i32 [[TMP10]], ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    br label [[OMP_INNER_FOR_COND:%.*]]
// CHECK:       omp.inner.for.cond:
// CHECK-NEXT:    [[TMP11:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[TMP12:%.*]] = load i32, ptr [[DOTOMP_COMB_UB]], align 4
// CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP12]], 1
// CHECK-NEXT:    [[CMP5:%.*]] = icmp ult i32 [[TMP11]], [[ADD]]
// CHECK-NEXT:    br i1 [[CMP5]], label [[OMP_INNER_FOR_BODY:%.*]], label [[OMP_INNER_FOR_END:%.*]]
// CHECK:       omp.inner.for.body:
// CHECK-NEXT:    [[TMP13:%.*]] = load i32, ptr [[DOTOMP_COMB_LB]], align 4
// CHECK-NEXT:    [[TMP14:%.*]] = zext i32 [[TMP13]] to i64
// CHECK-NEXT:    [[TMP15:%.*]] = load i32, ptr [[DOTOMP_COMB_UB]], align 4
// CHECK-NEXT:    [[TMP16:%.*]] = zext i32 [[TMP15]] to i64
// CHECK-NEXT:    [[TMP17:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP17]], ptr [[N_CASTED]], align 4
// CHECK-NEXT:    [[TMP18:%.*]] = load i64, ptr [[N_CASTED]], align 8
// CHECK-NEXT:    [[TMP19:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP20:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @[[GLOB2]], i32 5, ptr @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l13.omp_outlined.omp_outlined, i64 [[TMP14]], i64 [[TMP16]], i64 [[TMP18]], ptr [[TMP19]], ptr [[TMP20]])
// CHECK-NEXT:    br label [[OMP_INNER_FOR_INC:%.*]]
// CHECK:       omp.inner.for.inc:
// CHECK-NEXT:    [[TMP21:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[TMP22:%.*]] = load i32, ptr [[DOTOMP_STRIDE]], align 4
// CHECK-NEXT:    [[ADD6:%.*]] = add i32 [[TMP21]], [[TMP22]]
// CHECK-NEXT:    store i32 [[ADD6]], ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    br label [[OMP_INNER_FOR_COND]]
// CHECK:       omp.inner.for.end:
// CHECK-NEXT:    br label [[OMP_LOOP_EXIT:%.*]]
// CHECK:       omp.loop.exit:
// CHECK-NEXT:    [[TMP23:%.*]] = load ptr, ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    [[TMP24:%.*]] = load i32, ptr [[TMP23]], align 4
// CHECK-NEXT:    call void @__kmpc_for_static_fini(ptr @[[GLOB3]], i32 [[TMP24]])
// CHECK-NEXT:    br label [[OMP_PRECOND_END]]
// CHECK:       omp.precond.end:
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define internal void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z18kernel_within_loopPiS_ii_l13.omp_outlined.omp_outlined
// CHECK-SAME: (ptr noalias noundef [[DOTGLOBAL_TID_:%.*]], ptr noalias noundef [[DOTBOUND_TID_:%.*]], i64 noundef [[DOTPREVIOUS_LB_:%.*]], i64 noundef [[DOTPREVIOUS_UB_:%.*]], i64 noundef [[N:%.*]], ptr noundef [[A:%.*]], ptr noundef [[B:%.*]]) #[[ATTR1]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTPREVIOUS_LB__ADDR:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[DOTPREVIOUS_UB__ADDR:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[N_ADDR:%.*]] = alloca i64, align 8
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTOMP_IV:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[TMP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTCAPTURE_EXPR_1:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[J:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_LB:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_UB:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_STRIDE:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTOMP_IS_LAST:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[J4:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store ptr [[DOTGLOBAL_TID_]], ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    store ptr [[DOTBOUND_TID_]], ptr [[DOTBOUND_TID__ADDR]], align 8
// CHECK-NEXT:    store i64 [[DOTPREVIOUS_LB_]], ptr [[DOTPREVIOUS_LB__ADDR]], align 8
// CHECK-NEXT:    store i64 [[DOTPREVIOUS_UB_]], ptr [[DOTPREVIOUS_UB__ADDR]], align 8
// CHECK-NEXT:    store i64 [[N]], ptr [[N_ADDR]], align 8
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store ptr [[B]], ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[N_ADDR]], align 4
// CHECK-NEXT:    store i32 [[TMP0]], ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[TMP1]], -2
// CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[SUB]], 3
// CHECK-NEXT:    [[SUB2:%.*]] = sub i32 [[DIV]], 1
// CHECK-NEXT:    store i32 [[SUB2]], ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    store i32 0, ptr [[J]], align 4
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_]], align 4
// CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 0, [[TMP2]]
// CHECK-NEXT:    br i1 [[CMP]], label [[OMP_PRECOND_THEN:%.*]], label [[OMP_PRECOND_END:%.*]]
// CHECK:       omp.precond.then:
// CHECK-NEXT:    store i32 0, ptr [[DOTOMP_LB]], align 4
// CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    store i32 [[TMP3]], ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    [[TMP4:%.*]] = load i64, ptr [[DOTPREVIOUS_LB__ADDR]], align 8
// CHECK-NEXT:    [[CONV:%.*]] = trunc i64 [[TMP4]] to i32
// CHECK-NEXT:    [[TMP5:%.*]] = load i64, ptr [[DOTPREVIOUS_UB__ADDR]], align 8
// CHECK-NEXT:    [[CONV3:%.*]] = trunc i64 [[TMP5]] to i32
// CHECK-NEXT:    store i32 [[CONV]], ptr [[DOTOMP_LB]], align 4
// CHECK-NEXT:    store i32 [[CONV3]], ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    store i32 1, ptr [[DOTOMP_STRIDE]], align 4
// CHECK-NEXT:    store i32 0, ptr [[DOTOMP_IS_LAST]], align 4
// CHECK-NEXT:    [[TMP6:%.*]] = load ptr, ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[TMP6]], align 4
// CHECK-NEXT:    call void @__kmpc_for_static_init_4u(ptr @[[GLOB1]], i32 [[TMP7]], i32 34, ptr [[DOTOMP_IS_LAST]], ptr [[DOTOMP_LB]], ptr [[DOTOMP_UB]], ptr [[DOTOMP_STRIDE]], i32 1, i32 1)
// CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    [[CMP5:%.*]] = icmp ugt i32 [[TMP8]], [[TMP9]]
// CHECK-NEXT:    br i1 [[CMP5]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
// CHECK:       cond.true:
// CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[DOTCAPTURE_EXPR_1]], align 4
// CHECK-NEXT:    br label [[COND_END:%.*]]
// CHECK:       cond.false:
// CHECK-NEXT:    [[TMP11:%.*]] = load i32, ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    br label [[COND_END]]
// CHECK:       cond.end:
// CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[TMP10]], [[COND_TRUE]] ], [ [[TMP11]], [[COND_FALSE]] ]
// CHECK-NEXT:    store i32 [[COND]], ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    [[TMP12:%.*]] = load i32, ptr [[DOTOMP_LB]], align 4
// CHECK-NEXT:    store i32 [[TMP12]], ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    br label [[OMP_INNER_FOR_COND:%.*]]
// CHECK:       omp.inner.for.cond:
// CHECK-NEXT:    [[TMP13:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[TMP14:%.*]] = load i32, ptr [[DOTOMP_UB]], align 4
// CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP14]], 1
// CHECK-NEXT:    [[CMP6:%.*]] = icmp ult i32 [[TMP13]], [[ADD]]
// CHECK-NEXT:    br i1 [[CMP6]], label [[OMP_INNER_FOR_BODY:%.*]], label [[OMP_INNER_FOR_END:%.*]]
// CHECK:       omp.inner.for.body:
// CHECK-NEXT:    [[TMP15:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[TMP15]], 3
// CHECK-NEXT:    [[ADD7:%.*]] = add i32 0, [[MUL]]
// CHECK-NEXT:    store i32 [[ADD7]], ptr [[J4]], align 4
// CHECK-NEXT:    [[TMP16:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP17:%.*]] = load i32, ptr [[J4]], align 4
// CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[TMP17]] to i64
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, ptr [[TMP16]], i64 [[IDXPROM]]
// CHECK-NEXT:    [[TMP18:%.*]] = load i32, ptr [[ARRAYIDX]], align 4
// CHECK-NEXT:    [[MUL8:%.*]] = mul nsw i32 [[TMP18]], 2
// CHECK-NEXT:    [[TMP19:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP20:%.*]] = load i32, ptr [[J4]], align 4
// CHECK-NEXT:    [[IDXPROM9:%.*]] = sext i32 [[TMP20]] to i64
// CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, ptr [[TMP19]], i64 [[IDXPROM9]]
// CHECK-NEXT:    store i32 [[MUL8]], ptr [[ARRAYIDX10]], align 4
// CHECK-NEXT:    br label [[OMP_BODY_CONTINUE:%.*]]
// CHECK:       omp.body.continue:
// CHECK-NEXT:    br label [[OMP_INNER_FOR_INC:%.*]]
// CHECK:       omp.inner.for.inc:
// CHECK-NEXT:    [[TMP21:%.*]] = load i32, ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    [[ADD11:%.*]] = add i32 [[TMP21]], 1
// CHECK-NEXT:    store i32 [[ADD11]], ptr [[DOTOMP_IV]], align 4
// CHECK-NEXT:    br label [[OMP_INNER_FOR_COND]]
// CHECK:       omp.inner.for.end:
// CHECK-NEXT:    br label [[OMP_LOOP_EXIT:%.*]]
// CHECK:       omp.loop.exit:
// CHECK-NEXT:    [[TMP22:%.*]] = load ptr, ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK-NEXT:    [[TMP23:%.*]] = load i32, ptr [[TMP22]], align 4
// CHECK-NEXT:    call void @__kmpc_for_static_fini(ptr @[[GLOB1]], i32 [[TMP23]])
// CHECK-NEXT:    br label [[OMP_PRECOND_END]]
// CHECK:       omp.precond.end:
// CHECK-NEXT:    ret void
//