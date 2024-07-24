//===- IntrinsicsISOLDE.td - Defines ISOLDE intrinsics -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the ISOLDE-specific intrinsics.
// how to build
// 1.  cd build
// 2.  make intrinsics_gen -j6
// 3.  make llc -j30
//===----------------------------------------------------------------------===//

class ISOLDEVIntrinsic {
  // These intrinsics may accept illegal integer values in their llvm_any_ty
  // operand, so they have to be extended. If set to zero then the intrinsic
  // does not have any operand that must be extended.
  Intrinsic IntrinsicID = !cast<Intrinsic>(NAME);
  bits<4> ExtendOperand = 0;
}

let TargetPrefix = "ISOLDE" in {
  // We use anyint here but we only support XLen.
  def int_ISOLDE_vsetvli   : Intrinsic<[],[
                           /* rd */  LLVMType<i8>,
                           /* rs */  LLVMType<i8>,
                           /* vtypei */ LLVMType<i8>],
                                      [IntrNoMem, IntrHasSideEffects,
                                       ImmArg<ArgIndex<0>>,
                                       ImmArg<ArgIndex<1>>,
                                       ImmArg<ArgIndex<2>>]>;
// 
  class ISOLDETypeR <ValueType type>  : Intrinsic<[],[
                           /* rd */  LLVMPointerType< LLVMType<type> >,
                           /* rs */  LLVMPointerType< LLVMType<type> >],
                                      [IntrNoMem, IntrHasSideEffects]>;
  // For unit stride load
  // Input: (passthru, pointer, vl)
  class ISOLDERISCVUSLoad
        : DefaultAttrsIntrinsic<[llvm_v4i32_ty],
                    [LLVMPointerType<LLVMMatchType<0>>,
                     llvm_anyint_ty],
                    [ IntrReadMem]>{
    
  }
  
  // For unit stride load with mask
  // Input: (maskedoff, pointer, mask, vl)
  class ISOLDEUSLoadMask
        : Intrinsic<[llvm_v4i32_ty ],
                    [LLVMMatchType<0>,
                     LLVMPointerType<LLVMMatchType<0>>,
                     LLVMScalarOrSameVectorWidth<0, llvm_i1_ty>,
                     llvm_anyint_ty],
                    [NoCapture<ArgIndex<1>>, IntrReadMem]>, ISOLDEVIntrinsic;

  // For unit stride store
  // Input: (vector_in, pointer, vl)
    class ISOLDEUSStore
        : DefaultAttrsIntrinsic<[],
                    [llvm_v4i32_ty,
                     LLVMPointerType<LLVMMatchType<0>>,
                     llvm_anyint_ty],
                    [NoCapture<ArgIndex<1>>, IntrWriteMem]> {
    
  }

  // For unit stride store with mask
  // Input: (vector_in, pointer, mask, vl)
  class ISOLDEUSStoreMask
        : Intrinsic<[],
                    [llvm_anyvector_ty,
                     LLVMPointerType<LLVMMatchType<0>>,
                     LLVMScalarOrSameVectorWidth<0, llvm_i1_ty>,
                     llvm_anyint_ty],
                    [NoCapture<ArgIndex<1>>, IntrWriteMem]>, ISOLDEVIntrinsic;



class ONNXConv2D <ValueType i_type, ValueType w_type, ValueType o_type>  : Intrinsic<
/*** return types*/                [
/* <4 x i32> %output_shape */            llvm_v4i32_ty
/*** param types*/                 ],[ 
/* <vscale x 1 x o_type>* %output  */    LLVMPointerType< LLVMType<o_type> >

/* <vscale x 1 x i_type>* %input   */  , LLVMPointerType< LLVMType<i_type> >
/* <4 x i32>          %input_shape */  , llvm_v4i32_ty
/* <vscale x 1 x w_type>* %weight  */  , LLVMPointerType< LLVMType<w_type> >
/* <4 x i32> %weight_shape         */  , llvm_v4i32_ty
/** conv2d  attributes            **/
/* <4 x i32> %pad                  */  , llvm_v4i32_ty
/* <4 x i32> %stride_dilation      */  , llvm_v4i32_ty
                                   ],
                                      [IntrNoMem, IntrHasSideEffects]>;


class ONNXConv2DEx <ValueType i_type, ValueType w_type, ValueType o_type>  : Intrinsic<
/*** return types*/                [
/* <4 x i32> %output_shape */            llvm_v4i32_ty
/*** param types*/                 ],[ 
/* <vscale x 1 x o_type>* %output  */    LLVMPointerType< LLVMType<o_type> >

/* <vscale x 1 x i_type>* %input   */  , LLVMPointerType< LLVMType<i_type> >
/* <4 x i32>          %input_shape */  , llvm_v4i32_ty
/* <vscale x 1 x w_type>* %weight  */  , LLVMPointerType< LLVMType<w_type> >
/* <4 x i32> %weight_shape         */  , llvm_v4i32_ty
/** conv2d  attributes            **/
/* <4 x i32> %pad                  */  , llvm_v4i32_ty
/* <4 x i32> %stride_dilation      */  , llvm_v4i32_ty
/* %bias  */                           , LLVMPointerType< LLVMType<o_type> >
                                   ],
                                      [IntrNoMem, IntrHasSideEffects]>;
/**
* FFT
**/

class DSPFFT<ValueType op_type> : Intrinsic<
/*** return types*/                [    
//                                    llvm_v4i32_ty  
                                   ],
/*** param types*/                 [ 
/*  %output_real  */        LLVMPointerType< LLVMType< op_type > >
/*  %output_img   */      , LLVMPointerType< LLVMType< op_type > >
/*  %input_real  */       , LLVMPointerType< LLVMType< op_type > >
/*  %input_img   */       , LLVMPointerType< LLVMType< op_type > > 
/*  %trigo_lut   */       , LLVMPointerType< LLVMType< op_type > > 
/* <4 x i32> %shape  */   , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

/**
* MATMUL
**/

class ONNXMatMul<ValueType op_type> : Intrinsic<
/*** return types*/                [    
/* output shape */                  llvm_v4i32_ty  
                                   ],
/*** param types*/                 [ 
/*  ptr %output         */         LLVMPointerType< LLVMType< op_type > >
/*  ptr %input_A        */       , LLVMPointerType< LLVMType< op_type > >
/*  <4 x i32> %shape_A  */       , llvm_v4i32_ty
/*  ptr %input_B        */       , LLVMPointerType< LLVMType< op_type > > 
/*  <4 x i32> %shape_B  */       , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

/**
* GEMM
**/

class ONNXGEMM<ValueType op_type> : Intrinsic<
/*** return types*/                [    
/* output shape */                  llvm_v4i32_ty  
                                   ],
/*** param types*/                 [ 
/*  ptr %output         */         LLVMPointerType< LLVMType< op_type > >
/*  ptr %input_A        */       , LLVMPointerType< LLVMType< op_type > >
/*  <4 x i32> %shape_A  */       , llvm_v4i32_ty
/*  ptr %input_B        */       , LLVMPointerType< LLVMType< op_type > > 
/*  <4 x i32> %shape_B  */       , llvm_v4i32_ty
///*  <4 x f32> %alpha_beta  */    , llvm_v4f32_ty
/*  ptr %input_C        */       , LLVMPointerType< LLVMType< op_type > > 
/* transA               */       ,llvm_i32_ty
/* transB               */       ,llvm_i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

/**
* ADD
**/

class ONNXAdd<ValueType op_type> : Intrinsic<
/*** return types*/                [    
/* output shape */                  llvm_v4i32_ty  
                                   ],
/*** param types*/                 [ 
/*  ptr %output         */         LLVMPointerType< LLVMType< op_type > >
/*  ptr %input_A        */       , LLVMPointerType< LLVMType< op_type > >
/*  <4 x i32> %shape_A  */       , llvm_v4i32_ty
/*  ptr %input_B        */       , LLVMPointerType< LLVMType< op_type > > 
/*  <4 x i32> %shape_B  */       , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

/**
* RELU
**/

class ONNXRelu<ValueType op_type> : Intrinsic<
/*** return types*/                [   
                                   ],
/*** param types*/                 [ 
/*  %output  */        LLVMPointerType< LLVMType< op_type > >
/*  %input   */       , LLVMPointerType< LLVMType< op_type > >
/* i32 %shape */      , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

/**
* SOFTMAX
**/

class ONNXSoftmax<ValueType op_type> : Intrinsic<
/*** return types*/                [   
                                   ],
/*** param types*/                 [ 
/*  %output  */        LLVMPointerType< LLVMType< op_type > >
/*  %input   */       , LLVMPointerType< LLVMType< op_type > >
/* i32 %shape */      , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;
/**
* MaxPool
**/

class ONNXMaxPool <ValueType io_type>  : Intrinsic<
/*** return types*/                [
/* <4 x i32> %output_shape */            llvm_v4i32_ty
/*** param types*/                 ],[ 
/* <vscale x 1 x o_type>* %output  */    LLVMPointerType< LLVMType<io_type> >

/* <vscale x 1 x i_type>* %input   */  , LLVMPointerType< LLVMType<io_type> >
/* <4 x i32>          %input_shape */  , llvm_v4i32_ty
/* <4 x i32> %kernel_strides         */  , llvm_v4i32_ty
/** maxpool2d  attributes            **/
/* <4 x i32> %pad                  */  , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

/**
* Transpose
**/

class ONNXTranspose<ValueType op_type> : Intrinsic<
/*** return types*/                [   
                                   ],
/*** param types */                 [ 
/*  %output      */         LLVMPointerType< LLVMType< op_type > >
/*  %input       */       , LLVMPointerType< LLVMType< op_type > >
/*  %input_shape */       , llvm_v4i32_ty
/*  %perm        */       , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;
/**
* Reshape
**/

class ONNXReshape<ValueType op_type> : Intrinsic<
/*** return types*/                [   
                                   ],
/*** param types  */                 [ 
/*  %output       */         LLVMPointerType< LLVMType< op_type > >
/*  %input        */       , LLVMPointerType< LLVMType< op_type > >
/*  %input_shape  */       , llvm_v4i32_ty
/*  %axis        */       , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

/**
* ReduceMean
**/

class ONNXReduceMean<ValueType op_type> : Intrinsic<
/*** return types*/                [   
                                   ],
/*** param types  */                 [ 
/*  %output       */         LLVMPointerType< LLVMType< op_type > >
/*  %input        */       , LLVMPointerType< LLVMType< op_type > >
/*  %input_shape  */       , llvm_v4i32_ty
/*  %output_shape */       , llvm_v4i32_ty
                                   ],
                                      [ IntrHasSideEffects]>;

  class ISOLDETypeR2 <ValueType o_type,ValueType i_type,ValueType w_type>  : Intrinsic<[],[
                           /* output */  LLVMPointerType< LLVMType<o_type> >,
                           /* input  */  LLVMPointerType< LLVMType<i_type> >,
                           /* weight */  LLVMPointerType< LLVMType<w_type> >,
                           /* bias   */  LLVMPointerType< LLVMType<o_type> >
                           ],
                                      [IntrNoMem, IntrHasSideEffects]>;

//class SHA_3Arg_i32_Intrinsic : Intrinsic<[llvm_v4i32_ty],
//                                   [llvm_v4i32_ty, llvm_i32_ty, llvm_v4i32_ty],
//                                   [IntrNoMem]>;
class ISOLDE_3Arg_v4i32_Intrinsic : Intrinsic<[llvm_v4i32_ty],
                                   [llvm_v4i32_ty, llvm_v4i32_ty,llvm_v4i32_ty],
                                   [IntrNoMem]>;
}

multiclass  Codec{
    def "int_ISOLDE_" # NAME # "_encode" : ISOLDETypeR<nxv1i8>;
    def "int_ISOLDE_" # NAME # "_decode" : ISOLDETypeR<nxv1i8>;
  }

defm rs  : Codec; 


//                                        | i_type | w_type | o_type |
  def int_ISOLDE_onnx_conv2di32 : ONNXConv2D<nxv1i32, nxv1i32, nxv1i32 >;
  def int_ISOLDE_onnx_conv2di16 : ONNXConv2D<nxv1i16, nxv1i16, nxv1i32 >;
  def int_ISOLDE_onnx_conv2di8  : ONNXConv2D<nxv1i8,  nxv1i8,  nxv1i16 >;
  def int_ISOLDE_onnx_conv2df32 : ONNXConv2D<f32,      f32,     f32 >;
  //
  def int_ISOLDE_onnx_conv2dexf32 : ONNXConv2DEx<f32,      f32,     f32 >;
//
//RELU
//                                  
 def int_ISOLDE_onnx_reluf32 : ONNXRelu<f32>;
 def int_ISOLDE_onnx_relui32 : ONNXRelu<i32>;
 def int_ISOLDE_onnx_relui16 : ONNXRelu<i16>;
 def int_ISOLDE_onnx_relui8  : ONNXRelu<i8>;
 //
//Softmax
//                                  
 def int_ISOLDE_onnx_softmaxf32 : ONNXSoftmax<f32>;
 def int_ISOLDE_onnx_softmaxi32 : ONNXSoftmax<i32>;
 def int_ISOLDE_onnx_softmaxi16 : ONNXSoftmax<i16>;
 def int_ISOLDE_onnx_softmaxi8  : ONNXSoftmax<i8>;
//
//MaxPool
//                                  
 def int_ISOLDE_onnx_maxpoolf32 : ONNXMaxPool<f32>;
 def int_ISOLDE_onnx_maxpooli32 : ONNXMaxPool<i32>;
 def int_ISOLDE_onnx_maxpooli16 : ONNXMaxPool<i16>;
 def int_ISOLDE_onnx_maxpooli8  : ONNXMaxPool<i8>;
//
//Transpose
//                                  
 def int_ISOLDE_onnx_transposef32 : ONNXTranspose<f32>;
 def int_ISOLDE_onnx_transposei32 : ONNXTranspose<i32>;
 def int_ISOLDE_onnx_transposei16 : ONNXTranspose<i16>;
 def int_ISOLDE_onnx_transposei8  : ONNXTranspose<i8>;
 //
//Reshape
//                                  
 def int_ISOLDE_onnx_reshapef32 : ONNXReshape<f32>;
 def int_ISOLDE_onnx_reshapei32 : ONNXReshape<i32>;
 def int_ISOLDE_onnx_reshapei16 : ONNXReshape<i16>;
 def int_ISOLDE_onnx_reshapei8  : ONNXReshape<i8>;
//
//ReduceMean
//                                  
 def int_ISOLDE_onnx_reducemeanf32 : ONNXReduceMean<f32>;
 def int_ISOLDE_onnx_reducemeani32 : ONNXReduceMean<i32>;
 def int_ISOLDE_onnx_reducemeani16 : ONNXReduceMean<i16>;
 def int_ISOLDE_onnx_reducemeani8  : ONNXReduceMean<i8>;
//
//GEMM
//                                  
 def int_ISOLDE_onnx_gemmf32 : ONNXGEMM<f32>;
 def int_ISOLDE_onnx_gemmi32 : ONNXGEMM<i32>;
 def int_ISOLDE_onnx_gemmi16 : ONNXGEMM<i16>;
 def int_ISOLDE_onnx_gemmi8  : ONNXGEMM<i8>;
//
//MatMul
//                                  
 def int_ISOLDE_onnx_matmulf32 : ONNXMatMul<f32>;
 def int_ISOLDE_onnx_matmuli32 : ONNXMatMul<i32>;
 def int_ISOLDE_onnx_matmuli16 : ONNXMatMul<i16>;
 def int_ISOLDE_onnx_matmuli8  : ONNXMatMul<i8>;
//
//Add
//                                  
 def int_ISOLDE_onnx_addf32 : ONNXAdd<f32>;
 def int_ISOLDE_onnx_addi32 : ONNXAdd<i32>;
 def int_ISOLDE_onnx_addi16 : ONNXAdd<i16>;
 def int_ISOLDE_onnx_addi8  : ONNXAdd<i8>;

/**
***  DSP
**/
//                               
 def int_ISOLDE_dsp_fft1df32 : DSPFFT<f32>;
 def int_ISOLDE_dsp_fft1di32 : DSPFFT<i32>;
 def int_ISOLDE_dsp_fft1di16 : DSPFFT<i16>;
 def int_ISOLDE_dsp_fft1di8  : DSPFFT<i8>;
//                                  
 def int_ISOLDE_dsp_fft2df32 : DSPFFT<f32>;
 def int_ISOLDE_dsp_fft2di32 : DSPFFT<i32>;
 def int_ISOLDE_dsp_fft2di16 : DSPFFT<i16>;
 def int_ISOLDE_dsp_fft2di8  : DSPFFT<i8>;
//QWORD
def int_ISOLDE_vse : ISOLDEUSStore;
def int_ISOLDE_vle : ISOLDERISCVUSLoad;
//experiments
def int_ISOLDE_neon_sha1su0: ISOLDE_3Arg_v4i32_Intrinsic;  