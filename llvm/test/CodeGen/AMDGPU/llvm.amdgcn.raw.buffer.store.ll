; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s -mtriple=amdgcn -mcpu=verde -verify-machineinstrs | FileCheck -check-prefixes=GFX68,VERDE %s
; RUN: llc < %s -mtriple=amdgcn -mcpu=tonga -verify-machineinstrs | FileCheck -check-prefixes=GFX68,GFX8 %s
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx1100 -verify-machineinstrs | FileCheck -check-prefixes=GFX11 %s

define amdgpu_ps void @buffer_store(<4 x i32> inreg, <4 x float>, <4 x float>, <4 x float>) {
; GFX68-LABEL: buffer_store:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; GFX68-NEXT:    buffer_store_dwordx4 v[4:7], off, s[0:3], 0 glc
; GFX68-NEXT:    buffer_store_dwordx4 v[8:11], off, s[0:3], 0 slc
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    s_clause 0x2
; GFX11-NEXT:    buffer_store_b128 v[0:3], off, s[0:3], 0
; GFX11-NEXT:    buffer_store_b128 v[4:7], off, s[0:3], 0 glc
; GFX11-NEXT:    buffer_store_b128 v[8:11], off, s[0:3], 0 slc
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float> %1, <4 x i32> %0, i32 0, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float> %2, <4 x i32> %0, i32 0, i32 0, i32 1)
  call void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float> %3, <4 x i32> %0, i32 0, i32 0, i32 2)
  ret void
}

define amdgpu_ps void @buffer_store_immoffs(<4 x i32> inreg, <4 x float>) {
; GFX68-LABEL: buffer_store_immoffs:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0 offset:42
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_immoffs:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b128 v[0:3], off, s[0:3], 0 offset:42
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float> %1, <4 x i32> %0, i32 42, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_ofs(<4 x i32> inreg, <4 x float>, i32) {
; GFX68-LABEL: buffer_store_ofs:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_dwordx4 v[0:3], v4, s[0:3], 0 offen
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_ofs:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b128 v[0:3], v4, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float> %1, <4 x i32> %0, i32 %2, i32 0, i32 0)
  ret void
}

; Ideally, the register allocator would avoid the wait here
define amdgpu_ps void @buffer_store_wait(<4 x i32> inreg, <4 x float>, i32, i32, i32) {
; VERDE-LABEL: buffer_store_wait:
; VERDE:       ; %bb.0: ; %main_body
; VERDE-NEXT:    buffer_store_dwordx4 v[0:3], v4, s[0:3], 0 offen
; VERDE-NEXT:    s_waitcnt expcnt(0)
; VERDE-NEXT:    buffer_load_dwordx4 v[0:3], v5, s[0:3], 0 offen
; VERDE-NEXT:    s_waitcnt vmcnt(0)
; VERDE-NEXT:    buffer_store_dwordx4 v[0:3], v6, s[0:3], 0 offen
; VERDE-NEXT:    s_endpgm
;
; GFX8-LABEL: buffer_store_wait:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    buffer_store_dwordx4 v[0:3], v4, s[0:3], 0 offen
; GFX8-NEXT:    buffer_load_dwordx4 v[0:3], v5, s[0:3], 0 offen
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    buffer_store_dwordx4 v[0:3], v6, s[0:3], 0 offen
; GFX8-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_wait:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b128 v[0:3], v4, s[0:3], 0 offen
; GFX11-NEXT:    buffer_load_b128 v[0:3], v5, s[0:3], 0 offen
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    buffer_store_b128 v[0:3], v6, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float> %1, <4 x i32> %0, i32 %2, i32 0, i32 0)
  %data = call <4 x float> @llvm.amdgcn.raw.buffer.load.v4f32(<4 x i32> %0, i32 %3, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float> %data, <4 x i32> %0, i32 %4, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x1(<4 x i32> inreg %rsrc, float %data, i32 %offset) {
; GFX68-LABEL: buffer_store_x1:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x1:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b32 v0, v1, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.f32(float %data, <4 x i32> %rsrc, i32 %offset, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x2(<4 x i32> inreg %rsrc, <2 x float> %data, i32 %offset) #0 {
; GFX68-LABEL: buffer_store_x2:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_dwordx2 v[0:1], v2, s[0:3], 0 offen
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x2:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b64 v[0:1], v2, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float> %data, <4 x i32> %rsrc, i32 %offset, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x1_offen_merged_and(<4 x i32> inreg %rsrc, i32 %a, float %v1, float %v2, float %v3, float %v4, float %v5, float %v6) {
; GFX68-LABEL: buffer_store_x1_offen_merged_and:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    buffer_store_dwordx4 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX68-NEXT:    buffer_store_dwordx2 v[5:6], v0, s[0:3], 0 offen offset:28
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x1_offen_merged_and:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    buffer_store_b128 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX11-NEXT:    buffer_store_b64 v[5:6], v0, s[0:3], 0 offen offset:28
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %a1 = add i32 %a, 4
  %a2 = add i32 %a, 8
  %a3 = add i32 %a, 12
  %a4 = add i32 %a, 16
  %a5 = add i32 %a, 28
  %a6 = add i32 %a, 32
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v1, <4 x i32> %rsrc, i32 %a1, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v2, <4 x i32> %rsrc, i32 %a2, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v3, <4 x i32> %rsrc, i32 %a3, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v4, <4 x i32> %rsrc, i32 %a4, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v5, <4 x i32> %rsrc, i32 %a5, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v6, <4 x i32> %rsrc, i32 %a6, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x1_offen_merged_or(<4 x i32> inreg %rsrc, i32 %inp, float %v1, float %v2, float %v3, float %v4, float %v5, float %v6) {
; GFX68-LABEL: buffer_store_x1_offen_merged_or:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    v_lshlrev_b32_e32 v0, 6, v0
; GFX68-NEXT:    buffer_store_dwordx4 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX68-NEXT:    buffer_store_dwordx2 v[5:6], v0, s[0:3], 0 offen offset:28
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x1_offen_merged_or:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    v_lshlrev_b32_e32 v0, 6, v0
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    buffer_store_b128 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX11-NEXT:    buffer_store_b64 v[5:6], v0, s[0:3], 0 offen offset:28
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %a = shl i32 %inp, 6
  %a1 = add i32 %a, 4
  %a2 = add i32 %a, 8
  %a3 = add i32 %a, 12
  %a4 = add i32 %a, 16
  %a5 = add i32 %a, 28
  %a6 = add i32 %a, 32
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v1, <4 x i32> %rsrc, i32 %a1, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v2, <4 x i32> %rsrc, i32 %a2, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v3, <4 x i32> %rsrc, i32 %a3, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v4, <4 x i32> %rsrc, i32 %a4, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v5, <4 x i32> %rsrc, i32 %a5, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v6, <4 x i32> %rsrc, i32 %a6, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x1_offen_merged_glc_slc(<4 x i32> inreg %rsrc, i32 %a, float %v1, float %v2, float %v3, float %v4, float %v5, float %v6) {
; GFX68-LABEL: buffer_store_x1_offen_merged_glc_slc:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    buffer_store_dwordx2 v[1:2], v0, s[0:3], 0 offen offset:4
; GFX68-NEXT:    buffer_store_dwordx2 v[3:4], v0, s[0:3], 0 offen offset:12 glc
; GFX68-NEXT:    buffer_store_dwordx2 v[5:6], v0, s[0:3], 0 offen offset:28 glc slc
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x1_offen_merged_glc_slc:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x2
; GFX11-NEXT:    buffer_store_b64 v[1:2], v0, s[0:3], 0 offen offset:4
; GFX11-NEXT:    buffer_store_b64 v[3:4], v0, s[0:3], 0 offen offset:12 glc
; GFX11-NEXT:    buffer_store_b64 v[5:6], v0, s[0:3], 0 offen offset:28 glc slc
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %a1 = add i32 %a, 4
  %a2 = add i32 %a, 8
  %a3 = add i32 %a, 12
  %a4 = add i32 %a, 16
  %a5 = add i32 %a, 28
  %a6 = add i32 %a, 32
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v1, <4 x i32> %rsrc, i32 %a1, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v2, <4 x i32> %rsrc, i32 %a2, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v3, <4 x i32> %rsrc, i32 %a3, i32 0, i32 1)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v4, <4 x i32> %rsrc, i32 %a4, i32 0, i32 1)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v5, <4 x i32> %rsrc, i32 %a5, i32 0, i32 3)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v6, <4 x i32> %rsrc, i32 %a6, i32 0, i32 3)
  ret void
}

define amdgpu_ps void @buffer_store_x2_offen_merged_and(<4 x i32> inreg %rsrc, i32 %a, <2 x float> %v1, <2 x float> %v2) {
; GFX68-LABEL: buffer_store_x2_offen_merged_and:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    buffer_store_dwordx4 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x2_offen_merged_and:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    buffer_store_b128 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %a1 = add i32 %a, 4
  %a2 = add i32 %a, 12
  call void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float> %v1, <4 x i32> %rsrc, i32 %a1, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float> %v2, <4 x i32> %rsrc, i32 %a2, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x2_offen_merged_or(<4 x i32> inreg %rsrc, i32 %inp, <2 x float> %v1, <2 x float> %v2) {
; GFX68-LABEL: buffer_store_x2_offen_merged_or:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    v_lshlrev_b32_e32 v0, 4, v0
; GFX68-NEXT:    buffer_store_dwordx4 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x2_offen_merged_or:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    v_lshlrev_b32_e32 v0, 4, v0
; GFX11-NEXT:    buffer_store_b128 v[1:4], v0, s[0:3], 0 offen offset:4
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %a = shl i32 %inp, 4
  %a1 = add i32 %a, 4
  %a2 = add i32 %a, 12
  call void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float> %v1, <4 x i32> %rsrc, i32 %a1, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float> %v2, <4 x i32> %rsrc, i32 %a2, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x1_offset_merged(<4 x i32> inreg %rsrc, float %v1, float %v2, float %v3, float %v4, float %v5, float %v6) {
; GFX68-LABEL: buffer_store_x1_offset_merged:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0 offset:4
; GFX68-NEXT:    buffer_store_dwordx2 v[4:5], off, s[0:3], 0 offset:28
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x1_offset_merged:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    buffer_store_b128 v[0:3], off, s[0:3], 0 offset:4
; GFX11-NEXT:    buffer_store_b64 v[4:5], off, s[0:3], 0 offset:28
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v1, <4 x i32> %rsrc, i32 4, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v2, <4 x i32> %rsrc, i32 8, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v3, <4 x i32> %rsrc, i32 12, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v4, <4 x i32> %rsrc, i32 16, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v5, <4 x i32> %rsrc, i32 28, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v6, <4 x i32> %rsrc, i32 32, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x2_offset_merged(<4 x i32> inreg %rsrc, <2 x float> %v1,<2 x float> %v2) {
; GFX68-LABEL: buffer_store_x2_offset_merged:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0 offset:4
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x2_offset_merged:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    buffer_store_b128 v[0:3], off, s[0:3], 0 offset:4
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float> %v1, <4 x i32> %rsrc, i32 4, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float> %v2, <4 x i32> %rsrc, i32 12, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_int(<4 x i32> inreg, <4 x i32>, <2 x i32>, i32) {
; GFX68-LABEL: buffer_store_int:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; GFX68-NEXT:    buffer_store_dwordx2 v[4:5], off, s[0:3], 0 glc
; GFX68-NEXT:    buffer_store_dword v6, off, s[0:3], 0 slc
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_int:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    s_clause 0x2
; GFX11-NEXT:    buffer_store_b128 v[0:3], off, s[0:3], 0
; GFX11-NEXT:    buffer_store_b64 v[4:5], off, s[0:3], 0 glc
; GFX11-NEXT:    buffer_store_b32 v6, off, s[0:3], 0 slc
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v4i32(<4 x i32> %1, <4 x i32> %0, i32 0, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.v2i32(<2 x i32> %2, <4 x i32> %0, i32 0, i32 0, i32 1)
  call void @llvm.amdgcn.raw.buffer.store.i32(i32 %3, <4 x i32> %0, i32 0, i32 0, i32 2)
  ret void
}

define amdgpu_ps void @raw_buffer_store_byte(<4 x i32> inreg %rsrc, float %v1) {
; GFX68-LABEL: raw_buffer_store_byte:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    v_cvt_u32_f32_e32 v0, v0
; GFX68-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: raw_buffer_store_byte:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    v_cvt_u32_f32_e32 v0, v0
; GFX11-NEXT:    buffer_store_b8 v0, off, s[0:3], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %v2 = fptoui float %v1 to i32
  %v3 = trunc i32 %v2 to i8
  call void @llvm.amdgcn.raw.buffer.store.i8(i8 %v3, <4 x i32> %rsrc, i32 0, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_short(<4 x i32> inreg %rsrc, float %v1) {
; GFX68-LABEL: raw_buffer_store_short:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    v_cvt_u32_f32_e32 v0, v0
; GFX68-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: raw_buffer_store_short:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    v_cvt_u32_f32_e32 v0, v0
; GFX11-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %v2 = fptoui float %v1 to i32
  %v3 = trunc i32 %v2 to i16
  call void @llvm.amdgcn.raw.buffer.store.i16(i16 %v3, <4 x i32> %rsrc, i32 0, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_f16(<4 x i32> inreg %rsrc, i32 %v1) {
; GFX68-LABEL: raw_buffer_store_f16:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: raw_buffer_store_f16:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %trunc = trunc i32 %v1 to i16
  %cast = bitcast i16 %trunc to half
  call void @llvm.amdgcn.raw.buffer.store.f16(half %cast, <4 x i32> %rsrc, i32 0, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_v2f16(<4 x i32> inreg %rsrc, <2 x half> %data, i32 %offset) {
; VERDE-LABEL: buffer_store_v2f16:
; VERDE:       ; %bb.0: ; %main_body
; VERDE-NEXT:    v_cvt_f16_f32_e32 v1, v1
; VERDE-NEXT:    v_cvt_f16_f32_e32 v0, v0
; VERDE-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; VERDE-NEXT:    v_or_b32_e32 v0, v0, v1
; VERDE-NEXT:    buffer_store_dword v0, v2, s[0:3], 0 offen
; VERDE-NEXT:    s_endpgm
;
; GFX8-LABEL: buffer_store_v2f16:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX8-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_v2f16:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b32 v0, v1, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v2f16(<2 x half> %data, <4 x i32> %rsrc, i32 %offset, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_v4f16(<4 x i32> inreg %rsrc, <4 x half> %data, i32 %offset) #0 {
; VERDE-LABEL: buffer_store_v4f16:
; VERDE:       ; %bb.0: ; %main_body
; VERDE-NEXT:    v_cvt_f16_f32_e32 v3, v3
; VERDE-NEXT:    v_cvt_f16_f32_e32 v2, v2
; VERDE-NEXT:    v_cvt_f16_f32_e32 v5, v1
; VERDE-NEXT:    v_cvt_f16_f32_e32 v0, v0
; VERDE-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; VERDE-NEXT:    v_or_b32_e32 v1, v2, v1
; VERDE-NEXT:    v_lshlrev_b32_e32 v2, 16, v5
; VERDE-NEXT:    v_or_b32_e32 v0, v0, v2
; VERDE-NEXT:    buffer_store_dwordx2 v[0:1], v4, s[0:3], 0 offen
; VERDE-NEXT:    s_endpgm
;
; GFX8-LABEL: buffer_store_v4f16:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    buffer_store_dwordx2 v[0:1], v2, s[0:3], 0 offen
; GFX8-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_v4f16:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b64 v[0:1], v2, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v4f16(<4 x half> %data, <4 x i32> %rsrc, i32 %offset, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_i16(<4 x i32> inreg %rsrc, i32 %v1) {
; GFX68-LABEL: raw_buffer_store_i16:
; GFX68:       ; %bb.0: ; %main_body
; GFX68-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: raw_buffer_store_i16:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %trunc = trunc i32 %v1 to i16
  call void @llvm.amdgcn.raw.buffer.store.i16(i16 %trunc, <4 x i32> %rsrc, i32 0, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_v2i16(<4 x i32> inreg %rsrc, <2 x i16> %data, i32 %offset) {
; VERDE-LABEL: buffer_store_v2i16:
; VERDE:       ; %bb.0: ; %main_body
; VERDE-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; VERDE-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; VERDE-NEXT:    v_or_b32_e32 v0, v0, v1
; VERDE-NEXT:    buffer_store_dword v0, v2, s[0:3], 0 offen
; VERDE-NEXT:    s_endpgm
;
; GFX8-LABEL: buffer_store_v2i16:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX8-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_v2i16:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b32 v0, v1, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v2i16(<2 x i16> %data, <4 x i32> %rsrc, i32 %offset, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_v4i16(<4 x i32> inreg %rsrc, <4 x i16> %data, i32 %offset) #0 {
; VERDE-LABEL: buffer_store_v4i16:
; VERDE:       ; %bb.0: ; %main_body
; VERDE-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; VERDE-NEXT:    v_and_b32_e32 v2, 0xffff, v2
; VERDE-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; VERDE-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; VERDE-NEXT:    v_or_b32_e32 v2, v2, v3
; VERDE-NEXT:    v_or_b32_e32 v1, v0, v1
; VERDE-NEXT:    buffer_store_dwordx2 v[1:2], v4, s[0:3], 0 offen
; VERDE-NEXT:    s_endpgm
;
; GFX8-LABEL: buffer_store_v4i16:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    buffer_store_dwordx2 v[0:1], v2, s[0:3], 0 offen
; GFX8-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_v4i16:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    buffer_store_b64 v[0:1], v2, s[0:3], 0 offen
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.buffer.store.v4i16(<4 x i16> %data, <4 x i32> %rsrc, i32 %offset, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_x1_offset_merged(<4 x i32> inreg %rsrc, float %v1, float %v2, float %v3, float %v4, float %v5, float %v6) {
; GFX68-LABEL: raw_buffer_store_x1_offset_merged:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0 offset:4
; GFX68-NEXT:    buffer_store_dwordx2 v[4:5], off, s[0:3], 0 offset:28
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: raw_buffer_store_x1_offset_merged:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    buffer_store_b128 v[0:3], off, s[0:3], 0 offset:4
; GFX11-NEXT:    buffer_store_b64 v[4:5], off, s[0:3], 0 offset:28
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v1, <4 x i32> %rsrc, i32 4, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v2, <4 x i32> %rsrc, i32 8, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v3, <4 x i32> %rsrc, i32 12, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v4, <4 x i32> %rsrc, i32 16, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v5, <4 x i32> %rsrc, i32 28, i32 0, i32 0)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v6, <4 x i32> %rsrc, i32 32, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_x1_offset_swizzled_not_merged(<4 x i32> inreg %rsrc, float %v1, float %v2, float %v3, float %v4, float %v5, float %v6) {
; GFX68-LABEL: raw_buffer_store_x1_offset_swizzled_not_merged:
; GFX68:       ; %bb.0:
; GFX68-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:4
; GFX68-NEXT:    buffer_store_dword v1, off, s[0:3], 0 offset:8
; GFX68-NEXT:    buffer_store_dword v2, off, s[0:3], 0 offset:12
; GFX68-NEXT:    buffer_store_dword v3, off, s[0:3], 0 offset:16
; GFX68-NEXT:    buffer_store_dword v4, off, s[0:3], 0 offset:28
; GFX68-NEXT:    buffer_store_dword v5, off, s[0:3], 0 offset:32
; GFX68-NEXT:    s_endpgm
;
; GFX11-LABEL: raw_buffer_store_x1_offset_swizzled_not_merged:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x5
; GFX11-NEXT:    buffer_store_b32 v0, off, s[0:3], 0 offset:4
; GFX11-NEXT:    buffer_store_b32 v1, off, s[0:3], 0 offset:8
; GFX11-NEXT:    buffer_store_b32 v2, off, s[0:3], 0 offset:12
; GFX11-NEXT:    buffer_store_b32 v3, off, s[0:3], 0 offset:16
; GFX11-NEXT:    buffer_store_b32 v4, off, s[0:3], 0 offset:28
; GFX11-NEXT:    buffer_store_b32 v5, off, s[0:3], 0 offset:32
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v1, <4 x i32> %rsrc, i32 4, i32 0, i32 8)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v2, <4 x i32> %rsrc, i32 8, i32 0, i32 8)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v3, <4 x i32> %rsrc, i32 12, i32 0, i32 8)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v4, <4 x i32> %rsrc, i32 16, i32 0, i32 8)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v5, <4 x i32> %rsrc, i32 28, i32 0, i32 8)
  call void @llvm.amdgcn.raw.buffer.store.f32(float %v6, <4 x i32> %rsrc, i32 32, i32 0, i32 8)
  ret void
}

declare void @llvm.amdgcn.raw.buffer.store.f32(float, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v2f32(<2 x float>, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v4f32(<4 x float>, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.i32(i32, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v2i32(<2 x i32>, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v4i32(<4 x i32>, <4 x i32>, i32, i32, i32) #0
declare <4 x float> @llvm.amdgcn.raw.buffer.load.v4f32(<4 x i32>, i32, i32, i32) #1
declare void @llvm.amdgcn.raw.buffer.store.i8(i8, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.f16(half, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v2f16(<2 x half>, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v4f16(<4 x half>, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.i16(i16, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v2i16(<2 x i16>, <4 x i32>, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.buffer.store.v4i16(<4 x i16>, <4 x i32>, i32, i32, i32) #0

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }