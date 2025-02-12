; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mattr=+simd128 | FileCheck %s

;; Check that masked shift counts are optimized out.

;; TODO: optimize the *_late functions.

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

define i32 @shl_i32(i32 %v, i32 %x) {
; CHECK-LABEL: shl_i32:
; CHECK:         .functype shl_i32 (i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.shl
; CHECK-NEXT:    # fallthrough-return
  %m = and i32 %x, 31
  %a = shl i32 %v, %m
  ret i32 %a
}

define i32 @sra_i32(i32 %v, i32 %x) {
; CHECK-LABEL: sra_i32:
; CHECK:         .functype sra_i32 (i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.shr_s
; CHECK-NEXT:    # fallthrough-return
  %m = and i32 %x, 31
  %a = ashr i32 %v, %m
  ret i32 %a
}

define i32 @srl_i32(i32 %v, i32 %x) {
; CHECK-LABEL: srl_i32:
; CHECK:         .functype srl_i32 (i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.shr_u
; CHECK-NEXT:    # fallthrough-return
  %m = and i32 %x, 31
  %a = lshr i32 %v, %m
  ret i32 %a
}

define i64 @shl_i64(i64 %v, i64 %x) {
; CHECK-LABEL: shl_i64:
; CHECK:         .functype shl_i64 (i64, i64) -> (i64)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i64.shl
; CHECK-NEXT:    # fallthrough-return
  %m = and i64 %x, 63
  %a = shl i64 %v, %m
  ret i64 %a
}

define i64 @sra_i64(i64 %v, i64 %x) {
; CHECK-LABEL: sra_i64:
; CHECK:         .functype sra_i64 (i64, i64) -> (i64)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i64.shr_s
; CHECK-NEXT:    # fallthrough-return
  %m = and i64 %x, 63
  %a = ashr i64 %v, %m
  ret i64 %a
}

define i64 @srl_i64(i64 %v, i64 %x) {
; CHECK-LABEL: srl_i64:
; CHECK:         .functype srl_i64 (i64, i64) -> (i64)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i64.shr_u
; CHECK-NEXT:    # fallthrough-return
  %m = and i64 %x, 63
  %a = lshr i64 %v, %m
  ret i64 %a
}

define <16 x i8> @shl_v16i8(<16 x i8> %v, i8 %x) {
; CHECK-LABEL: shl_v16i8:
; CHECK:         .functype shl_v16i8 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shl
; CHECK-NEXT:    # fallthrough-return
  %m = and i8 %x, 7
  %t = insertelement <16 x i8> undef, i8 %m, i32 0
  %s = shufflevector <16 x i8> %t, <16 x i8> undef,
    <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
                i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %a = shl <16 x i8> %v, %s
  ret <16 x i8> %a
}

define <16 x i8> @shl_v16i8_late(<16 x i8> %v, i8 %x) {
; CHECK-LABEL: shl_v16i8_late:
; CHECK:         .functype shl_v16i8_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.splat
; CHECK-NEXT:    v128.const 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i8x16.extract_lane_u 0
; CHECK-NEXT:    i8x16.shl
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <16 x i8> undef, i8 %x, i32 0
  %s = shufflevector <16 x i8> %t, <16 x i8> undef,
    <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
                i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %m = and <16 x i8> %s, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,
                          i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %a = shl <16 x i8> %v, %m
  ret <16 x i8> %a
}

define <16 x i8> @ashr_v16i8(<16 x i8> %v, i8 %x) {
; CHECK-LABEL: ashr_v16i8:
; CHECK:         .functype ashr_v16i8 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shr_s
; CHECK-NEXT:    # fallthrough-return
  %m = and i8 %x, 7
  %t = insertelement <16 x i8> undef, i8 %m, i32 0
  %s = shufflevector <16 x i8> %t, <16 x i8> undef,
    <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
                i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %a = ashr <16 x i8> %v, %s
  ret <16 x i8> %a
}

define <16 x i8> @ashr_v16i8_late(<16 x i8> %v, i8 %x) {
; CHECK-LABEL: ashr_v16i8_late:
; CHECK:         .functype ashr_v16i8_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.splat
; CHECK-NEXT:    v128.const 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i8x16.extract_lane_u 0
; CHECK-NEXT:    i8x16.shr_s
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <16 x i8> undef, i8 %x, i32 0
  %s = shufflevector <16 x i8> %t, <16 x i8> undef,
    <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
                i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %m = and <16 x i8> %s, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,
                          i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %a = ashr <16 x i8> %v, %m
  ret <16 x i8> %a
}

define <16 x i8> @lshr_v16i8(<16 x i8> %v, i8 %x) {
; CHECK-LABEL: lshr_v16i8:
; CHECK:         .functype lshr_v16i8 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shr_u
; CHECK-NEXT:    # fallthrough-return
  %m = and i8 %x, 7
  %t = insertelement <16 x i8> undef, i8 %m, i32 0
  %s = shufflevector <16 x i8> %t, <16 x i8> undef,
    <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
                i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %a = lshr <16 x i8> %v, %s
  ret <16 x i8> %a
}

define <16 x i8> @lshr_v16i8_late(<16 x i8> %v, i8 %x) {
; CHECK-LABEL: lshr_v16i8_late:
; CHECK:         .functype lshr_v16i8_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.splat
; CHECK-NEXT:    v128.const 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i8x16.extract_lane_u 0
; CHECK-NEXT:    i8x16.shr_u
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <16 x i8> undef, i8 %x, i32 0
  %s = shufflevector <16 x i8> %t, <16 x i8> undef,
    <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
                i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %m = and <16 x i8> %s, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,
                          i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %a = lshr <16 x i8> %v, %m
  ret <16 x i8> %a
}

define <8 x i16> @shl_v8i16(<8 x i16> %v, i16 %x) {
; CHECK-LABEL: shl_v8i16:
; CHECK:         .functype shl_v8i16 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i16x8.shl
; CHECK-NEXT:    # fallthrough-return
  %m = and i16 %x, 15
  %t = insertelement <8 x i16> undef, i16 %m, i32 0
  %s = shufflevector <8 x i16> %t, <8 x i16> undef,
    <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %a = shl <8 x i16> %v, %s
  ret <8 x i16> %a
}

define <8 x i16> @shl_v8i16_late(<8 x i16> %v, i16 %x) {
; CHECK-LABEL: shl_v8i16_late:
; CHECK:         .functype shl_v8i16_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i16x8.splat
; CHECK-NEXT:    v128.const 15, 15, 15, 15, 15, 15, 15, 15
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.extract_lane_u 0
; CHECK-NEXT:    i16x8.shl
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <8 x i16> undef, i16 %x, i32 0
  %s = shufflevector <8 x i16> %t, <8 x i16> undef,
    <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %m = and <8 x i16> %s,
    <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %a = shl <8 x i16> %v, %m
  ret <8 x i16> %a
}

define <8 x i16> @ashr_v8i16(<8 x i16> %v, i16 %x) {
; CHECK-LABEL: ashr_v8i16:
; CHECK:         .functype ashr_v8i16 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i16x8.shr_s
; CHECK-NEXT:    # fallthrough-return
  %m = and i16 %x, 15
  %t = insertelement <8 x i16> undef, i16 %m, i32 0
  %s = shufflevector <8 x i16> %t, <8 x i16> undef,
    <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %a = ashr <8 x i16> %v, %s
  ret <8 x i16> %a
}

define <8 x i16> @ashr_v8i16_late(<8 x i16> %v, i16 %x) {
; CHECK-LABEL: ashr_v8i16_late:
; CHECK:         .functype ashr_v8i16_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i16x8.splat
; CHECK-NEXT:    v128.const 15, 15, 15, 15, 15, 15, 15, 15
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.extract_lane_u 0
; CHECK-NEXT:    i16x8.shr_s
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <8 x i16> undef, i16 %x, i32 0
  %s = shufflevector <8 x i16> %t, <8 x i16> undef,
    <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %m = and <8 x i16> %s,
    <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %a = ashr <8 x i16> %v, %m
  ret <8 x i16> %a
}

define <8 x i16> @lshr_v8i16(<8 x i16> %v, i16 %x) {
; CHECK-LABEL: lshr_v8i16:
; CHECK:         .functype lshr_v8i16 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i16x8.shr_u
; CHECK-NEXT:    # fallthrough-return
  %m = and i16 %x, 15
  %t = insertelement <8 x i16> undef, i16 %m, i32 0
  %s = shufflevector <8 x i16> %t, <8 x i16> undef,
    <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %a = lshr <8 x i16> %v, %s
  ret <8 x i16> %a
}

define <8 x i16> @lshr_v8i16_late(<8 x i16> %v, i16 %x) {
; CHECK-LABEL: lshr_v8i16_late:
; CHECK:         .functype lshr_v8i16_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i16x8.splat
; CHECK-NEXT:    v128.const 15, 15, 15, 15, 15, 15, 15, 15
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i16x8.extract_lane_u 0
; CHECK-NEXT:    i16x8.shr_u
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <8 x i16> undef, i16 %x, i32 0
  %s = shufflevector <8 x i16> %t, <8 x i16> undef,
    <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %m = and <8 x i16> %s,
    <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %a = lshr <8 x i16> %v, %m
  ret <8 x i16> %a
}

define <4 x i32> @shl_v4i32(<4 x i32> %v, i32 %x) {
; CHECK-LABEL: shl_v4i32:
; CHECK:         .functype shl_v4i32 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32x4.shl
; CHECK-NEXT:    # fallthrough-return
  %m = and i32 %x, 31
  %t = insertelement <4 x i32> undef, i32 %m, i32 0
  %s = shufflevector <4 x i32> %t, <4 x i32> undef,
    <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  %a = shl <4 x i32> %v, %s
  ret <4 x i32> %a
}

define <4 x i32> @shl_v4i32_late(<4 x i32> %v, i32 %x) {
; CHECK-LABEL: shl_v4i32_late:
; CHECK:         .functype shl_v4i32_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32x4.splat
; CHECK-NEXT:    v128.const 31, 31, 31, 31
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i32x4.extract_lane 0
; CHECK-NEXT:    i32x4.shl
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <4 x i32> undef, i32 %x, i32 0
  %s = shufflevector <4 x i32> %t, <4 x i32> undef,
    <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  %m = and <4 x i32> %s, <i32 31, i32 31, i32 31, i32 31>
  %a = shl <4 x i32> %v, %m
  ret <4 x i32> %a
}

define <4 x i32> @ashr_v4i32(<4 x i32> %v, i32 %x) {
; CHECK-LABEL: ashr_v4i32:
; CHECK:         .functype ashr_v4i32 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32x4.shr_s
; CHECK-NEXT:    # fallthrough-return
  %m = and i32 %x, 31
  %t = insertelement <4 x i32> undef, i32 %m, i32 0
  %s = shufflevector <4 x i32> %t, <4 x i32> undef,
    <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  %a = ashr <4 x i32> %v, %s
  ret <4 x i32> %a
}

define <4 x i32> @ashr_v4i32_late(<4 x i32> %v, i32 %x) {
; CHECK-LABEL: ashr_v4i32_late:
; CHECK:         .functype ashr_v4i32_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32x4.splat
; CHECK-NEXT:    v128.const 31, 31, 31, 31
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i32x4.extract_lane 0
; CHECK-NEXT:    i32x4.shr_s
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <4 x i32> undef, i32 %x, i32 0
  %s = shufflevector <4 x i32> %t, <4 x i32> undef,
    <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  %m = and <4 x i32> %s, <i32 31, i32 31, i32 31, i32 31>
  %a = ashr <4 x i32> %v, %m
  ret <4 x i32> %a
}

define <4 x i32> @lshr_v4i32(<4 x i32> %v, i32 %x) {
; CHECK-LABEL: lshr_v4i32:
; CHECK:         .functype lshr_v4i32 (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32x4.shr_u
; CHECK-NEXT:    # fallthrough-return
  %m = and i32 %x, 31
  %t = insertelement <4 x i32> undef, i32 %m, i32 0
  %s = shufflevector <4 x i32> %t, <4 x i32> undef,
    <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  %a = lshr <4 x i32> %v, %s
  ret <4 x i32> %a
}

define <4 x i32> @lshr_v4i32_late(<4 x i32> %v, i32 %x) {
; CHECK-LABEL: lshr_v4i32_late:
; CHECK:         .functype lshr_v4i32_late (v128, i32) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32x4.splat
; CHECK-NEXT:    v128.const 31, 31, 31, 31
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i32x4.extract_lane 0
; CHECK-NEXT:    i32x4.shr_u
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <4 x i32> undef, i32 %x, i32 0
  %s = shufflevector <4 x i32> %t, <4 x i32> undef,
    <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  %m = and <4 x i32> %s, <i32 31, i32 31, i32 31, i32 31>
  %a = lshr <4 x i32> %v, %m
  ret <4 x i32> %a
}

define <2 x i64> @shl_v2i64(<2 x i64> %v, i64 %x) {
; CHECK-LABEL: shl_v2i64:
; CHECK:         .functype shl_v2i64 (v128, i64) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.wrap_i64
; CHECK-NEXT:    i64x2.shl
; CHECK-NEXT:    # fallthrough-return
  %m = and i64 %x, 63
  %t = insertelement <2 x i64> undef, i64 %m, i32 0
  %s = shufflevector <2 x i64> %t, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %a = shl <2 x i64> %v, %s
  ret <2 x i64> %a
}

define <2 x i64> @shl_v2i64_late(<2 x i64> %v, i64 %x) {
; CHECK-LABEL: shl_v2i64_late:
; CHECK:         .functype shl_v2i64_late (v128, i64) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i64x2.splat
; CHECK-NEXT:    v128.const 63, 63
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i64x2.extract_lane 0
; CHECK-NEXT:    i32.wrap_i64
; CHECK-NEXT:    i64x2.shl
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <2 x i64> undef, i64 %x, i32 0
  %s = shufflevector <2 x i64> %t, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %m = and <2 x i64> %s, <i64 63, i64 63>
  %a = shl <2 x i64> %v, %m
  ret <2 x i64> %a
}

define <2 x i64> @ashr_v2i64(<2 x i64> %v, i64 %x) {
; CHECK-LABEL: ashr_v2i64:
; CHECK:         .functype ashr_v2i64 (v128, i64) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.wrap_i64
; CHECK-NEXT:    i64x2.shr_s
; CHECK-NEXT:    # fallthrough-return
  %m = and i64 %x, 63
  %t = insertelement <2 x i64> undef, i64 %m, i32 0
  %s = shufflevector <2 x i64> %t, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %a = ashr <2 x i64> %v, %s
  ret <2 x i64> %a
}

define <2 x i64> @ashr_v2i64_late(<2 x i64> %v, i64 %x) {
; CHECK-LABEL: ashr_v2i64_late:
; CHECK:         .functype ashr_v2i64_late (v128, i64) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i64x2.splat
; CHECK-NEXT:    v128.const 63, 63
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i64x2.extract_lane 0
; CHECK-NEXT:    i32.wrap_i64
; CHECK-NEXT:    i64x2.shr_s
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <2 x i64> undef, i64 %x, i32 0
  %s = shufflevector <2 x i64> %t, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %m = and <2 x i64> %s, <i64 63, i64 63>
  %a = ashr <2 x i64> %v, %m
  ret <2 x i64> %a
}

define <2 x i64> @lshr_v2i64(<2 x i64> %v, i64 %x) {
; CHECK-LABEL: lshr_v2i64:
; CHECK:         .functype lshr_v2i64 (v128, i64) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.wrap_i64
; CHECK-NEXT:    i64x2.shr_u
; CHECK-NEXT:    # fallthrough-return
  %m = and i64 %x, 63
  %t = insertelement <2 x i64> undef, i64 %m, i32 0
  %s = shufflevector <2 x i64> %t, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %a = lshr <2 x i64> %v, %s
  ret <2 x i64> %a
}

define <2 x i64> @lshr_v2i64_late(<2 x i64> %v, i64 %x) {
; CHECK-LABEL: lshr_v2i64_late:
; CHECK:         .functype lshr_v2i64_late (v128, i64) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i64x2.splat
; CHECK-NEXT:    v128.const 63, 63
; CHECK-NEXT:    v128.and
; CHECK-NEXT:    i64x2.extract_lane 0
; CHECK-NEXT:    i32.wrap_i64
; CHECK-NEXT:    i64x2.shr_u
; CHECK-NEXT:    # fallthrough-return
  %t = insertelement <2 x i64> undef, i64 %x, i32 0
  %s = shufflevector <2 x i64> %t, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %m = and <2 x i64> %s, <i64 63, i64 63>
  %a = lshr <2 x i64> %v, %m
  ret <2 x i64> %a
}
