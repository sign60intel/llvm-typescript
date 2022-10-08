; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512fp16  | FileCheck %s --check-prefixes=X64-AVX512FP16

; This should do a single load into the fp stack for the return, not diddle with xmm registers.

define half @fcmp_select_fp_constants_olt(half %x) nounwind readnone {
; X64-AVX512FP16-LABEL: fcmp_select_fp_constants_olt:
; X64-AVX512FP16:       # %bb.0:
; X64-AVX512FP16-NEXT:    vmovsh {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; X64-AVX512FP16-NEXT:    vcmpltsh {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %k1
; X64-AVX512FP16-NEXT:    vmovsh {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-AVX512FP16-NEXT:    vmovsh %xmm1, %xmm0, %xmm0 {%k1}
; X64-AVX512FP16-NEXT:    retq
  %c = fcmp olt half %x, -4.0
  %r = select i1 %c, half 42.0, half 23.0
  ret half %r
}

define half @fcmp_select_fp_constants_ogt(half %x) nounwind readnone {
; X64-AVX512FP16-LABEL: fcmp_select_fp_constants_ogt:
; X64-AVX512FP16:       # %bb.0:
; X64-AVX512FP16-NEXT:    vmovsh {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; X64-AVX512FP16-NEXT:    vcmpgtsh {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %k1
; X64-AVX512FP16-NEXT:    vmovsh {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-AVX512FP16-NEXT:    vmovsh %xmm1, %xmm0, %xmm0 {%k1}
; X64-AVX512FP16-NEXT:    retq
  %c = fcmp ogt half %x, -4.0
  %r = select i1 %c, half 42.0, half 23.0
  ret half %r
}
