; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -o - -mcpu=btver2 -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

define <8 x i32> @_Z6test70v(<4 x i32>* %id14793) {
; CHECK-LABEL: _Z6test70v:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovaps (%rdi), %xmm0
; CHECK-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0],mem[1],xmm0[2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,3,1,0]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm1 = xmm1[0,2,1,0]
; CHECK-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %id14793.0.id14793.0. = load <4 x i32>, <4 x i32>* %id14793, align 16
  %shuffle = shufflevector <4 x i32> %id14793.0.id14793.0., <4 x i32> <i32 undef, i32 -1052558824, i32 undef, i32 undef>, <8 x i32> <i32 0, i32 2, i32 5, i32 0, i32 1, i32 3, i32 1, i32 0>
  ret <8 x i32> %shuffle
}